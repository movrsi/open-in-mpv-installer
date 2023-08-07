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

; Insert the registry key for the selected browser.
!macro InsertRegkey EAX
    SetRegView 64
    ClearErrors
    IntOp $EBX, $EAX & 1

    ${If} $EBX == 1
        WriteRegStr HKLM "${REGISTRY_KEY_FIREFOX}" "${MANIFEST_JSON}"
    ${Else}
        WriteRegStr HKLM "${REGISTRY_KEY_CHROME}" "${MANIFEST_JSON}"
    ${EndIf}
!macroend

!macro DeleteRegKeyIfExists EAX
    SetRegView 64
    ClearErrors
    ReadRegStr $R0 HKLM $EAX
    StrLen $0 $R0

    ${If} $0 != 0
        DeleteRegKey HKLM $EAX
    ${EndIf}
!macroend

!macro ExectutePythonIfExists EAX EBX
    SetRegView 64
    ClearErrors
    ReadRegStr $R0 $EAX $EBX
    StrLen $0 $R0

    ${If} $0 != 0
        ExecWait '"$R0\python.exe" -m pip install -r pywin32'
        !insertmacro _FinishMessage "Successfully obtained win32 Python dependency!"
    ${EndIf}
!macroend

!macro DeleteRegKeys EAX
    IntOp $EBX, $EAX & 1

    ${If} $EBX == 1
        DeleteRegKeyIfExists "${REGISTRY_KEY_FIREFOX}"
    ${Else}
        DeleteRegKeyIfExists "${REGISTRY_KEY_CHROME}"
    ${EndIf}
!macroend

!macro PythonDependencies
    ExectutePythonIfExists HKLM "${PYTHON_REGISTRY_64}"
    ExectutePythonIfExists HKCU "${PYTHON_REGISTRY_64}"
    ExectutePythonIfExists HKLM "${PYTHON_REGISTRY_32}"
!macroend