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

Class ExtPlayerReplicationInfo extends KFPlayerReplicationInfo;

struct FCustomCharEntry
{
	var bool bLock;
	var KFCharacterInfo_Human Char;
	var ObjectReferencer Ref;
};
struct FMyCustomChar // Now without constant.
{
	var int CharacterIndex,HeadMeshIndex,HeadSkinIndex,BodyMeshIndex,BodySkinIndex,AttachmentMeshIndices[`MAX_COSMETIC_ATTACHMENTS],AttachmentSkinIndices[`MAX_COSMETIC_ATTACHMENTS];

	structdefaultproperties
	{
		AttachmentMeshIndices[0]=`CLEARED_ATTACHMENT_INDEX
		AttachmentMeshIndices[1]=`CLEARED_ATTACHMENT_INDEX
		AttachmentMeshIndices[2]=`CLEARED_ATTACHMENT_INDEX
	}
};

var bool bIsMuted,bInitialPT,bIsDev,bHiddenUser,bClientUseCustom,bClientFirstChar,bClientCharListDone,bClientInitChars;

enum E_AdminType
{
	AT_Global,
	AT_Admin,
	AT_Mod,
	AT_TMem,
	AT_VIP,
	AT_Booster,
	AT_Player
};

var E_AdminType AdminType;

var int RespawnCounter;
var class<Ext_PerkBase> ECurrentPerk;
var Ext_PerkBase FCurrentPerk;
var int ECurrentPerkLevel,ECurrentPerkPrestige;
var ExtPerkManager PerkManager;
var string TaggedPlayerName;
var repnotify string NameTag;
var repnotify byte RepLevelProgress;
var transient color HUDPerkColor;
var byte FixedData;
var int RepPlayTime,RepKills,RepEXP;

// Custom character stuff.
var array<FCustomCharEntry> CustomCharList;
var repnotify FMyCustomChar CustomCharacter;
var transient array<ExtCharDataInfo> SaveDataObjects;
var transient ExtPlayerReplicationInfo LocalOwnerPRI; // Local playercontroller owner PRI

// Supplier data:
var transient struct FSupplierData
{
	var transient Pawn SuppliedPawn;
	var transient float NextSupplyTimer;
} SupplierLimit;
var repnotify class<Ext_TraitSupply> HasSupplier;

replication
{
	// Things the server should send to the client.
	if (true)
		RespawnCounter,AdminType,ECurrentPerk,ECurrentPerkLevel,ECurrentPerkPrestige,RepKills,RepEXP,RepLevelProgress,bIsDev,NameTag,FixedData,bHiddenUser,CustomCharacter,HasSupplier;
	if (bNetInitial || bInitialPT)
		RepPlayTime;
}

simulated function PostBeginPlay()
{
	local PlayerController PC;

	Super.PostBeginPlay();
	SetTimer(1,true,'TickPT');
	if (WorldInfo.NetMode!=NM_DedicatedServer)
	{
		HUDPerkColor = PickPerkColor();
		PC = GetALocalPlayerController();
		if (PC!=None)
			LocalOwnerPRI = ExtPlayerReplicationInfo(PC.PlayerReplicationInfo);
	}
	else LocalOwnerPRI = Self; // Dedicated server can use self PRI.
}

// Resupply traits:
simulated final function bool CanUseSupply(Pawn P)
{
	return (SupplierLimit.SuppliedPawn!=P || SupplierLimit.NextSupplyTimer<WorldInfo.TimeSeconds);
}

simulated final function UsedSupply(Pawn P, float NextTime)
{
	SupplierLimit.SuppliedPawn = P;
	SupplierLimit.NextSupplyTimer = WorldInfo.TimeSeconds+NextTime;
}

simulated function ClientInitialize(Controller C)
{
	local ExtPlayerReplicationInfo PRI;

	Super.ClientInitialize(C);

	if (WorldInfo.NetMode!=NM_DedicatedServer)
	{
		LocalOwnerPRI = Self;

		// Make all other PRI's load character list from local owner PRI.
		foreach DynamicActors(class'ExtPlayerReplicationInfo',PRI)
			PRI.LocalOwnerPRI = Self;
	}
}

simulated function TickPT()
{
	++RepPlayTime;
}

simulated event ReplicatedEvent(name VarName)
{
	switch (VarName)
	{
	case 'RepLevelProgress':
		HUDPerkColor = PickPerkColor();
		break;
	case 'CustomCharacter':
		CharacterCustomizationChanged();
		break;
	case 'HasSupplier':
		SupplierLimit.SuppliedPawn = None; // Reset if stat was changed.
		break;
	case 'PlayerName':
	case 'NameTag':
		UpdateNameTag();
	default:
		Super.ReplicatedEvent(VarName);
	}
}

function SetPlayerName(string S)
{
	Super.SetPlayerName(S);
	UpdateNameTag();
}

function SetPlayerNameTag(string S)
{
	NameTag = S;
	UpdateNameTag();
}

function OverrideWith(PlayerReplicationInfo PRI)
{
	Super.OverrideWith(PRI);
	NameTag = ExtPlayerReplicationInfo(PRI).NameTag;
	bAdmin = PRI.bAdmin;
	AdminType = ExtPlayerReplicationInfo(PRI).AdminType;
	UpdateNameTag();
}

simulated final function UpdateNameTag()
{
	if (NameTag!="")
		TaggedPlayerName = "["$NameTag$"] "$PlayerName;
	else TaggedPlayerName = PlayerName;
}

final function SetLevelProgress(int CurLevel, int CurPrest, int MinLevel, int MaxLevel)
{
	local float V;

	ECurrentPerkLevel = CurLevel;
	ECurrentPerkPrestige = CurPrest;
	V = FClamp((float(CurLevel-MinLevel) / float(MaxLevel-MinLevel))*255.f,0,255);
	RepLevelProgress = V;
	bForceNetUpdate = true;

	if (WorldInfo.NetMode!=NM_DedicatedServer)
		HUDPerkColor = PickPerkColor();
}

simulated final function string GetPerkLevelStr()
{
	return (ECurrentPerkPrestige>0 ? (string(ECurrentPerkPrestige)$"-"$string(ECurrentPerkLevel)) : string(ECurrentPerkLevel));
}

simulated final function color PickPerkColor()
{
	local float P;
	local byte i;

	if (RepLevelProgress==0)
		return MakeColor(255,255,255,255);
	P = float(RepLevelProgress) / 255.f;
	if (P<0.25f) // White - Blue
	{
		i = 255 - (P*1020.f);
		return MakeColor(i,i,255,255);
	}
	if (P<0.5f) // Blue - Green
	{
		i = ((P-0.25f)*1020.f);
		return MakeColor(0,i,255-i,255);
	}
	if (P<0.75f) // Green - Red
	{
		i = ((P-0.5f)*1020.f);
		return MakeColor(i,255-i,0,255);
	}
	// Red - Yellow
	i = ((P-0.75f)*1020.f);
	return MakeColor(255,i,0,255);
}

function SetInitPlayTime(int T)
{
	bInitialPT = true;
	bForceNetUpdate = true;
	RepPlayTime = T;
	SetTimer(5,false,'UnsetPT');
}

function UnsetPT()
{
	bInitialPT = false;
}

simulated final function bool ShowAdminName()
{
	return (bAdmin || AdminType < AT_Player);
}

simulated function string GetAdminName()
{
	switch (AdminType)
	{
	case AT_Global:
		return "Super Admin";
	case AT_Admin:
	case AT_Player: // TODO: Admin is the same as player? WTF? #1
		return "Admin";
	case AT_Mod:
		return "Mod";
	case AT_TMem:
		return "Trusted Member";
	case AT_VIP:
		return "VIP";
	case AT_Booster:
		return "Booster";
	}
}

simulated function string GetAdminNameAbr()
{
	switch (AdminType)
	{
	case AT_Global:
		return "S";
	case AT_Admin:
	case AT_Player: // TODO: Admin is the same as player? WTF? #2
		return "A";
	case AT_Mod:
		return "M";
	case AT_TMem:
		return "T";
	case AT_VIP:
		return "V";
	case AT_Booster:
		return "B";
	}
}

simulated function string GetAdminColor()
{
	switch (AdminType)
	{
	case AT_Global:
		return "FF6600";
	case AT_Admin:
	case AT_Player: // TODO: Admin is the same as player? WTF? #3
		return "40FFFF";
	case AT_Mod:
		return "FF33FF";
	case AT_TMem:
		return "FF0000";
	case AT_VIP:
		return "FFD700";
	case AT_Booster:
		return "32A852";
	}
}

simulated function color GetAdminColorC()
{
	switch (AdminType)
	{
	case AT_Global:
		return MakeColor(255,102,0,255);
	case AT_Admin:
	case AT_Player: // TODO: Admin is the same as player? WTF? #4
		return MakeColor(64,255,255,255);
	case AT_Mod:
		return MakeColor(255,51,255,255);
	case AT_TMem:
		return MakeColor(255,0,0,255);
	case AT_VIP:
		return MakeColor(255,215,0,255);
	case AT_Booster:
		return MakeColor(50,168,82,255);
	}
}

simulated function string GetHumanReadableName()
{
	return TaggedPlayerName;
}

function SetFixedData(byte M)
{
	OnModeSet(Self,M);
	FixedData = FixedData | M;
	SetTimer(5,false,'ClearFixed');
}

function ClearFixed()
{
	FixedData = 0;
}

simulated final function string GetDesc()
{
	local string S;

	if ((FixedData & 1)!=0)
		S = "A.";
	if ((FixedData & 2)!=0)
		S $= "WF.";
	if ((FixedData & 4)!=0)
		S $= "G.";
	if ((FixedData & 8)!=0)
		S $= "NW.";
	if ((FixedData & 16)!=0)
		S $= "WA.";
	return S;
}

delegate OnModeSet(ExtPlayerReplicationInfo PRI, byte Num);

simulated final function bool LoadPlayerCharacter(byte CharIndex, out FMyCustomChar CharInfo)
{
	local KFCharacterInfo_Human C;

	if (CharIndex>=(CharacterArchetypes.Length+CustomCharList.Length))
		return false;

	if (SaveDataObjects.Length<=CharIndex)
		SaveDataObjects.Length = CharIndex+1;
	if (SaveDataObjects[CharIndex]==None)
	{
		C = (CharIndex<CharacterArchetypes.Length) ? CharacterArchetypes[CharIndex] : CustomCharList[CharIndex-CharacterArchetypes.Length].Char;
		SaveDataObjects[CharIndex] = new(None,PathName(C)) class'ExtCharDataInfo';
	}
	CharInfo = SaveDataObjects[CharIndex].LoadData();
	return true;
}

simulated final function bool SavePlayerCharacter()
{
	local KFCharacterInfo_Human C;

	if (CustomCharacter.CharacterIndex>=(CharacterArchetypes.Length+CustomCharList.Length))
		return false;

	if (SaveDataObjects.Length<=CustomCharacter.CharacterIndex)
		SaveDataObjects.Length = CustomCharacter.CharacterIndex+1;
	if (SaveDataObjects[CustomCharacter.CharacterIndex]==None)
	{
		C = (CustomCharacter.CharacterIndex<CharacterArchetypes.Length) ? CharacterArchetypes[CustomCharacter.CharacterIndex] : CustomCharList[CustomCharacter.CharacterIndex-CharacterArchetypes.Length].Char;
		SaveDataObjects[CustomCharacter.CharacterIndex] = new(None,PathName(C)) class'ExtCharDataInfo';
	}
	SaveDataObjects[CustomCharacter.CharacterIndex].SaveData(CustomCharacter);
	return true;
}

simulated function ChangeCharacter(byte CharIndex, optional bool bFirstSet)
{
	local FMyCustomChar NewChar;
	local byte i;

	if (CharIndex>=(CharacterArchetypes.Length+CustomCharList.Length) || IsClientCharLocked(CharIndex))
		CharIndex = 0;

	if (bFirstSet && RepCustomizationInfo.CharacterIndex==CharIndex)
	{
		// Copy properties from default character info.
		NewChar.HeadMeshIndex = RepCustomizationInfo.HeadMeshIndex;
		NewChar.HeadSkinIndex = RepCustomizationInfo.HeadSkinIndex;
		NewChar.BodyMeshIndex = RepCustomizationInfo.BodyMeshIndex;
		NewChar.BodySkinIndex = RepCustomizationInfo.BodySkinIndex;
		for (i=0; i<`MAX_COSMETIC_ATTACHMENTS; ++i)
		{
			NewChar.AttachmentMeshIndices[i] = RepCustomizationInfo.AttachmentMeshIndices[i];
			NewChar.AttachmentSkinIndices[i] = RepCustomizationInfo.AttachmentSkinIndices[i];
		}
	}
	if (LoadPlayerCharacter(CharIndex,NewChar))
	{
		NewChar.CharacterIndex = CharIndex;
		CustomCharacter = NewChar;
		ServerSetCharacterX(NewChar);
		if (WorldInfo.NetMode==NM_Client)
			CharacterCustomizationChanged();
	}
}

