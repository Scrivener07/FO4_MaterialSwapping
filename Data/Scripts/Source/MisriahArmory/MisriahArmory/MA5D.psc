Scriptname MisriahArmory:MA5D extends ObjectReference
{Attaches to: MA5D "MA5D ICWS" [WEAP:0202D4E5]}

Actor Owner
int Count = 0
int Capacity = 0

; Materials
MatSwap MA5D_AmmoCounter_Blue_00 ; {MA5D_AmmoCounter_Blue_00 [MSWP:0002D46B]}
MatSwap:RemapData[] Remapping
MatSwap:RemapData DigitFirst
MatSwap:RemapData DigitLast

; Biped Slots
int BipedWeapon = 41 Const

; Animation Events
string WeaponFire = "weaponFire" const
string ReloadComplete = "reloadComplete" const


; Events
;---------------------------------------------

Event OnInit()
	MA5D_AmmoCounter_Blue_00 = Game.GetFormFromFile(0x0002D46B, "MisriahArmory.esp") as MatSwap
	WriteLine(self, "Got material: "+MA5D_AmmoCounter_Blue_00)
EndEvent


Event OnEquipped(Actor akActor)
	Owner = akActor
	Capacity = GetAmmoCapacity()
	Count = GetAmmoAmount()
	Remapping = new MatSwap:RemapData[0]

	DigitFirst = new MatSwap:RemapData
	DigitFirst.Source = GetFirstDigit(Count)
	DigitFirst.Target = GetFirstDigit(Count)
	Remapping.Add(DigitFirst)

	DigitLast = new MatSwap:RemapData
	DigitLast.Source = GetLastDigit(Count)
	DigitLast.Target = GetLastDigit(Count)
	Remapping.Add(DigitLast)

	ApplySwap()

	RegisterForAnimationEvent(Owner, WeaponFire)
	RegisterForAnimationEvent(Owner, ReloadComplete)

	WriteLine(self, Owner+" equipped: "+ToString())
EndEvent


Event OnUnequipped(Actor akActor)
	UnregisterForAllEvents()
	DigitFirst = none
	DigitLast = none
	Remapping = none
	Owner = none
	WriteLine(self, Owner+" unequipped: "+ToString())
EndEvent


Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	If (asEventName == WeaponFire)
		Count -= 1
		DigitFirst.Target = GetFirstDigit(Count)
		DigitLast.Target = GetLastDigit(Count)
		ApplySwap()
		WriteLine(self, asEventName+" event. "+ToString())

	ElseIf (asEventName == ReloadComplete)
		Count = GetAmmoAmount()
		DigitFirst.Target = GetFirstDigit(Count)
		DigitLast.Target = GetLastDigit(Count)
		ApplySwap()
		WriteLine(self, asEventName+" event. "+ToString())
	Else
		WriteLine(self, "The animation event "+asEventName+" was unhandled.")
	EndIf
EndEvent


; Functions
;---------------------------------------------

int Function GetAmmoCapacity()
	ObjectMod[] array = Owner.GetWornItemMods(BipedWeapon)
	If (array)
		int index = 0
		While (index < array.Length)
			ObjectMod omod = array[index]
			ObjectMod:PropertyModifier[] properties = omod.GetPropertyModifiers()
			int found = properties.FindStruct("target", omod.Weapon_Target_iAmmoCapacity)
			If (found > -1)
				return properties[found].value1 as int
			EndIf
			index += 1
		EndWhile
		return 0
	EndIf
EndFunction


int Function GetAmmoAmount()
	Ammo ammoType = ((self as Form) as Weapon).GetAmmo()
	int ammoAmount = Owner.GetItemCount(ammoType)
	If (ammoAmount < Capacity)
		return ammoAmount
	Else
		return Capacity
	EndIf
EndFunction


string Function GetFirstDigit(int number) Global
	If (number)
		int digit = number / 10
		return "MisriahArmory\\MA5D\\AmmoCounter\\Blue\\#_\\" + digit + ".bgsm"
	Else
		return "MisriahArmory\\MA5D\\AmmoCounter\\Blue\\#_\\0.bgsm"
	EndIf
EndFunction


string Function GetLastDigit(int number) Global
	If (number)
		int digit = number % 10
		return "MisriahArmory\\MA5D\\AmmoCounter\\Blue\\_#\\" + digit + ".bgsm"
	Else
		return "MisriahArmory\\MA5D\\AmmoCounter\\Blue\\_#\\0.bgsm"
	EndIf
EndFunction


Function ApplySwap()
	MA5D_AmmoCounter_Blue_00.SetRemapData(Remapping)
	Owner.ApplyMaterialSwap(MA5D_AmmoCounter_Blue_00)
EndFunction


string Function ToString()
	return "("+Count+"/"+Capacity+") First:"+DigitFirst.Target+", Last:"+DigitLast.Target
EndFunction


; Logging
;---------------------------------------------

Function Trace(string prefix, string text) Global DebugOnly
	text = prefix + " " + text
 	Debug.Trace(text)
EndFunction


bool Function WriteLine(string prefix, string text) Global DebugOnly
	string filename = "MA5D" const
	text = prefix + " " + text
	If(Debug.TraceUser(filename, text))
		return true
	Else
		Debug.OpenUserLog(filename)
		return Debug.TraceUser(filename, text)
	EndIf
EndFunction


bool Function WriteNotification(string prefix, string text) Global DebugOnly
	Debug.Notification(text)
	return WriteLine(prefix, text)
EndFunction


bool Function WriteMessage(string prefix, string text) Global DebugOnly
	string title
	If (prefix)
		title = prefix+"\n"
	EndIf
	Debug.MessageBox(title+text)
	return WriteLine(prefix, text)
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
