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

Class Ext_PerkFieldMedic extends Ext_PerkBase;

var float RepairArmorRate,AirborneAgentHealRate;
var byte AirborneAgentLevel;

var bool bHealingBoost,bHealingDamageBoost,bHealingShield;
var byte HealingShield;
var const float SelfHealingSurgePct,MaxHealingSpeedBoost,HealingSpeedBoostDuration,MaxHealingDamageBoost,HealingDamageBoostDuration,MaxHealingShield,HealingShieldDuration;
var float HealingSpeedBoostPct, HealingDamageBoostPct, HealingShieldPct;

var bool bUseToxicDamage,bUseSlug,bUseAirborneAgent;

var const class<KFDamageType> ToxicDmgTypeClass;

simulated function ModifyDamageGiven(out int InDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx)
{
	local float TempDamage;

	TempDamage = InDamage;

	if (bUseSlug && WorldInfo.TimeDilation < 1.f && DamageType != none && ClassIsChildOf(DamageType, class'KFDT_Toxic'))
		TempDamage += InDamage * 100;

	InDamage = Round(TempDamage);

	Super.ModifyDamageGiven(InDamage, DamageCauser, MyKFPM, DamageInstigator, DamageType, HitZoneIdx);
}

simulated function ModifyMagSizeAndNumber(KFWeapon KFW, out int MagazineCapacity, optional array< Class<KFPerk> > WeaponPerkClass, optional bool bSecondary=false, optional name WeaponClassname)
{
	if (MagazineCapacity>2 && (KFW==None ? WeaponPerkClass.Find(BasePerk)>=0 : IsWeaponOnPerk(KFW))) // Skip boomstick for this.
		MagazineCapacity = Min(MagazineCapacity*Modifiers[10], bSecondary ? 150 : 255);
}

function bool RepairArmor(Pawn HealTarget)
{
	local KFPawn_Human KFPH;

	if (RepairArmorRate>0)
	{
		KFPH = KFPawn_Human(Healtarget);
		if (KFPH != none && KFPH.Armor < KFPH.MaxArmor)
		{
			KFPH.AddArmor(Round(float(KFPH.MaxArmor) * RepairArmorRate));
			return true;
		}
	}
	return false;
}

function bool ModifyHealAmount(out float HealAmount)
{
	HealAmount*=Modifiers[9];
	return (RepairArmorRate>0);
}

// Di
// simulated function ModifyHealerRechargeTime(out float RechargeRate)
// {
//	super.ModifyHealerRechargeTime(RechargeRate)
// 	RechargeRate /= Clamp(Modifiers[9] * 2, 1.f, 3.f);
// }

function CheckForAirborneAgent(KFPawn HealTarget, class<DamageType> DamType, int HealAmount)
{
	if ((AirborneAgentLevel==1 && WorldInfo.TimeDilation<1.f) || AirborneAgentLevel>1)
		GiveMedicAirborneAgentHealth(HealTarget, DamType, HealAmount);
}

function GiveMedicAirborneAgentHealth(KFPawn HealTarget, class<DamageType> DamType, int HealAmount)
{
	local KFPawn KFP;
	local int RoundedExtraHealAmount;

	RoundedExtraHealAmount = FCeil(float(HealAmount) * AirborneAgentHealRate);

	foreach WorldInfo.Allpawns(class'KFPawn', KFP, HealTarget.Location, 500.f)
	{
		if (KFP.IsAliveAndWell() && WorldInfo.GRI.OnSameTeam(HealTarget, KFP))
		{
			if (HealTarget == KFP)
				KFP.HealDamage(RoundedExtraHealAmount, PlayerOwner, DamType);
			else KFP.HealDamage(RoundedExtraHealAmount + HealAmount, PlayerOwner, DamType);
		}
	}
}

static function class<KFDamageType> GetToxicDmgTypeClass()
{
	return default.ToxicDmgTypeClass;
}

static function int ModifyToxicDmg(int ToxicDamage)
{
	local float TempDamage;

	TempDamage = float(ToxicDamage) * 1.2;
	return FCeil(TempDamage);
}

function NotifyZedTimeStarted()
{
	local KFPawn_Human HPawn;

	HPawn = KFPawn_Human(PlayerOwner.Pawn);

	if (bUseAirborneAgent && HPawn != none && HPawn.IsAliveAndWell())
		HPawn.StartAirBorneAgentEvent();
}

