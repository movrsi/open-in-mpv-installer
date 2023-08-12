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

!include LogicLib.nsh
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
    CreateShortCut "${SHORTCUT_MPV_DESKTOP}" "${SHORTCUT_MPV_PATH}"
    CreateShortCut "${SHORTCUT_MPV_START_MENU}" "${SHORTCUT_MPV_PATH}"
!macroend

; Delete the created shortcuts that open-in-mpv created during install.
;
; The following shortcuts are deleted:
; - Desktop
; - Startmenu
!macro DeleteShortcuts
    Delete "${SHORTCUT_MPV_DESKTOP}"
    Delete "${SHORTCUT_MPV_START_MENU}"
!macroend

; Write the Mozilla Firefox or Google Chrome manifest JSON.
;
; Param: EAX 0 if chrome, 1 if firefox.
!macro WriteManifestJSON EAX
    IntOp $EBX, $EAX & 1

    FileOpen $0 "${MANIFEST_JSON}" w ;open a file with write mode.
    FileWrite $0 "${MANIFEST_JSON_START}"

    ${If $EBX == 1}
        FileWrite $0 "${MANIFEST_FIREFOX_EXTENSION}"
    ${Else}
        FileWrite $0 "${MANIFEST_CHROME_EXTENSION}"
    ${EndIf}

    FileWrite $0 "${MANIFEST_DESCRIPTION}"
    FileWrite $0 "${MANIFEST_NAME}"
    FileWrite $0 "${MANIFEST_PATH}"
    FileWrite $0 "${MANIFEST_TYPE}"
    FileWrite $0 "${MANIFEST_JSON_END}"
    FileClose $0 ;close the file handle.
!macroend

!macro ExecuteMpvInstaller
    ExecWait '"$SYSDIR\cmd.exe" /C if 1==1 "$MPV_TEMP_LOCATION\mpv-install.bat"'
!macroend

!macro ExecuteMpvUninstaller
    ExecWait '"$SYSDIR\cmd.exe" /C if 1==1 "$MPV_LOCATION\mpv-uninstall.bat"'
!macroend

; Create the task for updating mpv weekly on every Wednesday.
;
; See: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/schtasks-create#examples-5 
!macro ExecuteSchtasksUpdater
    ExecWait 'schtasks /create /tn MpvUpdater /tr "$MPV_LOCATION\updater.ps1" /sc weekly /d WED'
!macroend

; Delete the task for updating mpv weekly.
!macro ExecuteRemoveSchtasksUpdater
    ExecWait 'schtasks /delete /tn MpvUpdater'
!macroend