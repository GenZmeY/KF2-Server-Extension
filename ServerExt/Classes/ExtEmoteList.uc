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

class ExtEmoteList extends Object
	abstract;

var const array<Emote> Emotes;

static final function name GetUnlockedEmote(int ItemId, ExtPlayerController PC)
{
	local int i;
	local name Anim;
	local ExtPlayerReplicationInfo PRI;

	i = default.Emotes.Find('Id', ItemId);
	if (i > -1)
	{
		Anim = default.Emotes[i].AnimName;
		PRI = ExtPlayerReplicationInfo(PC.PlayerReplicationInfo);

		if (PRI == None)
			return Anim;

		else return Anim;
	}

	return 'NONE';
}

static final function SaveEquippedEmote(int ItemId, ExtPlayerController PC)
{
	if (PC == None)
		return;

	PC.SelectedEmoteIndex = ItemId;
	PC.SaveConfig();
}

static final function array<Emote> GetEmoteArray()
{
	return default.Emotes;
}

static final function byte GetEmoteIndex(int ItemId)
{
	local int i;
	i = default.Emotes.Find('Id', ItemId);
	if (i > -1)
		return i;

	return -1;
}

static final function int GetEquippedEmoteId(ExtPlayerController PC)
{
	if (PC == None)
		return -1;

	return PC.SelectedEmoteIndex;
}

static final function name GetEmoteFromIndex(byte EmoteIndex)
{
	return default.Emotes[EmoteIndex].AnimName;
}

