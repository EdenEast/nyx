# Wrath

## Overview

NixOS WSL2 systme for Custom ATX desktop.

---

## Specs


| Component   | Details                        |
| ----------- | ------------------------------ |
| **Model**   | Custom ATX Desktop |
| **CPU**     | AMD Ryzen 9 7900 |
| **GPU**     | Nvidia RTX 3080 Ti |
| **RAM**     | 64GB DDR5-5600 (2x32)           |
| **Storage** | 1TB NVMe SSD                   |

---

## Setup

To use Yubikey through wsl2 [usbipd-win](https://github.com/dorssel/usbipd-win) is required to be installed. This will
enable windows to share USB devices with wsl2

```powershell
winget install usbipd-win
```

Double check that the device has the correct bus id

```powershell
usbipd list
BUSID  VID:PID    DEVICE                                                        STATE
1-8    1050:0407  USB Input Device, Microsoft Usbccid Smartcard Reader (WUDF)   Not shared
...
```

### Resources:
- [yubikey-passthrough-on-wsl2](https://lgug2z.com/articles/yubikey-passthrough-on-wsl2-with-full-fido2-support/)
