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

Class Ext_PerkSharpshooter extends Ext_PerkRhythmPerkBase;

var bool bHasDireReload;
var float ZEDTimeStunPower,DireReloadSpeed;

replication
{
	// Things the server should send to the client.
	if (true)
		bHasDireReload;
}

simulated function float GetReloadRateScale(KFWeapon KFW)
{
	if (bHasDireReload && PlayerOwner.Pawn!=None && PlayerOwner.Pawn.Health<40)
		return Super.GetReloadRateScale(KFW)*DireReloadSpeed;
	return Super.GetReloadRateScale(KFW);
}

function float GetStunPowerModifier(optional class<DamageType> DamageType, optional byte HitZoneIdx)
{
	if (ZEDTimeStunPower>0 && HitZoneIdx==HZI_Head && WorldInfo.TimeDilation<1.f && (class<KFDamageType>(DamageType)!=None && class<KFDamageType>(DamageType).Default.ModifierPerkList.Find(BasePerk)>=0))
		return Super.GetStunPowerModifier(DamageType,HitZoneIdx) + ZEDTimeStunPower;
	return Super.GetStunPowerModifier(DamageType,HitZoneIdx);
}

defaultproperties
{
	PerkIcon=Texture2D'UI_PerkIcons_TEX.UI_PerkIcon_Sharpshooter'
	DefTraitList.Add(class'Ext_TraitWPSharp')
	DefTraitList.Add(class'Ext_TraitRanger')
	DefTraitList.Add(class'Ext_TraitDireReload')
	DefTraitList.Add(class'Ext_TraitEliteReload')
	BasePerk=class'KFPerk_Sharpshooter'
	DefPerkStats(1)=(Progress=0.25)
	DefPerkStats(19)=(bHiddenConfig=false)

	PrimaryMelee=class'KFWeap_Knife_Sharpshooter'
	PrimaryWeapon=class'KFWeap_Rifle_Winchester1894'
	PerkGrenade=class'KFProj_FreezeGrenade'

	PrimaryWeaponDef=class'KFWeapDef_Winchester1894'
	KnifeWeaponDef=class'KFWeapDef_Knife_Sharpshooter'
	GrenadeWeaponDef=class'KFWeapDef_Grenade_Sharpshooter'

	AutoBuyLoadOutPath=(class'KFWeapDef_Winchester1894', class'KFWeapDef_Crossbow', class'KFWeapDef_M14EBR', class'KFWeapDef_RailGun')

	DireReloadSpeed=0.25f
}