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

Class Ext_PerkRhythmPerkBase extends Ext_PerkBase;

var byte HeadShotComboCount,MaxRhythmCombo;
var float RhythmComboDmg;
var private const float HeadShotCountdownIntervall;

simulated function ModifyDamageGiven(out int InDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx)
{
	Super.ModifyDamageGiven(InDamage,DamageCauser,MyKFPM,DamageInstigator,DamageType,HitZoneIdx);
	if (RhythmComboDmg>0 && BasePerk==None || (DamageType!=None && DamageType.Default.ModifierPerkList.Find(BasePerk)>=0) || IsWeaponOnPerk(KFWeapon(DamageCauser)))
		InDamage *= (1.f+RhythmComboDmg);
}

final function SetMaxRhythm(byte MaxCombo)
{
	MaxRhythmCombo = MaxCombo;
}

final function ResetRhythm()
{
	MaxRhythmCombo = 0;
	HeadShotComboCount = 0;
	RhythmComboDmg = 0;
	HeadShotMessage(0,true,1);
}

function SubstractHeadShotCombo()
{
	if (HeadShotComboCount > 0)
		UpdateDmgScale(false);
	else
		ClearTimer(nameOf(SubstractHeadShotCombo));
}

final function UpdateDmgScale(bool bUp)
{
	if (bUp)
	{
		HeadShotComboCount = Min(HeadShotComboCount+1,MaxRhythmCombo);
		HeadShotMessage(HeadShotComboCount,false,MaxRhythmCombo);
		SetTimer(HeadShotCountdownIntervall, true, nameOf(SubstractHeadShotCombo));
	}
	else if (HeadShotComboCount>0)
	{
		--HeadShotComboCount;
		HeadShotMessage(HeadShotComboCount,true,MaxRhythmCombo);
	}
	else return;
	RhythmComboDmg = HeadShotComboCount*0.075;
}

function UpdatePerkHeadShots(ImpactInfo Impact, class<DamageType> DamageType, int NumHit)
{
	local int HitZoneIdx;
	local KFPawn_Monster KFPM;

	if (MaxRhythmCombo<=0)
		return;
	KFPM = KFPawn_Monster(Impact.HitActor);
	if (KFPM==none || KFPM.GetTeamNum()==0)
		return;

	HitZoneIdx = KFPM.HitZones.Find('ZoneName', Impact.HitInfo.BoneName);
	if (HitZoneIdx == HZI_Head && KFPM.IsAliveAndWell())
	{
		if (class<KFDamageType>(DamageType)!=None && (class<KFDamageType>(DamageType).Default.ModifierPerkList.Find(BasePerk)>=0))
			UpdateDmgScale(true);
	}
}

reliable client function HeadShotMessage(byte HeadShotNum, bool bMissed, byte MaxHits)
{
	local AkEvent TempAkEvent;
	local KFPlayerController PC;

	PC = KFPlayerController(PlayerOwner);
	if (PC==none || PC.MyGFxHUD==none)
	{
		return;
	}

	PC.MyGFxHUD.RhythmCounterWidget.SetInt("count", HeadShotNum);
	PC.MyGFxHUD.RhythmCounterWidget.SetBonusPercentage(float(HeadShotNum) / float(MaxHits));

	if (HeadshotNum==0)
		TempAkEvent = AkEvent'WW_UI_PlayerCharacter.Play_R_Method_Reset';
	else if (HeadShotNum<MaxHits)
	{
		if (!bMissed)
		{
			//PC.ClientSpawnCameraLensEffect(class'KFCameraLensEmit_RackemHeadShot');
			TempAkEvent = AkEvent'WW_UI_PlayerCharacter.Play_R_Method_Hit';
		}
	}
	else if (!bMissed)
	{
		//PC.ClientSpawnCameraLensEffect(class'KFCameraLensEmit_RackemHeadShotPing');
		TempAkEvent = AkEvent'WW_UI_PlayerCharacter.Play_R_Method_Top';
		HeadshotNum = 6;
	}

	if (TempAkEvent != none)
		PC.PlayRMEffect(TempAkEvent, 'R_Method', HeadshotNum);
}

defaultproperties
{
	HeadShotCountdownIntervall=2.f
}