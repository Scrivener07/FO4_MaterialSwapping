Scriptname MisriahArmory:Log Const Native Hidden DebugOnly
{Outputs text messages to the specified user log on disk.}

; The log files are stored "<documents>/My Games/Fallout4/Logs/Script/User/MisriahArmory.0.log".
; Newer logs cycle the older logs where `MisriahArmory.0.log` becomes `MisriahArmory.1.log`, 1 becomes 2, and so on.


; Logging
;---------------------------------------------

bool Function WriteLine(string prefix, string text) Global DebugOnly
	string filename = "MisriahArmory" const
	text = prefix + " " + text
	If(Debug.TraceUser(filename, text))
		return true
	Else
		Debug.OpenUserLog(filename)
		return Debug.TraceUser(filename, text)
	EndIf
EndFunction


bool Function TracePropertyModifiers(ObjectMod aObjectMod) Global DebugOnly
	If (aObjectMod)
		ObjectMod:PropertyModifier[] array = aObjectMod.GetPropertyModifiers()
		If (array)
			int index = 0
			While (index < array.Length)
				WriteLine(aObjectMod, "Property Modifier: "+array[index]+", @"+index)
				index += 1
			EndWhile
			return true
		Else
			WriteLine(aObjectMod, "No property modifiers.")
			return false
		EndIf
	Else
		WriteLine(none, "Cannot trace property modifiers on none ObjectMod.")
		return false
	EndIf
EndFunction
