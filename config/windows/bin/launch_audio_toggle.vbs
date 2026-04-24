' Launches toggle_audio_output.py silently via pythonw (no console window).
' Place this file in:
'   %APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\

Dim shell
Set shell = CreateObject("WScript.Shell")

' ── Edit this path if your script lives elsewhere ────────────────────────────
Dim scriptPath
scriptPath = "%USERPROFILE%\.local\nyx\config\windows\bin\toggle_audio_output.py"
' ─────────────────────────────────────────────────────────────────────────────

' pythonw.exe = Python with no console window
shell.Run "pythonw.exe """ & scriptPath & """ --dock", 0, False
