Scriptname Commonwealth_Spartan:Light_Rifle extends ObjectReference
{Attaches to CommonwealthSpartan_Weapon_LightRifle "Z-250 Directed Light Rifle" [WEAP:02022DA2]}

; Data File
; CommonwealthSpartan_Weapon_LightRifle "Z-250 Directed Light Rifle" [WEAP:02022DA2]
; mat_CommonwealthSpartan_Left_Forerunner_Digit_0 [MSWP:0202D042]
; mat_CommonwealthSpartan_Right_Forerunner_Digit_0 [MSWP:0202D04C]

; Filepaths
; Data\\Materials\\Commonwealth_Spartan\\Ammo_Counter\\Left_Forerunner_Digit_0.bgsm
; Data\\Materials\\Commonwealth_Spartan\\Ammo_Counter\\Left_Forerunner_Digit_1.bgsm
; Data\\Materials\\Commonwealth_Spartan\\Ammo_Counter\\Left_Forerunner_Digit_2.bgsm
; Data\\Materials\\Commonwealth_Spartan\\Ammo_Counter\\Left_Forerunner_Digit_3.bgsm
; Data\\Materials\\Commonwealth_Spartan\\Ammo_Counter\\Left_Forerunner_Digit_4.bgsm
; Data\\Materials\\Commonwealth_Spartan\\Ammo_Counter\\Left_Forerunner_Digit_5.bgsm
; Data\\Materials\\Commonwealth_Spartan\\Ammo_Counter\\Left_Forerunner_Digit_6.bgsm
; Data\\Materials\\Commonwealth_Spartan\\Ammo_Counter\\Left_Forerunner_Digit_7.bgsm
; Data\\Materials\\Commonwealth_Spartan\\Ammo_Counter\\Left_Forerunner_Digit_8.bgsm
; Data\\Materials\\Commonwealth_Spartan\\Ammo_Counter\\Left_Forerunner_Digit_9.bgsm
;
; Data\\Materials\\Commonwealth_Spartan\\Ammo_Counter\\Right_Forerunner_Digit_0.bgsm
; Data\\Materials\\Commonwealth_Spartan\\Ammo_Counter\\Right_Forerunner_Digit_1.bgsm
; Data\\Materials\\Commonwealth_Spartan\\Ammo_Counter\\Right_Forerunner_Digit_2.bgsm
; Data\\Materials\\Commonwealth_Spartan\\Ammo_Counter\\Right_Forerunner_Digit_3.bgsm
; Data\\Materials\\Commonwealth_Spartan\\Ammo_Counter\\Right_Forerunner_Digit_4.bgsm
; Data\\Materials\\Commonwealth_Spartan\\Ammo_Counter\\Right_Forerunner_Digit_5.bgsm
; Data\\Materials\\Commonwealth_Spartan\\Ammo_Counter\\Right_Forerunner_Digit_6.bgsm
; Data\\Materials\\Commonwealth_Spartan\\Ammo_Counter\\Right_Forerunner_Digit_7.bgsm
; Data\\Materials\\Commonwealth_Spartan\\Ammo_Counter\\Right_Forerunner_Digit_8.bgsm
; Data\\Materials\\Commonwealth_Spartan\\Ammo_Counter\\Right_Forerunner_Digit_9.bgsm

Group TestOnly
	Weapon Property CommonwealthSpartan_Weapon_LightRifle Auto Const Mandatory
EndGroup

Actor Owner
int Count = 0
int Capacity = 0

; Materials
MatSwap mat_CommonwealthSpartan_Left_Forerunner_Digit_0
MatSwap:RemapData[] FirstDigitRemapping
MatSwap:RemapData DigitFirst

MatSwap mat_CommonwealthSpartan_Right_Forerunner_Digit_0
MatSwap:RemapData[] LastDigitRemapping
MatSwap:RemapData DigitLast


; Biped Slots
int BipedWeapon = 41 Const

; Animation Events
string WeaponFire = "weaponFire" const
string ReloadComplete = "reloadComplete" const


