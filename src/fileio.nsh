; This file is part of open-in-mpv.
;
; Copyright 2020 Andrew Udvare
; Copyright 2023 movrsi
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in
; all copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.

!include "defines.nsh"

; Cleanup routine for the installer.
!macro CleanupInstaller
    SetOutPath "$TEMP"
    RMDir /r "$TEMP\open-in-mpv"
!macroend

; Cleanup routine for the uninstaller.
!macro CleanupUninstaller
    SetOutPath "$INSTDIR\open-in-mpv"
    RMDir /r "$INSTDIR\open-in-mpv"
!macroend

; Create the following shortcuts for mpv.
;
; - A shortcut to mpv on the users desktop.
; - A shortcut to mpv in the users start menu.
!macro CreateShortcuts
    CreateShortCut "$DESKTOP\mpv Media Player.lnk" "$INSTDIR\mpv.exe"
    CreateShortCut "$SMPROGRAMS\mpv Media Player.lnk" "$INSTDIR\mpv.exe"
!macroend

; Delete the created shortcuts that open-in-mpv created during install.
;
; The following shortcuts are deleted:
; - Desktop
; - Startmenu
!macro DeleteShortcuts
    Delete "$DESKTOP\mpv Media Player.lnk"
    Delete "$SMPROGRAMS\mpv Media Player.lnk"
!macroend

; Write the Mozilla Firefox JSON.
!macro WriteFirefoxJSON
    FileOpen $0 "$INSTDIR\sh.tat.open-in-mpv.json" w ;open a file with write mode.
    FileWrite $0 "{\n"
    FileWrite $0 "    $\"allowed_extensions$\": [$\"{43e6f3ef-84a0-55f4-b9dd-d879106a24a9}$\"],\n"
    FileWrite $0 "    $\"description$\": $\"Open a video using mpv$\",\n"
    FileWrite $0 "    $\"name$\": $\"sh.tat.open-in-mpv$\",\n"
    FileWrite $0 "    $\"path$\": $\"$INSTDIR\open-in-mpv.py$\",\n"
    FileWrite $0 "    $\"type$\": $\"stdio$\"\n"
    FileWrite $0 "}\n"
    FileClose $0 ;close the file handle.
!macroend

; Write the Chrome JSON.
!macro WriteChromeJSON
    FileOpen $0 "$INSTDIR\sh.tat.open-in-mpv.json" w ;open a file with write mode.
    FileWrite $0 "{\n"
    FileWrite $0 "  $\"allowed_origins$\": [$\"chrome-extension://ggijpepdpiehgbiknmfpfbhcalffjlbj/$\"],\n"
    FileWrite $0 "    $\"description$\": $\"Open a video using mpv$\",\n"
    FileWrite $0 "    $\"name$\": $\"sh.tat.open-in-mpv$\",\n"
    FileWrite $0 "    $\"path$\": $\"$INSTDIR\open-in-mpv.py$\",\n"
    FileWrite $0 "    $\"type$\": $\"stdio$\"\n"
    FileWrite $0 "}\n"
    FileClose $0 ;close the file handle.
!macroend