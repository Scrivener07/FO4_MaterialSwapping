Scriptname Commonwealth_Spartan:Forerunner_RadioBeacon extends ObjectReference
{Attaches to, CommonwealthSpartan_Forerunner_RadioBeacon "Forerunner Recruitment Radio Beacon" [ACTI:050324A6]}

bool Toggled = true

; Materials
MatSwap mat_CommonwealthSpartan_Forerunner_RadioBeacon ; {mat_CommonwealthSpartan_Forerunner_RadioBeacon [MSWP:0x00032D0F]}
MatSwap:RemapData[] Remapping
MatSwap:RemapData Remap
string GlowOn  = "Commonwealth_Spartan\\Misc\\Forerunner_OrangeGlow.bgsm" const
string GlowOff = "Commonwealth_Spartan\\Misc\\Forerunner_NowGlow.bgsm" const


Event OnInit()
	mat_CommonwealthSpartan_Forerunner_RadioBeacon = Game.GetFormFromFile(0x00032D0F, "Commonwealth_Spartan_Redux.esp") as MatSwap
	WriteLine(self, "Got material: "+mat_CommonwealthSpartan_Forerunner_RadioBeacon)
	Remapping = new MatSwap:RemapData[0]
	Remap = new MatSwap:RemapData
	Remap.Source = GlowOn
	Remap.Target = GlowOff
	Remapping.Add(Remap)
	ApplySwap()
EndEvent


Event OnPowerOn(ObjectReference akPowerGenerator)
	Remap.Target = GlowOn
	ApplySwap()
	Toggled = true
	WriteLine(self, "OnPowerOn")
EndEvent


Event OnActivate(ObjectReference akActionRef)
	If (self.IsPowered())
		Toggled = !Toggled
		If (Toggled)
			Remap.Target = GlowOn
			ApplySwap()
		Else
			Remap.Target = GlowOff
			ApplySwap()
		EndIf
	Else
		Remap.Target = GlowOff
		ApplySwap()
		Toggled = false
	EndIf
EndEvent


Event OnPowerOff()
	Remap.Target = GlowOff
	ApplySwap()
	Toggled = false
	WriteLine(self, "OnPowerOff")
EndEvent


Function ApplySwap()
	mat_CommonwealthSpartan_Forerunner_RadioBeacon.SetRemapData(Remapping)
	self.ApplyMaterialSwap(mat_CommonwealthSpartan_Forerunner_RadioBeacon)
	WriteLine(self, "Applied Swap:"+Remapping)
EndFunction


; Logging
;---------------------------------------------

Function Trace(string prefix, string text) Global DebugOnly
	text = prefix + " " + text
 	Debug.Trace(text)
EndFunction


bool Function WriteLine(string prefix, string text) Global DebugOnly
	string filename = "Forerunner_RadioBeacon" const
	text = prefix + " " + text
	If(Debug.TraceUser(filename, text))
		return true
	Else
		Debug.OpenUserLog(filename)
		return Debug.TraceUser(filename, text)
	EndIf
EndFunction