; Events
;---------------------------------------------

Event OnInit()
	mat_CommonwealthSpartan_Left_Forerunner_Digit_0 = Game.GetFormFromFile(0x0002D042, "Commonwealth_Spartan_Redux.esp") as MatSwap
	WriteLine(self, "Got first digit material: "+mat_CommonwealthSpartan_Left_Forerunner_Digit_0)

	mat_CommonwealthSpartan_Right_Forerunner_Digit_0 = Game.GetFormFromFile(0x0002D04C, "Commonwealth_Spartan_Redux.esp") as MatSwap
	WriteLine(self, "Got last digit material: "+mat_CommonwealthSpartan_Right_Forerunner_Digit_0)
EndEvent


Event OnEquipped(Actor akActor)
	Owner = akActor
	Capacity = GetAmmoCapacity()
	Count = GetAmmoAmount()

	FirstDigitRemapping = new MatSwap:RemapData[0]
	DigitFirst = new MatSwap:RemapData
	DigitFirst.Source = GetFirstDigit(Count)
	DigitFirst.Target = GetFirstDigit(Count)
	FirstDigitRemapping.Add(DigitFirst)

	LastDigitRemapping = new MatSwap:RemapData[0]
	DigitLast = new MatSwap:RemapData
	DigitLast.Source = GetLastDigit(Count)
	DigitLast.Target = GetLastDigit(Count)
	LastDigitRemapping.Add(DigitLast)

	ApplySwap()

	RegisterForAnimationEvent(Owner, WeaponFire)
	RegisterForAnimationEvent(Owner, ReloadComplete)

	WriteLine(self, Owner+" equipped: "+ToString())
EndEvent


Event OnUnequipped(Actor akActor)
	UnregisterForAllEvents()
	DigitFirst = none
	DigitLast = none
	FirstDigitRemapping = none
	LastDigitRemapping = none
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
	Ammo ammoType = CommonwealthSpartan_Weapon_LightRifle.GetAmmo()
	If (ammoType)
		int ammoAmount = Owner.GetItemCount(ammoType)
		If (ammoAmount < Capacity)
			return ammoAmount
		Else
			return Capacity
		EndIf
	Else
		WriteLine(self, "GetAmmoAmount: ammoType is none")
		return 0
	EndIf
EndFunction


string Function GetFirstDigit(int number) Global
	If (number)
		int digit = number / 10
		return "Commonwealth_Spartan\\Ammo_Counter\\Left_Forerunner_Digit_"+digit+".bgsm"
	Else
		return "Commonwealth_Spartan\\Ammo_Counter\\Left_Forerunner_Digit_0.bgsm"
	EndIf
EndFunction


string Function GetLastDigit(int number) Global
	If (number)
		int digit = number % 10
		return "Commonwealth_Spartan\\Ammo_Counter\\Right_Forerunner_Digit_"+digit+".bgsm"
	Else
		return "Commonwealth_Spartan\\Ammo_Counter\\Right_Forerunner_Digit_0.bgsm"
	EndIf
EndFunction


Function ApplySwap()
	Utility.Wait(1.0)
	If (Owner)
		If (mat_CommonwealthSpartan_Left_Forerunner_Digit_0 && FirstDigitRemapping)
			mat_CommonwealthSpartan_Left_Forerunner_Digit_0.SetRemapData(FirstDigitRemapping)
			Owner.ApplyMaterialSwap(mat_CommonwealthSpartan_Left_Forerunner_Digit_0)
		EndIf
		If (mat_CommonwealthSpartan_Right_Forerunner_Digit_0 && LastDigitRemapping)
			mat_CommonwealthSpartan_Right_Forerunner_Digit_0.SetRemapData(LastDigitRemapping)
			Owner.ApplyMaterialSwap(mat_CommonwealthSpartan_Right_Forerunner_Digit_0)
		EndIf
	EndIf
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
	string filename = "Commonwealth_Spartan_Light_Rifle" const
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
