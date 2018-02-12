Scriptname Commonwealth_Spartan:Light_Rifle_DebugOnly extends Quest DebugOnly
{Attaches to Quest, CommonwealthSpartan_Weapon_LightRifle_DebugOnly}

Group TestOnly
	Actor Property Player Auto Const Mandatory
	Weapon Property CommonwealthSpartan_Weapon_LightRifle Auto Const Mandatory
	Ammo Property CommonwealthSpartan_ForerunnerAmmo Auto Const Mandatory
EndGroup


Event OnQuestInit()
	Player.AddItem(CommonwealthSpartan_Weapon_LightRifle)
	Player.AddItem(CommonwealthSpartan_ForerunnerAmmo, 150)
EndEvent
