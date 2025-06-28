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

Class Ext_TraitZED_Summon extends Ext_TraitZEDBase;

var localized string GroupDescription;

struct FZEDTypes
{
	var() array< class<KFPawn_Monster> > Zeds;
};
var() array<FZEDTypes> DefZedTypes;
var config array<string> ZedTypes;
var config float ZedRespawnTime;
var config int FinalLevelPrestige;

function string GetPerkDescription()
{
	local string S;

	S = Super.GetPerkDescription();
	if (Default.FinalLevelPrestige>0)
		S $= "|"$GroupDescription@"#{FF4000}"$Default.FinalLevelPrestige;
	return S;
}

static function CheckConfig()
{
	local byte i,j;

	if (Default.ZedTypes.Length==0)
	{
		Default.ZedTypes.Length = Default.DefZedTypes.Length;
		for (i=0; i<Default.ZedTypes.Length; ++i)
		{
			for (j=0; j<Default.DefZedTypes[i].Zeds.Length; ++j)
			{
				if (j==0)
					Default.ZedTypes[i] = PathName(Default.DefZedTypes[i].Zeds[j]);
				else Default.ZedTypes[i] $= ","$PathName(Default.DefZedTypes[i].Zeds[j]);
			}
		}
		Default.ZedRespawnTime = 60.f;
		Default.FinalLevelPrestige = 3;
		StaticSaveConfig();
	}
	else if (Default.ZedTypes.Length==5) // Upgrade config from old version.
	{
		Default.ZedTypes.Length = Default.DefZedTypes.Length;
		for (i=5; i<Default.ZedTypes.Length; ++i)
		{
			for (j=0; j<Default.DefZedTypes[i].Zeds.Length; ++j)
			{
				if (j==0)
					Default.ZedTypes[i] = PathName(Default.DefZedTypes[i].Zeds[j]);
				else Default.ZedTypes[i] $= ","$PathName(Default.DefZedTypes[i].Zeds[j]);
			}
		}
		if (Default.LevelCosts.Length==5)
			Default.LevelCosts.AddItem(Default.DefLevelCosts[5]);
		Default.FinalLevelPrestige = 3;
		StaticSaveConfig();
	}
	if (Default.ZedRespawnTime==0)
	{
		Default.ZedRespawnTime = 60.f;
		StaticSaveConfig();
	}
	Super.CheckConfig();
	class'Ext_T_ZEDHelper'.Static.LoadMonsterList();
}

static function bool MeetsRequirements(byte Lvl, Ext_PerkBase Perk)
{
	local int i;

	// First check level.
	if (Perk.CurrentLevel<Default.MinLevel || (Lvl>=5 && Perk.CurrentPrestige<Default.FinalLevelPrestige))
		return false;

	// Then check base trait.
	if (Lvl==0 && Default.BaseTrait!=None)
	{
		i = Perk.PerkStats.Find('StatType','Damage');
		if (i>=0)
			return (Perk.PerkStats[i].CurrentValue>=30);
	}
	return true;
}

static function ApplyEffectOn(KFPawn_Human Player, Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	local Ext_T_ZEDHelper H;
	local int i;

	H = Player.Spawn(class'Ext_T_ZEDHelper',Player);
	if (H!=None)
		H.CurLevel = Level-1;

	// Make other traits refresh (apply HP/damage scalers).
	for (i=0; i<Perk.PerkTraits.Length; ++i)
		if (Perk.PerkTraits[i].CurrentLevel>0 && Class<Ext_TraitZEDBase>(Perk.PerkTraits[i].TraitType)!=None && !Class<Ext_TraitZEDBase>(Perk.PerkTraits[i].TraitType).Default.bIsSummoner)
			Perk.PerkTraits[i].TraitType.Static.ApplyEffectOn(Player,Perk,Level,Data);
}

static function CancelEffectOn(KFPawn_Human Player, Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	local Ext_T_ZEDHelper H;

	foreach Player.ChildActors(class'Ext_T_ZEDHelper',H)
		if (!H.bIsExtra)
			H.Destroy();
}

// Replication for final level prestige.
static function string GetRepData()
{
	local string S;

	S = Super.GetRepData();
	S $= IntToStr(Default.FinalLevelPrestige);
	return S;
}

static function string ClientSetRepData(string S)
{
	S = Super.ClientSetRepData(S);
	Default.FinalLevelPrestige = StrToInt(S);
	return S;
}

static function string GetValue(name PropName, int ElementIndex)
{
	switch (PropName)
	{
	case 'ZedTypes':
		return (ElementIndex==-1 ? string(Default.ZedTypes.Length) : Default.ZedTypes[ElementIndex]);
	case 'ZedRespawnTime':
		return string(Default.ZedRespawnTime);
	case 'FinalLevelPrestige':
		return string(Default.FinalLevelPrestige);
	default:
		return Super.GetValue(PropName,ElementIndex);
	}
}

static function ApplyValue(name PropName, int ElementIndex, string Value)
{
	switch (PropName)
	{
	case 'ZedTypes':
		if (Value!="#DELETE" && ElementIndex<Default.ZedTypes.Length)
			Default.ZedTypes[ElementIndex] = Value;
		break;
	case 'ZedRespawnTime':
		Default.ZedRespawnTime = float(Value);
		break;
	case 'FinalLevelPrestige':
		Default.FinalLevelPrestige = int(Value);
		break;
	default:
		Super.ApplyValue(PropName,ElementIndex,Value);
		return;
	}
	StaticSaveConfig();
}

defaultproperties
{
	bIsSummoner=true
	NumLevels=6
	DefLevelCosts(0)=20
	DefLevelCosts(1)=10
	DefLevelCosts(2)=10
	DefLevelCosts(3)=20
	DefLevelCosts(4)=30
	DefLevelCosts(5)=100
	DefMinLevel=20

	DefZedTypes.Add((Zeds=(Class'KFPawn_ZedClot_Alpha',Class'KFPawn_ZedClot_Slasher',Class'KFPawn_ZedClot_Cyst',Class'KFPawn_ZedCrawler')))
	DefZedTypes.Add((Zeds=(Class'KFPawn_ZedClot_Slasher',Class'KFPawn_ZedGorefast',Class'KFPawn_ZedStalker')))
	DefZedTypes.Add((Zeds=(Class'KFPawn_ZedBloat',Class'KFPawn_ZedStalker',Class'KFPawn_ZedGorefast')))
	DefZedTypes.Add((Zeds=(Class'KFPawn_ZedHusk',Class'KFPawn_ZedSirenX',Class'KFPawn_ZedScrake')))
	DefZedTypes.Add((Zeds=(Class'KFPawn_ZedSirenX',Class'KFPawn_ZedFleshpound',Class'KFPawn_ZedScrake')))
	DefZedTypes.Add((Zeds=(Class'ExtPawn_ZedHans_Pet')))

	WebConfigs.Add((PropType=2,PropName="ZedTypes",UIName="Zed Types",UIDesc="Type of zeds each level can spawn (separate types with a comma)",NumElements=-1))
	WebConfigs.Add((PropType=0,PropName="ZedRespawnTime",UIName="Zed RespawnTime",UIDesc="Time in seconds it takes for zeds to respawn"))
	WebConfigs.Add((PropType=0,PropName="FinalLevelPrestige",UIName="Final Level Prestige",UIDesc="Prestige level required for this perks final level"))
}