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
!include "fileio.nsh"
!include "reg.nsh"
!include "Sections.nsh"

Name "open-in-mpv"
OutFile "open-in-mpv-setup.exe"
RequestExecutionLevel admin
InstallDir "$MPV_LOCATION\open-in-mpv"

; Installer file information
VIProductVersion "${INSTALLER_VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "${INSTALLER_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${INSTALLER_VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "${INSTALLER_AUTHOR}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "${INSTALLER_PRODUCT_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductVersion" "${INSTALLER_VERSION}"

; components
Insttype "/CUSTOMSTRING=Select the browser that open-in-mpv will be used in"
Insttype "Mozilla Firefox"
Insttype "Chromium Based"

; pages
page components
page instfiles

Section "open-in-mpv-installer"
SectionIn RO
    ; TODO refactor for a more traditional installer.
    ; Discussed with @Tatsh.
    SetOutPath "$MPV_TEMP_LOCATION"
    File "$REQUIREMENTS"

    SetOutPath "$MPV_LOCATION\open-in-mpv"
    File "yt-dlp.exe"
    File "ffmpeg.exe"
    File "mpv.exe"
    File "open-in-mpv.py"

    ; Create shortcuts for mpv.
    !insertmacro CreateShortcuts
    ; Write the uninstaller.
    WriteUninstaller $INSTDIR\uninstaller.exe
SectionEnd

Section "Firefox" SEC_FIREFOX
SectionIn 1
    ; Create the required JSON file for Mozilla Firefox.
    !insertmacro WriteFirefoxJSON
    ; Create the required registry entries for Mozilla Firefox.
    !insertmacro InsertRegkey BROWSER_FIREFOX
SectionEnd

Section /o "Chromium" SEC_CHROMIUM
SectionIn 2
    ; Create the required JSON file for Chromium
    !insertmacro WriteChromeJSON
    ; Create the required registry entries for Chromium.
    !insertmacro InsertRegkey BROWSER_CHROME
SectionEnd

; Uninstaller section
Section "Uninstall"
    ; Delete the directory with all files using recursion.
    !insertmacro CleanupUninstaller
    ; Remove the registry keys placed by the installer.
    !insertmacro DeleteRegKeys
    ; Delete the shortcuts created by the installer.
    !insertmacro DeleteShortcuts
SectionEnd

Function .onInit
    StrCpy $1 ${SEC_CHROMIUM}
FunctionEnd

Function .onSelChange
    !insertmacro StartRadioButtons $1
    !insertmacro RadioButton ${SEC_CHROMIUM}
    !insertmacro RadioButton ${SEC_FIREFOX}
    !insertmacro EndRadioButtons
FunctionEnd