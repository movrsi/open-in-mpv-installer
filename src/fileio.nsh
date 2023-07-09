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

Function AdvReplaceInFile
    Exch $0 ;FILE_TO_MODIFIED file to replace in
    Exch
    Exch $1 ;the NR_OCC of OLD_STR occurrences to be replaced.
    Exch
    Exch 2
    Exch $2 ;FST_OCC: the first occurrence to be replaced and onwards
    Exch 2
    Exch 3
    Exch $3 ;REPLACEMENT_STR string to replace with
    Exch 3
    Exch 4
    Exch $4 ;OLD_STR to be replaced
    Exch 4
    Push $5 ;incrementing counter
    Push $6 ;a chunk of read line
    Push $7 ;the read line altered or not
    Push $8 ;left string
    Push $9 ;right string or forster read line
    Push $R0 ;temp file handle
    Push $R1 ;FILE_TO_MODIFIED file handle
    Push $R2 ;a line read
    Push $R3 ;the length of OLD_STR
    Push $R4 ;counts reaching of FST_OCC
    Push $R5 ;counts reaching of NR_OCC
    Push $R6 ;temp file name

    GetTempFileName $R6

    FileOpen $R1 $0 r 			;FILE_TO_MODIFIED file to search in
    FileOpen $R0 $R6 w                    ;temp file
    StrLen $R3 $4			;the length of OLD_STR
    StrCpy $R4 0				;counter initialization
    StrCpy $R5 -1			;counter initialization

loop_read:
    ClearErrors
    FileRead $R1 $R2 			;reading line
    IfErrors exit				;when end of file has been reached

    StrCpy $5 -1  			;cursor, start of read line chunk
    StrLen $7 $R2 			;read line length
    IntOp $5 $5 - $7			;cursor initialization
    StrCpy $7 $R2			;$7 contains read line

loop_filter:
    IntOp $5 $5 + 1 			;cursor shifting
    StrCmp $5 0 file_write		;end of line has been reached
    StrCpy $6 $7 $R3 $5 			;a chunk of read line of length OLD_STR
    StrCmp $6 $4 0 loop_filter		;continues to search OLD_STR if no match

    StrCpy $8 $7 $5 			;left part
    IntOp $6 $5 + $R3
    IntCmp $6 0 yes no			;left part + OLD_STR == full line read ?
yes:
    StrCpy $9 ""
    Goto done
no:
    StrCpy $9 $7 "" $6 			;right part
done:
    StrCpy $9 $8$3$9 			;replacing OLD_STR by REPLACEMENT_STR in forster read line

    IntOp $R4 $R4 + 1			;counter incrementation
    ;MessageBox MB_OK|MB_ICONINFORMATION \
    ;"count R4 = $R4, fst_occ = $2"
    StrCmp $2 all follow_up			;exchange ok, then goes to search the next OLD_STR
    IntCmp $R4 $2 follow_up			;no exchange until FST_OCC has been reached,
    Goto loop_filter			;and then searching for the next OLD_STR

follow_up:
    IntOp $R4 $R4 - 1			;now counter is to be stuck to FST_OCC

    IntOp $R5 $R5 + 1			;counter incrementation
    ;MessageBox MB_OK|MB_ICONINFORMATION \
    ;"count R5 = $R5, nbr_occ = $1"
    StrCmp $1 all exchange_ok 		;goes to exchange OLD_STR with REPLACEMENT_STR
    IntCmp $R5 $1 finalize			;proceeding exchange until NR_OCC has been reached

exchange_ok:
    IntOp $5 $5 + $R3 			;updating cursor
    StrCpy $7 $9				;updating read line with forster read line
    Goto loop_filter			;goes searching the same read line

finalize:
    IntOp $R5 $R5 - 1			;now counter is to be stuck to NR_OCC

file_write:
    FileWrite $R0 $7 			;writes altered or unaltered line
    Goto loop_read				;reads the next line

exit:
    FileClose $R0
    FileClose $R1

   ;SetDetailsPrint none
    Delete $0
    Rename $R6 $0				;superseding FILE_TO_MODIFIED file with
					;temp file built with REPLACEMENT_STR
  ;Delete $R6
  ;SetDetailsPrint lastused

    Pop $R6
    Pop $R5
    Pop $R4
    Pop $R3
    Pop $R2
    Pop $R1
    Pop $R0
    Pop $9
    Pop $8
    Pop $7
    Pop $6
    Pop $5
    ;These values are stored in the stack in the reverse order they were pushed
    Pop $0
    Pop $1
    Pop $2
    Pop $3
    Pop $4
FunctionEnd

; Replace the @BIN_PATH@ marker within the given json files,
; to the path of the open-in-mpv Python script.
; This macro will then rename the json files to their proper
; names and move them into the $INSTDIR.
;
; Param: EAX - An integer used for determining if the json file is for
;              Firefox or Google Chrome
!macro ReplaceJSON EAX
    Push "@BIN_PATH@" ;text to be replaced
    Push "$INSTDIR\open-in-mpv.py" ;replace with
    Push all ;start replacing at 3rd occurrence
    Push all ;replace all other occurrences
    IntOp $EBX, $EAX & 1

    ${If} $EBX == 1
        Push $OPEN_IN_MPV_FF_JSON  ;file to replace in
        Call AdvReplaceInFile
        Rename "$MPV_TEMP_LOCATION\$OPEN_IN_MPV_FIREFOX_JSON" "$INSTDIR\sh.tat.open-in-mpv.json"
    ${Else}
        Push $OPEN_IN_MPV_CHROME_JSON ;file to replace in
        Call AdvReplaceInFile
        Rename "$MPV_TEMP_LOCATION\OPEN_IN_MPV_CHROME_JSON" "$INSTDIR\sh.tat.open-in-mpv.json"
    ${EndIf}
!macroend
