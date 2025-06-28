// This file is part of Server Extension.
// Server Extension - a mutator for Killing Floor 2.
//
// Copyright (C) 2016-2024 The Server Extension authors and contributors
//
// Server Extension is free software: you can redistribute it
// and/or modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation,
// either version 3 of the License, or (at your option) any later version.
//
// Server Extension is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along
// with Server Extension. If not, see <https://www.gnu.org/licenses/>.

Class Ext_PerkDemolition extends Ext_PerkBase;

var bool bSirenResistance,bCanUseSacrifice,bDirectHit,bCriticalHit,bProfessionalActive;
var bool bUsedSacrifice;
var float AOEMult, NukeDamageMult;

replication
{
	// Things the server should send to the client.
	if (true)
		NukeDamageMult,bDirectHit,bCriticalHit,bProfessionalActive,AOEMult;
}

simulated function float GetAoERadiusModifier()
{
	return AOEMult;
}

simulated function bool GetUsingTactialReload(KFWeapon KFW)
{
	return (IsWeaponOnPerk(KFW) ? Modifiers[5]<0.85 : false);
}

simulated function float ApplyEffect(name Type, float Value, float Progress)
{
	local KFPlayerReplicationInfo MyPRI;
	local float DefValue;

	DefValue = Super.ApplyEffect(Type, Value, Progress);
	MyPRI = KFPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo);

	if (MyPRI != None && Type == 'KnockDown')
		MyPRI.bConcussiveActive = Modifiers[7] > 1.5;

	return DefValue;
}

function OnWaveEnded()
{
	bUsedSacrifice = false;
}

simulated function ModifyDamageGiven(out int InDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx)
{
	if (BasePerk==None || (DamageType!=None && DamageType.Default.ModifierPerkList.Find(BasePerk)>=0) || (KFWeapon(DamageCauser)!=None && IsWeaponOnPerk(KFWeapon(DamageCauser))))
	{
		if (bDirectHit && class<KFDT_Ballistic_Shell>(DamageType) != none)
			InDamage *= 1.25;

		if (bCriticalHit && MyKFPM != none && IsCriticalHitZone(MyKFPM, HitZoneIdx))
			InDamage *= 1.5f;
	}

	if (class<KFDT_DemoNuke_Toxic_Lingering>(DamageType) != None)
		InDamage *= NukeDamageMult;

	Super.ModifyDamageGiven(InDamage, DamageCauser, MyKFPM, DamageInstigator, DamageType, HitZoneIdx);
}

function bool IsCriticalHitZone(KFPawn TestPawn, int HitZoneIndex)
{
	if (TestPawn != none && HitzoneIndex >= 0 && HitzoneIndex < TestPawn.HitZones.length)
		return TestPawn.HitZones[HitZoneIndex].DmgScale > 1.f;

	return false;
}

simulated function ModifySpareAmmoAmount(KFWeapon KFW, out int PrimarySpareAmmo, optional const out STraderItem TraderItem, optional bool bSecondary)
{
	if (KFW != None && KFWeap_Thrown_C4(KFW) != None)
		PrimarySpareAmmo += (1 + Modifiers[11]);

	Super.ModifySpareAmmoAmount(KFW, PrimarySpareAmmo, TraderItem, bSecondary);
}

defaultproperties
{
	PerkIcon=Texture2D'UI_PerkIcons_TEX.UI_PerkIcon_Demolition'
	DefTraitList.Add(class'Ext_TraitWPDemo')
	DefTraitList.Add(class'Ext_TraitBoomWeld')
	DefTraitList.Add(class'Ext_TraitContactNade')
	DefTraitList.Add(class'Ext_TraitSupplyGren')
	DefTraitList.Add(class'Ext_TraitSirenResistance')
	DefTraitList.Add(class'Ext_TraitDemoDirectHit')
	DefTraitList.Add(class'Ext_TraitDemoCriticalHit')
	DefTraitList.Add(class'Ext_TraitDemoAOE')
	DefTraitList.Add(class'Ext_TraitDemoReactiveArmor')
	DefTraitList.Add(class'Ext_TraitDemoNuke')
	DefTraitList.Add(class'Ext_TraitDemoProfessional')
	BasePerk=class'KFPerk_Demolitionist'

	AOEMult=1.0f
	NukeDamageMult=1.0f

	PrimaryMelee=class'KFWeap_Knife_Demolitionist'
	PrimaryWeapon=class'KFWeap_GrenadeLauncher_HX25'
	PerkGrenade=class'KFProj_DynamiteGrenade'

	PrimaryWeaponDef=class'KFWeapDef_HX25'
	KnifeWeaponDef=class'KFWeapDef_Knife_Demo'
	GrenadeWeaponDef=class'KFWeapDef_Grenade_Demo'

	AutoBuyLoadOutPath=(class'KFWeapDef_HX25', class'KFWeapDef_M79', class'KFWeapDef_M16M203', class'KFWeapDef_RPG7')

	DefPerkStats(10)=(bHiddenConfig=true) // No support for mag size on demo.
	DefPerkStats(13)=(bHiddenConfig=false) // Self damage.
}