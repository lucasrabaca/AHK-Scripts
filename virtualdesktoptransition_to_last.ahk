; Performs the transition between two Windows Virtual Desktop with only one command.


; List of keys: https://www.autohotkey.com/docs/KeyList.htm#general

switchFlag 	:= false ; Used to perform the change between desktops
verifyCurrentDesktopFlag() ; retrieve the current desktop in case it started in secondary screen


; TO BIND ANOTHER KEY:   single: key::function() ; multiple: key1 & key2::function() ; Default is Left Windows and Tab.
LWin & Tab::switch()


; doesn't need to change bellow
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
switch()
{
	global switchFlag
	; return command
	if switchFlag
	{
		SendEvent ^#{Left}
		switchFlag := false
	}
	else
	{
		SendEvent ^#{Right}
		switchFlag := true
	}
}


; Inspired by Odlanir @https://www.autohotkey.com/boards/viewtopic.php?t=68164
verifyCurrentDesktopFlag(){
	global switchFlag
	IdLength := 32
	; find the process
	ProcessId := DllCall("GetCurrentProcessId", "UInt")
	if ErrorLevel {
		MsgBox, % "Error getting current process id: " ErrorLevel
		return
	}
	DllCall("ProcessIdToSessionId", "UInt", ProcessId, "UInt*", SessionId)
	if ErrorLevel {
		MsgBox, % "Error getting session id: " ErrorLevel
		return
	}
	;retrieve desktop list
	RegRead, DesktopList, HKEY_CURRENT_USER, SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, VirtualDesktopIDs
	if (DesktopList) {
		DesktopListLength := StrLen(DesktopList)
		DesktopCount := DesktopListLength / IdLength
	} else {
		DesktopCount := 1
	}
	; retrieve current desktop number and set the flag correctly
	if (SessionId) {
		RegRead, CurrentDesktopId, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\%SessionId%\VirtualDesktops, CurrentVirtualDesktop
		if (CurrentDesktopId) {
			IdLength := StrLen(CurrentDesktopId)
		}
	}
	while (CurrentDesktopId and i < DesktopCount) {
		StartPos := (i * IdLength) + 1
		DesktopIter := SubStr(DesktopList, StartPos, IdLength)
		if (DesktopIter = CurrentDesktopId) {
			CurrentDesktop := i + 1
			if (CurrentDesktop > 1) {
				switchFlag := true
			}
		}
		i++
	}
}
