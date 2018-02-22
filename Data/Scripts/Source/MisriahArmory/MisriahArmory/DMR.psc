Scriptname MisriahArmory:DMR extends ObjectReference
{Attaches to: DMR "M392 DMR" [WEAP:0205BDA4]}
import MisriahArmory:Log

Actor Owner
int Count = 0
int Capacity = 0

; Materials
MatSwap DMR_AmmoCounter_Blue_00 ; {DMR_AmmoCounter_Blue_00 [MSWP:0005BDA8]}
MatSwap:RemapData[] Remapping
MatSwap:RemapData DigitFirst
MatSwap:RemapData DigitLast

; Biped Slots
int BipedWeapon = 41 Const

; Animation Events
string WeaponFire = "weaponFire" const
string ReloadComplete = "reloadComplete" const


Group Properties
	Weapon Property DMR Auto Const Mandatory
EndGroup


; Events
;---------------------------------------------

Event OnInit()
	DMR_AmmoCounter_Blue_00 = Game.GetFormFromFile(0x0005BDA8, "MisriahArmory.esp") as MatSwap
	WriteLine(self, "Initialized with material: "+DMR_AmmoCounter_Blue_00)
EndEvent


Event OnEquipped(Actor akActor)
	Owner = akActor
	Capacity = GetAmmoCapacity()
	Count = GetAmmoAmount()
	Remapping = new MatSwap:RemapData[0]

	DigitFirst = new MatSwap:RemapData
	DigitFirst.Source = "MisriahArmory\\DMR\\AmmoCounter\\#_\\0.bgsm"
	DigitFirst.Target = GetFirstDigit(Count)
	Remapping.Add(DigitFirst)

	DigitLast = new MatSwap:RemapData
	DigitLast.Source = "MisriahArmory\\DMR\\AmmoCounter\\_#\\0.bgsm"
	DigitLast.Target = GetLastDigit(Count)
	Remapping.Add(DigitLast)

	;ApplySwap()

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
		MisriahArmory:Log.WriteLine(self, "The animation event "+asEventName+" was unhandled.")
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
	InstanceData:Owner instance = DMR.GetInstanceOwner()
	Ammo ammoType = InstanceData.GetAmmo(instance)
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
		return "MisriahArmory\\DMR\\AmmoCounter\\#_\\" + digit + ".bgsm"
	Else
		return "MisriahArmory\\DMR\\AmmoCounter\\#_\\0.bgsm"
	EndIf
EndFunction


string Function GetLastDigit(int number) Global
	If (number)
		int digit = number % 10
		return "MisriahArmory\\DMR\\AmmoCounter\\_#\\" + digit + ".bgsm"
	Else
		return "MisriahArmory\\DMR\\AmmoCounter\\_#\\0.bgsm"
	EndIf
EndFunction


Function ApplySwap()
	DMR_AmmoCounter_Blue_00.SetRemapData(Remapping)
	Owner.ApplyMaterialSwap(DMR_AmmoCounter_Blue_00)
EndFunction


string Function ToString()
	return "("+Count+"/"+Capacity+") First:"+DigitFirst.Target+", Last:"+DigitLast.Target
EndFunction
