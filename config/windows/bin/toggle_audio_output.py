"""
toggle_audio_output.py — Audio Interface Toggle (Windows)
=========================================================
Requirements:  pip install keyboard comtypes pystray pillow

USAGE
-----
  python toggle_audio_output.py                  # hotkey mode (CLI, Ctrl+C to quit)
  python toggle_audio_output.py --dock           # system tray mode
  python toggle_audio_output.py --list           # print all active output devices
  python toggle_audio_output.py --set "Scarlett" # immediately switch to a device
  python toggle_audio_output.py --help           # show this help

CONFIGURATION
-------------
Edit DEVICE_1, DEVICE_2, and HOTKEY below, or pass --device1 / --device2 / --hotkey.
"""

import sys
import ctypes
import argparse
import threading
import winreg

# ── Optional imports (only required for certain modes) ───────────────────────

def _require(package, pip_name=None):
    import importlib
    try:
        return importlib.import_module(package)
    except ImportError:
        sys.exit(f"Missing dependency: pip install {pip_name or package}")


# ══════════════════════════════════════════════════════════════════════════════
#  DEFAULTS  (override via CLI flags or edit here)
# ══════════════════════════════════════════════════════════════════════════════

DEVICE_1 = "Scarlett"        # ← substring of your first device name
DEVICE_2 = "USB Audio CODEC" # ← substring of your second device name
HOTKEY   = "ctrl+alt+a"      # ← change to any combo you like

# ══════════════════════════════════════════════════════════════════════════════


# ── COM definitions ───────────────────────────────────────────────────────────

import comtypes
import comtypes.client

class IMMDevice(comtypes.IUnknown):
    _iid_ = comtypes.GUID("{D666063F-1587-4E43-81F1-B948E807363F}")
    _methods_ = [
        comtypes.STDMETHOD(comtypes.HRESULT, "Activate"),
        comtypes.STDMETHOD(comtypes.HRESULT, "OpenPropertyStore"),
        comtypes.STDMETHOD(comtypes.HRESULT, "GetId",
                           [ctypes.POINTER(ctypes.c_wchar_p)]),
        comtypes.STDMETHOD(comtypes.HRESULT, "GetState"),
    ]

class IMMDeviceCollection(comtypes.IUnknown):
    _iid_ = comtypes.GUID("{0BD7A1BE-7A1A-44DB-8397-CC5392387B5E}")
    _methods_ = [
        comtypes.STDMETHOD(comtypes.HRESULT, "GetCount",
                           [ctypes.POINTER(ctypes.c_uint)]),
        comtypes.STDMETHOD(comtypes.HRESULT, "Item",
                           [ctypes.c_uint, ctypes.POINTER(ctypes.POINTER(IMMDevice))]),
    ]

class IMMDeviceEnumerator(comtypes.IUnknown):
    _iid_ = comtypes.GUID("{A95664D2-9614-4F35-A746-DE8DB63617E6}")
    _methods_ = [
        comtypes.STDMETHOD(comtypes.HRESULT, "EnumAudioEndpoints",
                           [ctypes.c_uint, ctypes.c_uint,
                            ctypes.POINTER(ctypes.POINTER(IMMDeviceCollection))]),
        comtypes.STDMETHOD(comtypes.HRESULT, "GetDefaultAudioEndpoint"),
        comtypes.STDMETHOD(comtypes.HRESULT, "GetDevice"),
        comtypes.STDMETHOD(comtypes.HRESULT, "RegisterEndpointNotificationCallback"),
        comtypes.STDMETHOD(comtypes.HRESULT, "UnregisterEndpointNotificationCallback"),
    ]

CLSID_MMDeviceEnumerator = comtypes.GUID("{BCDE0395-E52F-467C-8E3D-C4579291692E}")

class IPolicyConfig(comtypes.IUnknown):
    _iid_ = comtypes.GUID("{f8679f50-850a-41cf-9c72-430f290290c8}")
    _methods_ = [
        comtypes.STDMETHOD(comtypes.HRESULT, "GetMixFormat"),
        comtypes.STDMETHOD(comtypes.HRESULT, "GetDeviceFormat"),
        comtypes.STDMETHOD(comtypes.HRESULT, "ResetDeviceFormat"),
        comtypes.STDMETHOD(comtypes.HRESULT, "SetDeviceFormat"),
        comtypes.STDMETHOD(comtypes.HRESULT, "GetProcessingPeriod"),
        comtypes.STDMETHOD(comtypes.HRESULT, "SetProcessingPeriod"),
        comtypes.STDMETHOD(comtypes.HRESULT, "GetShareMode"),
        comtypes.STDMETHOD(comtypes.HRESULT, "SetShareMode"),
        comtypes.STDMETHOD(comtypes.HRESULT, "GetPropertyValue"),
        comtypes.STDMETHOD(comtypes.HRESULT, "SetPropertyValue"),
        comtypes.STDMETHOD(comtypes.HRESULT, "SetDefaultEndpoint",
                           [ctypes.c_wchar_p, ctypes.c_uint]),
        comtypes.STDMETHOD(comtypes.HRESULT, "SetEndpointVisibility"),
    ]