simulated function float GetSnarePower(optional class<DamageType> DamageType, optional byte HitZoneIdx)
{
	if (bUseSlug && WorldInfo.TimeDilation < 1.f && class<KFDamageType>(DamageType)!=None && class<KFDamageType>(DamageType).Default.ModifierPerkList.Find(BasePerk)>=0)
		return 100;

	return 0.f;
}

function AddDefaultInventory(KFPawn P)
{
	local int i;
	i = P.DefaultInventory.Find(class'ExtWeap_Pistol_9mm');
	if (i != -1)
		P.DefaultInventory[i] = class'ExtWeap_Pistol_MedicS';
	super.AddDefaultInventory(P);
}

simulated function bool GetHealingSpeedBoostActive()
{
	return bHealingBoost;
}

simulated function byte GetHealingSpeedBoost()
{
	return byte(HealingSpeedBoostPct);
}

simulated function byte GetMaxHealingSpeedBoost()
{
	return MaxHealingSpeedBoost;
}

simulated function float GetHealingSpeedBoostDuration()
{
	return HealingSpeedBoostDuration;
}

simulated function bool GetHealingDamageBoostActive()
{
	return bHealingDamageBoost;
}

simulated function byte GetHealingDamageBoost()
{
	return byte(HealingDamageBoostPct);
}

simulated function byte GetMaxHealingDamageBoost()
{
	return MaxHealingDamageBoost;
}

simulated function float GetHealingDamageBoostDuration()
{
	return HealingDamageBoostDuration;
}

simulated function bool GetHealingShieldActive()
{
	return bHealingShield;
}

simulated function byte GetHealingShield()
{
	return byte(HealingShieldPct);
}

simulated function byte GetMaxHealingShield()
{
	return MaxHealingShield;
}

simulated function float GetHealingShieldDuration()
{
	return HealingShieldDuration;
}

simulated function float GetSelfHealingSurgePct()
{
	return SelfHealingSurgePct;
}

defaultproperties
{
	PerkIcon=Texture2D'UI_PerkIcons_TEX.UI_PerkIcon_Medic'
	DefTraitList.Remove(class'Ext_TraitMedicPistol')
	DefTraitList.Add(class'Ext_TraitAirborne')
	DefTraitList.Add(class'Ext_TraitWPMedic')
	DefTraitList.Add(class'Ext_TraitAcidicCompound')
	DefTraitList.Add(class'Ext_TraitMedBoost')
	DefTraitList.Add(class'Ext_TraitMedDamBoost')
	DefTraitList.Add(class'Ext_TraitMedShield')
	DefTraitList.Add(class'Ext_TraitZedative')
	DefTraitList.Add(class'Ext_TraitAirborneAgent')
	DefTraitList.Add(class'Ext_TraitArmorRep')
	BasePerk=class'KFPerk_FieldMedic'
	HealExpUpNum=3

	HealingSpeedBoostPct = 10.0f
	HealingDamageBoostPct = 5.0f
	HealingShieldPct = 10.0f

	ToxicDmgTypeClass=class'KFDT_Toxic_AcidicRounds'

	SelfHealingSurgePct=0.1f

	MaxHealingSpeedBoost=30
	HealingSpeedBoostDuration=5.f

	MaxHealingDamageBoost=20
	HealingDamageBoostDuration=5.f

	MaxHealingShield=30
	HealingShieldDuration=5.0f

	DefPerkStats(0)=(MaxValue=70)
	DefPerkStats(9)=(bHiddenConfig=false) // Heal efficiency
	DefPerkStats(15)=(bHiddenConfig=false) // Toxic resistance
	DefPerkStats(16)=(bHiddenConfig=false) // Sonic resistance
	DefPerkStats(17)=(bHiddenConfig=false) // Fire resistance
	DefPerkStats(20)=(bHiddenConfig=false) // Heal recharge

	PrimaryMelee=class'KFWeap_Knife_FieldMedic'
	PrimaryWeapon=None
	PerkGrenade=class'KFProj_MedicGrenade'
	SuperGrenade=class'ExtProj_SUPERMedGrenade'
	SecondaryWeaponDef=class'ExtWeapDef_MedicPistol'

	PrimaryWeaponDef=None
	KnifeWeaponDef=class'KFWeapDef_Knife_Medic'
	GrenadeWeaponDef=class'KFWeapDef_Grenade_Medic'

	AutoBuyLoadOutPath=(class'KFWeapDef_MedicSMG', class'KFWeapDef_MedicShotgun', class'KFWeapDef_MedicRifle')
}