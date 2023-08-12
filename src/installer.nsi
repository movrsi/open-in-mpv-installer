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
VIProductVersion ${INSTALLER_VERSION}
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "${INSTALLER_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${INSTALLER_VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "${INSTALLER_AUTHOR}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "${INSTALLER_PRODUCT_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductVersion" "${INSTALLER_VERSION}"

; components
Insttype "${BROWSER_SELECTION_TEXT}"
Insttype "${BROWSER_SELECTION_FIREFOX}"
Insttype "${BROWSER_SELECTION_CHOME}"

; pages
page components
page instfiles

Section "open-in-mpv-installer"
SectionIn RO
    ; Write the mpv installer batch file to %TEMP%.
    SetOutPath "${MPV_TEMP_LOCATION}"
    File "${MPV_INSTALLER}"

    ; TODO refactor for a more traditional installer.
    ; Discussed with @Tatsh.
    SetOutPath "${MPV_LOCATION}"
    File "${YOUTUBEDL_EXECUTABLE}"
    File "${FFMPEG_EXECUTABLE}"
    File "${MPV_EXECTUABLE}"
    File "${MPV_UNINSTALLER}"
    ; Going to do a home-made updater for this
    ; commented out until published.
   # File "${MPV_UPDATER}"
    File "${OPEN_IN_MPV_SCRIPT}"

    ; Create shortcuts for mpv.
    !insertmacro CreateShortcuts
    ; Exeucte mpv install.bat.
    !insertmacro ExecuteMpvInstaller
    ; Schedule the updater.ps1 from MPV.
    !insertmacro ExecuteSchtasksUpdater
    ; Write the uninstaller.
    WriteUninstaller $INSTDIR\uninstaller.exe
    ; Clean up %TEMP% directory.
    !insertmacro CleanupInstaller
SectionEnd

Section "Firefox" SEC_FIREFOX
SectionIn 1
    ; Create the required JSON file for Mozilla Firefox.
    !insertmacro WriteManifestJSON ${BROWSER_FIREFOX}
    ; Create the required registry entries for Mozilla Firefox.
    !insertmacro InsertRegkey ${BROWSER_FIREFOX}
SectionEnd

Section /o "Chromium" SEC_CHROMIUM
SectionIn 2
    ; Create the required JSON file for Chromium
    !insertmacro WriteManifestJSON ${BROWSER_CHROME}
    ; Create the required registry entries for Chromium.
    !insertmacro InsertRegkey ${BROWSER_CHROME}
SectionEnd

; Uninstaller section
Section "Uninstall"
    ; Execute the mpv uninstaller batch file.
    !insertmacro ExecuteMpvUninstaller
    ; Delete the directory with all files using recursion.
    !insertmacro CleanupUninstaller
    ; Remove the registry keys placed by the installer.
    !insertmacro DeleteRegKeys
    ; Delete the shortcuts created by the installer.
    !insertmacro DeleteShortcuts
    ; Delete the scheduled task for mpv updating.
    !insertmacro ExecuteRemoveSchtasksUpdater
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