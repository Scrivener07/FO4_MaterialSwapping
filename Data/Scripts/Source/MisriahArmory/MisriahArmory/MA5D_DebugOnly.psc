Scriptname MisriahArmory:MA5D_DebugOnly extends Quest Const DebugOnly
{Temporary script to add in game items to test this project.}


Event OnQuestInit()
	Player.AddItem(MA5D, 3, true)
	Player.AddItem(Ammo308Caliber, 100, true)
EndEvent


Group Properties
	Actor Property Player Auto Const Mandatory
	Weapon Property MA5D Auto Const Mandatory
	Ammo Property Ammo308Caliber Auto Const Mandatory
EndGroup