defaultproperties
{
	Emotes.Add((Id=4515, ItemName = "LetsGetCrazy", 		AnimName="Emote_01_LetsGetCrazy", 		IconPath="EMOTE_TEX.Emote_LetsGoCrazy_512"))
	Emotes.Add((Id=4516, ItemName = "ThunderClap", 			AnimName="Emote_02_ThunderClap", 		IconPath="EMOTE_TEX.Emote_Thunderclap_512"))
	Emotes.Add((Id=4517, ItemName = "UncleCharlie", 		AnimName="Emote_03_UncleCharlie", 		IconPath="EMOTE_TEX.Emote_UncleCharlie_512"))
	Emotes.Add((Id=4518, ItemName = "WackyWave", 			AnimName="Emote_04_WackyWave", 			IconPath="EMOTE_TEX.Emote_WackyWave_512"))
	Emotes.Add((Id=4519, ItemName = "RainingDosh", 			AnimName="Emote_05_RainingDosh", 		IconPath="EMOTE_TEX.Emote_RainingDosh_512"))
	Emotes.Add((Id=4520, ItemName = "LionUppercut", 		AnimName="Emote_06_LionUppercut", 		IconPath="EMOTE_TEX.Emote_Uppercut_512"))
	Emotes.Add((Id=0, ItemName = "MatingRitual", 			AnimName="Emote_07_MatingRitual", 		IconPath="EMOTE_TEX.Emote_MatingRitual_512"))
	Emotes.Add((Id=4522, ItemName = "KickinIt", 			AnimName="Emote_08_KickinIt", 			IconPath="EMOTE_TEX.Emote_KicknIt_512"))
	Emotes.Add((Id=4523, ItemName = "Fireball", 			AnimName="Emote_09_Fireball", 			IconPath="EMOTE_TEX.Emote_Fireball_512"))
	Emotes.Add((Id=4524, ItemName = "Makeitrain", 			AnimName="Emote_10_Makeitrain", 		IconPath="EMOTE_TEX.Emote_MknRain_512"))
	Emotes.Add((Id=4525, ItemName = "Fireball_Deluxe", 		AnimName="Emote_09_Fireball_Deluxe", 	IconPath="EMOTE_TEX.Emote_Fireball_DLX_512"))
	Emotes.Add((Id=4526, ItemName = "Makeitrain_Deluxe", 	AnimName="Emote_10_Makeitrain_Deluxe", 	IconPath="EMOTE_TEX.Emote_MknRain_DLX_512"))
	Emotes.Add((Id=4527, ItemName = "ThunderClap_Deluxe", 	AnimName="Emote_02_ThunderClap_Deluxe", IconPath="EMOTE_TEX.Emote_Thunderclap_DLX_512"))
	Emotes.Add((Id=4528, ItemName = "UncleCharlie_Deluxe", 	AnimName="Emote_03_UncleCharlie_Deluxe",IconPath="EMOTE_TEX.Emote_UncleCharlie_DLX_512"))
	Emotes.Add((Id=4529, ItemName = "LetsGetCrazy_Deluxe", 	AnimName="Emote_01_LetsGetCrazy_Deluxe",IconPath="EMOTE_TEX.Emote_LetsGoCrazy_DLX_512"))
	Emotes.Add((Id=4530, ItemName = "WackyWave_Deluxe", 	AnimName="Emote_04_WackyWave_Deluxe", 	IconPath="EMOTE_TEX.Emote_WackyWave_DLX_512"))
	Emotes.Add((Id=4531, ItemName = "RainingDosh_Deluxe", 	AnimName="Emote_05_RainingDosh_Deluxe", IconPath="EMOTE_TEX.Emote_RainingDosh_DLX_512"))
	Emotes.Add((Id=4532, ItemName = "LionUppercut_Deluxe", 	AnimName="Emote_06_LionUppercut_Deluxe",IconPath="EMOTE_TEX.Emote_Uppercut_DLX_512"))
	Emotes.Add((Id=4533, ItemName = "MatingRitual_Deluxe", 	AnimName="Emote_07_MatingRitual_Deluxe",IconPath="EMOTE_TEX.Emote_MatingRitual_DLX_512"))
	Emotes.Add((Id=4534, ItemName = "KickinIt_Deluxe", 		AnimName="Emote_08_KickinIt_Deluxe", 	IconPath="EMOTE_TEX.Emote_KicknIt_DLX_512"))

	//Emote Crate 2
	Emotes.Add((Id=4744, ItemName = "TheCossack", 			AnimName="Emote_01_Dance", 				IconPath="EMOTE_TEX_02.Emote_02_Squat_Dance_512"))
	Emotes.Add((Id=4754, ItemName = "TheCossack_Deluxe", 	AnimName="Emote_01_Dance_Deluxe", 		IconPath="EMOTE_TEX_02.Emote_02_Squat_Dance_DLX_512"))
	Emotes.Add((Id=4745, ItemName = "TheWave", 				AnimName="Emote_02_Dance", 				IconPath="EMOTE_TEX_02.Emote_02_The_Wave_512"))
	Emotes.Add((Id=4755, ItemName = "TheWave_Deluxe", 		AnimName="Emote_02_Dance_Deluxe", 		IconPath="EMOTE_TEX_02.Emote_02_The_Wave_DLX_512"))
	Emotes.Add((Id=4746, ItemName = "Breakin", 				AnimName="Emote_03_Dance", 				IconPath="EMOTE_TEX_02.Emote_02_Handstand_512"))
	Emotes.Add((Id=4756, ItemName = "Breakin_Deluxe", 		AnimName="Emote_03_Dance_Deluxe", 		IconPath="EMOTE_TEX_02.Emote_02_Handstand_DLX_512"))
	Emotes.Add((Id=4747, ItemName = "NoHands", 				AnimName="Emote_04_Dance", 				IconPath="EMOTE_TEX_02.Emote_02_Kap_Kick_512"))
	Emotes.Add((Id=4757, ItemName = "NoHands_Deluxe", 		AnimName="Emote_04_Dance_Deluxe", 		IconPath="EMOTE_TEX_02.Emote_02_Kap_Kick_DLX_512"))
	Emotes.Add((Id=4748, ItemName = "HealClick", 			AnimName="Emote_05_Dance", 				IconPath="EMOTE_TEX_02.Emote_02_Click_It_512"))
	Emotes.Add((Id=4758, ItemName = "HealClick_Deluxe", 	AnimName="Emote_05_Dance_Deluxe", 		IconPath="EMOTE_TEX_02.Emote_02_Click_It_DLX_512"))
	Emotes.Add((Id=4749, ItemName = "TheSprinkler", 		AnimName="Emote_06_Dance", 				IconPath="EMOTE_TEX_02.Emote_02_The_Sprinkler_512"))
	Emotes.Add((Id=4759, ItemName = "TheSprinkler_Deluxe", 	AnimName="Emote_06_Dance_Deluxe", 		IconPath="EMOTE_TEX_02.Emote_02_The_Sprinkler_DLX_512"))
	Emotes.Add((Id=4750, ItemName = "Maniac", 				AnimName="Emote_07_Dance", 				IconPath="EMOTE_TEX_02.Emote_02_Running_Dosh_512"))
	Emotes.Add((Id=4760, ItemName = "Maniac_Deluxe", 		AnimName="Emote_07_Dance_Deluxe", 		IconPath="EMOTE_TEX_02.Emote_02_Running_Dosh_DLX_512"))
	Emotes.Add((Id=4751, ItemName = "RunningMan", 			AnimName="Emote_08_Dance", 				IconPath="EMOTE_TEX_02.Emote_02_Running_Man_512"))
	Emotes.Add((Id=4761, ItemName = "RunningMan_Deluxe", 	AnimName="Emote_08_Dance_Deluxe", 		IconPath="EMOTE_TEX_02.Emote_02_Running_Man_DLX_512"))
	Emotes.Add((Id=4752, ItemName = "TheRobot", 			AnimName="Emote_09_Dance", 				IconPath="EMOTE_TEX_02.Emote_02_The_Robot_512"))
	Emotes.Add((Id=4762, ItemName = "TheRobot_Deluxe", 		AnimName="Emote_09_Dance_Deluxe", 		IconPath="EMOTE_TEX_02.Emote_02_The_Robot_DLX_512"))
	Emotes.Add((Id=4753, ItemName = "AirMetal", 			AnimName="Emote_10_Dance", 				IconPath="EMOTE_TEX_02.Emote_02_Guitar_Solo_512"))
	Emotes.Add((Id=4763, ItemName = "AirMetal_Deluxe", 		AnimName="Emote_10_Dance_Deluxe", 		IconPath="EMOTE_TEX_02.Emote_02_Guitar_Solo_DLX_512"))

	// Emote Crate 3
	Emotes.Add((Id=7911, ItemName = "Homerun",	 				AnimName="Emote_11_Babe_Ruth", 						IconPath="EMOTE_TEX_03.Emote_03_BabeRuth_512"))
	Emotes.Add((Id=7921, ItemName = "Homerun_Deluxe", 			AnimName="Emote_11_Babe_Ruth_Deluxe", 				IconPath="EMOTE_TEX_03.Emote_03_BabeRuth_DLX_512"))
	Emotes.Add((Id=7907, ItemName = "NeedYourEnergy", 			AnimName="Emote_12_Spirit_Bomb", 					IconPath="EMOTE_TEX_03.Emote_03_SpiritBomb_512"))
	Emotes.Add((Id=7917, ItemName = "NeedYourEnergy_Deluxe",	AnimName="Emote_12_Spirit_Bomb_Deluxe", 			IconPath="EMOTE_TEX_03.Emote_03_SpiritBomb_DLX_512"))
	Emotes.Add((Id=7905, ItemName = "UniversalMastery", 		AnimName="Emote_13_Master_of_the_Universe", 		IconPath="EMOTE_TEX_03.Emote_03_MasteroftheUniverse_512"))
	Emotes.Add((Id=7915, ItemName = "UniversalMastery_Deluxe", 	AnimName="Emote_13_Master_of_the_Universe_Deluxe", 	IconPath="EMOTE_TEX_03.Emote_03_MasteroftheUniverse_DLX_512"))
	Emotes.Add((Id=7909, ItemName = "FastestGun", 				AnimName="Emote_14_Quick_Draw", 					IconPath="EMOTE_TEX_03.Emote_03_QuickDraw_512"))
	Emotes.Add((Id=7919, ItemName = "FastestGun_Deluxe", 		AnimName="Emote_14_Quick_Draw_Deluxe", 				IconPath="EMOTE_TEX_03.Emote_03_QuickDraw_DLX_512"))
	Emotes.Add((Id=7912, ItemName = "CoinTrick", 				AnimName="Emote_15_Coin_Trick", 					IconPath="EMOTE_TEX_03.Emote_03_CoinTrick_512"))
	Emotes.Add((Id=7922, ItemName = "CoinTrick_Deluxe", 		AnimName="Emote_15_Coin_Trick_Deluxe", 				IconPath="EMOTE_TEX_03.Emote_03_CoinTrick_DLX_512"))
	Emotes.Add((Id=7910, ItemName = "SpiritFingers", 			AnimName="Emote_16_Finger_Guns", 					IconPath="EMOTE_TEX_03.Emote_03_FingerGuns_512"))
	Emotes.Add((Id=7920, ItemName = "SpiritFingers_Deluxe", 	AnimName="Emote_16_Finger_Guns_Deluxe", 			IconPath="EMOTE_TEX_03.Emote_03_FingerGuns_DLX_512"))
	Emotes.Add((Id=7913, ItemName = "MagicFoster", 				AnimName="Emote_17_Magic_Mike", 					IconPath="EMOTE_TEX_03.Emote_03_HearMeRoar_512"))
	Emotes.Add((Id=7923, ItemName = "MagicFoster_Deluxe", 		AnimName="Emote_17_Magic_Mike_Deluxe", 				IconPath="EMOTE_TEX_03.Emote_03_HearMeRoar_DLX_512"))
	Emotes.Add((Id=7908, ItemName = "FinalForm", 				AnimName="Emote_18_Noooooooooooo", 					IconPath="EMOTE_TEX_03.Emote_03_Nooo_512"))
	Emotes.Add((Id=7918, ItemName = "FinalForm_Deluxe", 		AnimName="Emote_18_Noooooooooooo_Deluxe", 			IconPath="EMOTE_TEX_03.Emote_03_Nooo_DLX_512"))
	Emotes.Add((Id=7906, ItemName = "ZedTime", 					AnimName="Emote_19_Bullet_Time", 					IconPath="EMOTE_TEX_03.Emote_03_BulletTime_512"))
	Emotes.Add((Id=7916, ItemName = "ZedTime_Deluxe",			AnimName="Emote_19_Bullet_Time_Deluxe", 			IconPath="EMOTE_TEX_03.Emote_03_BulletTime_DLX_512"))
	Emotes.Add((Id=7904, ItemName = "CraneFist", 				AnimName="Emote_20_Kung_Fu", 						IconPath="EMOTE_TEX_03.Emote_03_KungFu_512"))
	Emotes.Add((Id=7914, ItemName = "CraneFist_Deluxe", 		AnimName="Emote_20_Kung_Fu_Deluxe", 				IconPath="EMOTE_TEX_03.Emote_03_KungFu_DLX_512"))
}