Scriptname MisriahArmory:DMR_DebugOnly extends Quest Const DebugOnly
{Temporary script to add in game items to test this project.}


Event OnQuestInit()
	Player.AddItem(DMR, 3, true)
	Player.AddItem(Ammo308Caliber, 100, true)
EndEvent


Group Properties
	Actor Property Player Auto Const Mandatory
	Weapon Property DMR Auto Const Mandatory
	Ammo Property Ammo308Caliber Auto Const Mandatory
EndGroup