simulated function UpdateCustomization(int Type, int MeshIndex, int SkinIndex, optional int SlotIndex)
{
	switch (Type)
	{
	case CO_Head:
		CustomCharacter.HeadMeshIndex = MeshIndex;
		CustomCharacter.HeadSkinIndex = SkinIndex;
		break;
	case CO_Body:
		CustomCharacter.BodyMeshIndex = MeshIndex;
		CustomCharacter.BodySkinIndex = SkinIndex;
		break;
	case CO_Attachment:
		CustomCharacter.AttachmentMeshIndices[SlotIndex] = MeshIndex;
		CustomCharacter.AttachmentSkinIndices[SlotIndex] = SkinIndex;
		break;
	}
	SavePlayerCharacter();
	ServerSetCharacterX(CustomCharacter);
	if (WorldInfo.NetMode==NM_Client)
		CharacterCustomizationChanged();
}

simulated final function RemoveAttachments()
{
	local byte i;

	for (i=0; i<`MAX_COSMETIC_ATTACHMENTS; ++i)
	{
		CustomCharacter.AttachmentMeshIndices[i] = `CLEARED_ATTACHMENT_INDEX;
		CustomCharacter.AttachmentSkinIndices[i] = 0;
	}
	SavePlayerCharacter();
	ServerSetCharacterX(CustomCharacter);
	if (WorldInfo.NetMode==NM_Client)
		CharacterCustomizationChanged();
}