CLSID_PolicyConfig = comtypes.GUID("{870af99c-171d-4f9e-af0d-e63df40c2bc9}")


# ── Device helpers ────────────────────────────────────────────────────────────

def _get_friendly_name(device_id: str) -> str:
    try:
        guid = device_id.split(".{")[1].rstrip("}")
        key_path = (
            rf"SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices"
            rf"\Audio\Render\{{{guid}}}\Properties"
        )
        with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, key_path) as key:
            for reg_val in ("{b3f8fa53-0004-438e-9003-51a46e139bfc},6",
                            "{a45c254e-df1c-4efd-8020-67d146a850e0},2"):
                try:
                    name, _ = winreg.QueryValueEx(key, reg_val)
                    if name:
                        return name
                except FileNotFoundError:
                    continue
    except Exception:
        pass
    return None


def list_devices() -> list:
    """Return [(friendly_name, device_id), ...] for all active render endpoints."""
    comtypes.CoInitialize()
    try:
        enumerator = comtypes.CoCreateInstance(
            CLSID_MMDeviceEnumerator, IMMDeviceEnumerator, comtypes.CLSCTX_INPROC_SERVER)
        collection_ptr = ctypes.POINTER(IMMDeviceCollection)()
        enumerator.EnumAudioEndpoints(0, 1, ctypes.byref(collection_ptr))
        count = ctypes.c_uint(0)
        collection_ptr.GetCount(ctypes.byref(count))
        results = []
        for i in range(count.value):
            device_ptr = ctypes.POINTER(IMMDevice)()
            collection_ptr.Item(i, ctypes.byref(device_ptr))
            dev_id_ptr = ctypes.c_wchar_p()
            device_ptr.GetId(ctypes.byref(dev_id_ptr))
            dev_id = dev_id_ptr.value
            friendly = _get_friendly_name(dev_id) or dev_id
            results.append((friendly, dev_id))
        return results
    finally:
        comtypes.CoUninitialize()


def set_default_device(device_id: str) -> None:
    """Switch default playback device across all roles (safe to call from any thread)."""
    comtypes.CoInitialize()
    try:
        policy = comtypes.CoCreateInstance(
            CLSID_PolicyConfig, IPolicyConfig, comtypes.CLSCTX_ALL)
        for role in (0, 1, 2):  # eConsole, eMultimedia, eCommunications
            policy.SetDefaultEndpoint(device_id, role)
    finally:
        comtypes.CoUninitialize()


def find_device(name_fragment: str, devices: list):
    """Case-insensitive substring match. Returns (name, id) or None."""
    frag = name_fragment.lower()
    for name, dev_id in devices:
        if frag in name.lower():
            return name, dev_id
    return None


def resolve_devices(d1_frag: str, d2_frag: str, devices: list, fatal=True):
    """Find both devices; print helpful error and exit if not found (when fatal=True)."""
    dev1 = find_device(d1_frag, devices)
    dev2 = find_device(d2_frag, devices)
    missing = []
    if not dev1:
        missing.append(f"  DEVICE_1: no match for '{d1_frag}'")
    if not dev2:
        missing.append(f"  DEVICE_2: no match for '{d2_frag}'")
    if missing and fatal:
        print("Error: could not find configured device(s):\n" + "\n".join(missing))
        print("\nActive devices:")
        for name, _ in devices:
            print(f"  • {name}")
        print("\nRun with --list to see all devices, or update DEVICE_1/DEVICE_2.")
        sys.exit(1)
    return dev1, dev2


# ── Toggle state ──────────────────────────────────────────────────────────────

_current   = 1
_lock      = threading.Lock()
_tray_icon = None
_dev1      = None
_dev2      = None


def toggle() -> None:
    global _current
    with _lock:
        if _current == 1:
            name, dev_id = _dev2
            _current = 2
        else:
            name, dev_id = _dev1
            _current = 1
        print(f"  → Switched to: {name}")
        set_default_device(dev_id)
        if _tray_icon:
            _tray_icon.title = f"Audio: {name}"


# ── Tray icon (--dock mode) ───────────────────────────────────────────────────

