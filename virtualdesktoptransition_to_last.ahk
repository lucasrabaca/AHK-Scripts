; Source: https://stackoverflow.com/a/56952385/13442827
; Performs the transition between two Windows Virtual Desktop with only one command.

; TO BIND ANOTHER KEY:   single: key::function() ; multiple: key1 & key2::function() ; Default is Left Windows and Tab.
XButton2::Send, {LWin down}{LCtrl down}{Left}{LWin up}{LCtrl up}

XButton1::
if (Toggle := !Toggle)
    Send #^{right}
else
    Send #^{left}
return