simulated function ClearCharacterAttachment(int AttachmentIndex)
{
	if (UsesCustomChar())
	{
		CustomCharacter.AttachmentMeshIndices[AttachmentIndex] = `CLEARED_ATTACHMENT_INDEX;
		CustomCharacter.AttachmentSkinIndices[AttachmentIndex] = 0;
	}
	else Super.ClearCharacterAttachment(AttachmentIndex);
}

reliable server final function ServerSetCharacterX(FMyCustomChar NewMeshInfo)
{
	if (NewMeshInfo.CharacterIndex>=(CharacterArchetypes.Length+CustomCharList.Length) || IsClientCharLocked(NewMeshInfo.CharacterIndex))
		return;

	CustomCharacter = NewMeshInfo;

	if (Role == Role_Authority)
	{
		CharacterCustomizationChanged();
	}
}

simulated final function bool IsClientCharLocked(byte Index)
{
	if (Index<CharacterArchetypes.Length)
		return false;
	Index-=CharacterArchetypes.Length;
	return (Index<CustomCharList.Length && CustomCharList[Index].bLock && !ShowAdminName());
}

simulated reliable client function ReceivedCharacter(byte Index, FCustomCharEntry C)
{
	if (WorldInfo.NetMode==NM_DedicatedServer)
		return;

	if (CustomCharList.Length<=Index)
		CustomCharList.Length = Index+1;
	CustomCharList[Index] = C;
}

simulated reliable client function AllCharReceived()
{
	if (WorldInfo.NetMode==NM_DedicatedServer)
		return;

	if (!bClientInitChars)
	{
		OnCharListDone();
		NotifyCharListDone();
		bClientInitChars = true;
	}
}

simulated final function NotifyCharListDone()
{
	local KFPawn_Human KFP;
	local KFCharacterInfo_Human NewCharArch;
	local ExtPlayerReplicationInfo EPRI;

	foreach WorldInfo.AllPawns(class'KFPawn_Human', KFP)
	{
		EPRI = ExtPlayerReplicationInfo(KFP.PlayerReplicationInfo);
		if (EPRI!=None)
		{
			NewCharArch = EPRI.GetSelectedArch();

			if (NewCharArch != KFP.CharacterArch)
			{
				// selected a new character
				KFP.SetCharacterArch(NewCharArch);
			}
			else if (WorldInfo.NetMode != NM_DedicatedServer)
			{
				// refresh cosmetics only
				class'ExtCharacterInfo'.Static.SetCharacterMeshFromArch(NewCharArch, KFP, EPRI);
			}
		}
	}
}

simulated delegate OnCharListDone();

// Player has a server specific setting for a character selected.
simulated final function bool UsesCustomChar()
{
	if (LocalOwnerPRI==None)
		return false; // Not yet init on client.
	return CustomCharacter.CharacterIndex<(LocalOwnerPRI.CustomCharList.Length+CharacterArchetypes.Length);
}

// Client uses a server specific custom character.
simulated final function bool ReallyUsingCustomChar()
{
	if (!UsesCustomChar())
		return false;
	return (CustomCharacter.CharacterIndex>=CharacterArchetypes.Length);
}

simulated final function KFCharacterInfo_Human GetSelectedArch()
{
	if (UsesCustomChar())
		return (CustomCharacter.CharacterIndex<CharacterArchetypes.Length) ? CharacterArchetypes[CustomCharacter.CharacterIndex] : LocalOwnerPRI.CustomCharList[CustomCharacter.CharacterIndex-CharacterArchetypes.Length].Char;
	return CharacterArchetypes[RepCustomizationInfo.CharacterIndex];
}

simulated event CharacterCustomizationChanged()
{
	local KFPawn_Human KFP;
	local KFCharacterInfo_Human NewCharArch;

	foreach WorldInfo.AllPawns(class'KFPawn_Human', KFP)
	{
		if (KFP.PlayerReplicationInfo == self || (KFP.DrivenVehicle != None && KFP.DrivenVehicle.PlayerReplicationInfo == self))
		{
			NewCharArch = GetSelectedArch();

			if (NewCharArch != KFP.CharacterArch)
			{
				// selected a new character
				KFP.SetCharacterArch(NewCharArch);
			}
			else if (WorldInfo.NetMode != NM_DedicatedServer)
			{
				// refresh cosmetics only
				class'ExtCharacterInfo'.Static.SetCharacterMeshFromArch(NewCharArch, KFP, self);
			}
		}
	}
}

// Save/Load custom character information.
final function SaveCustomCharacter(ExtSaveDataBase Data)
{
	local byte i,c;
	local string S;

	// Write the name of custom character.
	if (UsesCustomChar())
		S = string(GetSelectedArch().Name);
	Data.SaveStr(S);
	if (S=="")
		return;

	// Write selected accessories.
	Data.SaveInt(CustomCharacter.HeadMeshIndex);
	Data.SaveInt(CustomCharacter.HeadSkinIndex);
	Data.SaveInt(CustomCharacter.BodyMeshIndex);
	Data.SaveInt(CustomCharacter.BodySkinIndex);

	c = 0;
	for (i=0; i<`MAX_COSMETIC_ATTACHMENTS; ++i)
	{
		if (CustomCharacter.AttachmentMeshIndices[i]!=`CLEARED_ATTACHMENT_INDEX)
			++c;
	}

	// Write attachments count.
	Data.SaveInt(c);

	// Write attachments.
	for (i=0; i<`MAX_COSMETIC_ATTACHMENTS; ++i)
	{
		if (CustomCharacter.AttachmentMeshIndices[i]!=`CLEARED_ATTACHMENT_INDEX)
		{
			Data.SaveInt(i);
			Data.SaveInt(CustomCharacter.AttachmentMeshIndices[i]);
			Data.SaveInt(CustomCharacter.AttachmentSkinIndices[i]);
		}
	}
}

final function LoadCustomCharacter(ExtSaveDataBase Data)
{
	local string S;
	local byte i,n,j;

	if (Data.GetArVer()>=2)
		S = Data.ReadStr();
	if (S=="") // Stock skin.
		return;

	for (i=0; i<CharacterArchetypes.Length; ++i)
	{
		if (string(CharacterArchetypes[i].Name)~=S)
			break;
	}

	if (i==CharacterArchetypes.Length)
	{
		for (i=0; i<CustomCharList.Length; ++i)
		{
			if (string(CustomCharList[i].Char.Name)~=S)
				break;
		}
		if (i==CharacterArchetypes.Length)
		{
			// Character not found = Skip data.
			Data.SkipBytes(4);
			n = Data.ReadInt();
			for (i=0; i<n; ++i)
				Data.SkipBytes(3);
			return;
		}
		i+=CharacterArchetypes.Length;
	}

	CustomCharacter.CharacterIndex = i;
	CustomCharacter.HeadMeshIndex = Data.ReadInt();
	CustomCharacter.HeadSkinIndex = Data.ReadInt();
	CustomCharacter.BodyMeshIndex = Data.ReadInt();
	CustomCharacter.BodySkinIndex = Data.ReadInt();

	n = Data.ReadInt();
	for (i=0; i<n; ++i)
	{
		j = Min(Data.ReadInt(),`MAX_COSMETIC_ATTACHMENTS-1);
		CustomCharacter.AttachmentMeshIndices[j] = Data.ReadInt();
		CustomCharacter.AttachmentSkinIndices[j] = Data.ReadInt();
	}
	bNetDirty = true;
}

// Only used to skip offset (in case of an error).
static final function DummyLoadChar(ExtSaveDataBase Data)
{
	local string S;
	local byte i,n;

	if (Data.GetArVer()>=2)
		S = Data.ReadStr();
	if (S=="") // Stock skin.
		return;

	Data.SkipBytes(4);
	n = Data.ReadInt();
	for (i=0; i<n; ++i)
		Data.SkipBytes(3);
}

static final function DummySaveChar(ExtSaveDataBase Data)
{
	Data.SaveStr("");
}

simulated function Texture2D GetCurrentIconToDisplay()
{
	if (CurrentVoiceCommsRequest == VCT_NONE && ECurrentPerk != none)
	{
		return ECurrentPerk.default.PerkIcon;
	}

	return class'KFLocalMessage_VoiceComms'.default.VoiceCommsIcons[CurrentVoiceCommsRequest];
}

// Set admin levels without having to hard-reference to this mod.
event BeginState(Name N)
{
	switch (N)
	{
	case 'Global':
		AdminType = AT_Global;
		break;
	case 'Admin':
		AdminType = AT_Admin;
		break;
	case 'Mod':
		AdminType = AT_Mod;
		break;
	case 'TMem':
		AdminType = AT_TMem;
		break;
	case 'VIP':
		AdminType = AT_VIP;
		break;
	case 'Booster':
		AdminType = AT_Booster;
		break;
	case 'User':
		AdminType = AT_Player;
		break;
	}
}

defaultproperties
{
	RespawnCounter=-1
	AdminType=AT_Player
	TaggedPlayerName="Player"
}