def _make_icon_image():
    from PIL import Image, ImageDraw
    img = Image.new("RGBA", (64, 64), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.polygon([(10, 22), (28, 22), (42, 10), (42, 54), (28, 42), (10, 42)],
              fill=(255, 255, 255, 255))
    d.arc([46, 18, 62, 46], start=-60, end=60, fill=(255, 255, 255, 200), width=3)
    d.arc([50, 24, 64, 40], start=-60, end=60, fill=(255, 255, 255, 140), width=2)
    return img


def run_dock(hotkey: str) -> None:
    global _tray_icon
    pystray = _require("pystray")
    _require("PIL", "pillow")

    def _on_quit(icon, item):
        icon.stop()
        import keyboard as kb
        kb.unhook_all()

    icon_image = _make_icon_image()
    menu = pystray.Menu(
        pystray.MenuItem(f"Toggle ({hotkey})", lambda icon, item: toggle()),
        pystray.Menu.SEPARATOR,
        pystray.MenuItem(f"Device 1: {_dev1[0]}", None, enabled=False),
        pystray.MenuItem(f"Device 2: {_dev2[0]}", None, enabled=False),
        pystray.Menu.SEPARATOR,
        pystray.MenuItem("Quit", _on_quit),
    )
    _tray_icon = pystray.Icon(
        name="AudioToggle",
        icon=icon_image,
        title=f"Audio Toggle  |  {hotkey}",
        menu=menu,
    )
    _tray_icon.run()  # blocks until Quit


# ── CLI modes ─────────────────────────────────────────────────────────────────

def cmd_list():
    devices = list_devices()
    print(f"Active audio output devices ({len(devices)} found):\n")
    for i, (name, dev_id) in enumerate(devices, 1):
        print(f"  {i:2}.  {name}")
        print(f"       {dev_id}\n")


def cmd_set(fragment: str):
    devices = list_devices()
    match = find_device(fragment, devices)
    if not match:
        print(f"Error: no device found matching '{fragment}'.\n")
        print("Active devices:")
        for name, _ in devices:
            print(f"  • {name}")
        sys.exit(1)
    name, dev_id = match
    print(f"Setting default output → {name}")
    set_default_device(dev_id)
    print("Done.")


def cmd_hotkey(hotkey: str):
    """CLI hotkey mode — runs in the terminal, Ctrl+C to quit."""
    import keyboard as kb
    print(f"Device 1 : {_dev1[0]}")
    print(f"Device 2 : {_dev2[0]}")
    print(f"Hotkey   : {hotkey}")
    print("Listening for hotkey. Press Ctrl+C to quit.\n")
    kb.add_hotkey(hotkey, toggle)
    try:
        kb.wait()
    except KeyboardInterrupt:
        print("\nExiting.")
    finally:
        kb.unhook_all()


def cmd_dock(hotkey: str):
    """Dock / tray mode — no console output, icon in system tray."""
    import keyboard as kb
    kb.add_hotkey(hotkey, toggle)
    run_dock(hotkey)


# ── Entry point ───────────────────────────────────────────────────────────────

def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(
        prog="toggle_audio_output",
        description="Toggle Windows audio output devices via a global hotkey.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
examples:
  python toggle_audio_output.py                        # hotkey mode (default)
  python toggle_audio_output.py --dock                 # system tray mode
  python toggle_audio_output.py --list                 # list all output devices
  python toggle_audio_output.py --set "Scarlett"       # immediately switch device
  python toggle_audio_output.py --device1 "Focusrite" --device2 "Realtek" --dock
        """,
    )
    p.add_argument("--dock",    action="store_true",
                   help="run as system tray icon (no console window)")
    p.add_argument("--list",    action="store_true",
                   help="print all active output devices and exit")
    p.add_argument("--set",     metavar="NAME",
                   help="immediately switch to a device (substring match) and exit")
    p.add_argument("--device1", metavar="NAME", default=DEVICE_1,
                   help=f"first device substring (default: {DEVICE_1!r})")
    p.add_argument("--device2", metavar="NAME", default=DEVICE_2,
                   help=f"second device substring (default: {DEVICE_2!r})")
    p.add_argument("--hotkey",  metavar="KEYS", default=HOTKEY,
                   help=f"global hotkey combo (default: {HOTKEY!r})")
    return p


def main():
    global _dev1, _dev2

    args = build_parser().parse_args()

    # ── Standalone commands (no device pair needed) ───────────────────────────
    if args.list:
        cmd_list()
        return

    if args.set:
        cmd_set(args.set)
        return

    # ── Hotkey / dock modes — need both devices resolved ─────────────────────
    devices = list_devices()
    _dev1, _dev2 = resolve_devices(args.device1, args.device2, devices)

    if not ctypes.windll.shell32.IsUserAnAdmin():
        print("Warning: not running as Administrator — hotkey may not fire in "
              "all applications.\n")

    if args.dock:
        cmd_dock(args.hotkey)
    else:
        print("Audio Interface Toggle")
        print("=" * 50)
        cmd_hotkey(args.hotkey)


if __name__ == "__main__":
    main()
