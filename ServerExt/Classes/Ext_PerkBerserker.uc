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

Class Ext_PerkBerserker extends Ext_PerkBase;

var float VampRegenRate,ZedTimeMeleeAtkRate;

replication
{
	// Things the server should send to the client.
	if (true)
		ZedTimeMeleeAtkRate;
}

simulated function ModifyMeleeAttackSpeed(out float InDuration)
{
	InDuration *= Modifiers[4];
	if (ZedTimeMeleeAtkRate<1.f && WorldInfo.TimeDilation<1.f)
		InDuration *= ZedTimeMeleeAtkRate;
}

simulated function ModifyRateOfFire(out float InRate, KFWeapon KFW)
{
	if (IsWeaponOnPerk(KFW))
	{
		InRate *= Modifiers[4];
		if (ZedTimeMeleeAtkRate<1.f && WorldInfo.TimeDilation<1.f)
			InRate *= ZedTimeMeleeAtkRate;
	}
}

function PlayerKilled(KFPawn_Monster Victim, class<DamageType> DT)
{
	if (VampRegenRate>0 && PlayerOwner.Pawn!=None && PlayerOwner.Pawn.Health>0 && class<KFDamageType>(DT)!=None && class<KFDamageType>(DT).Default.ModifierPerkList.Find(BasePerk)>=0)
		PlayerOwner.Pawn.HealDamage(Max(PlayerOwner.Pawn.HealthMax*VampRegenRate,1), PlayerOwner, class'KFDT_Healing', false, false);
}

defaultproperties
{
	PerkIcon=Texture2D'UI_PerkIcons_TEX.UI_PerkIcon_Berserker'
	DefTraitList.Add(class'Ext_TraitWPBers')
	DefTraitList.Add(class'Ext_TraitUnGrab')
	DefTraitList.Add(class'Ext_TraitVampire')
	DefTraitList.Add(class'Ext_TraitSpartan')
	DefPerkStats(15)=(bHiddenConfig=false) // Poison damage.
	BasePerk=class'KFPerk_Berserker'

	PrimaryMelee=class'KFWeap_Knife_Berserker'
	PrimaryWeapon=class'KFWeap_Blunt_Crovel'
	PerkGrenade=class'KFProj_EMPGrenade'

	PrimaryWeaponDef=class'KFWeapDef_Crovel'
	KnifeWeaponDef=class'KFweapDef_Knife_Berserker'
	GrenadeWeaponDef=class'KFWeapDef_Grenade_Berserker'

	AutoBuyLoadOutPath=(class'KFWeapDef_Crovel', class'KFWeapDef_Nailgun', class'KFWeapDef_Pulverizer', class'KFWeapDef_Eviscerator')

	ZedTimeMeleeAtkRate=1.0
}