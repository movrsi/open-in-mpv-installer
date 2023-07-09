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

; Applications names.
!define MPV_NAME "mpv"
!define FFMPEG_NAME "FFMPEG"
!define OPEN_IN_MPV_NAME "open-in-mpv"

; Browser bits.
!define BROWSER_CHROME 0
!define BROWSER_FIREFOX 1

; Executable file names.
!define FFMPEG_EXECUTABLE "ffmpeg.exe"
!define YOUTUBEDL_EXECUTABLE "youtube-dl.exe"
!define MPV_EXECTUABLE "mpv.exe"
!define FF_JSON_FILE "sh.tat.firefox.open-in-mpv.json.in"
!define CHROME_JSON_FILE "sh.tat.open-in-mpv.json.in"
!define REQUIREMENTS "requirements.txt"

; Installer options.
!define INSTALLER_AUTHOR "Copyright 2023 Tatsh - tat.sh"
!define INSTALLER_NAME "open-in-mpv setup"
!define INSTALLER_PRODUCT_NAME "open-in-mpv"
!define INSTALLER_VERSION "0.0.1"

; open-in-mpv specific.
!define MPV_LOCATION "$PROGRAMFILES64"
!define OPEN_IN_MPV_FF_JSON "$TEMP\open-in-mpv\sh.tat.firefox.open-in-mpv.json.in"
!define OPEN_IN_MPV_CHROME_JSON "$TEMP\open-in-mpv\sh.tat.open-in-mpv.json.in"
!define MPV_TEMP_LOCATION "$TEMP\open-in-mpv"

; Registry.
!define PYTHON_REGISTRY_64 "SOFTWARE\Python\PythonCore\versionnumber\InstallPath"
!define PYTHON_REGISTRY_32 "SOFTWARE\Wow6432Node\Python\PythonCore\versionnumber\InstallPath"
!define REGISTRY_KEY_CHROME "Software\Google\Chrome\NativeMessagingHosts\sh.tat.open-in-mpv"
!define REGISTRY_KEY_FIREFOX "SOFTWARE\Mozilla\NativeMessagingHosts\sh.tat.open-in-mpv"
!define REGISTRY_VALUE "$INSTDIR\sh.tat.open-in-mpv.json"