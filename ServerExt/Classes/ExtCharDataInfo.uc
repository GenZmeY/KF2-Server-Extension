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

Class ExtCharDataInfo extends Object
	config(Game)
	perobjectconfig
	DependsOn(ExtPlayerReplicationInfo);

var config int HeadMeshIndex,HeadSkinIndex,BodyMeshIndex,BodySkinIndex,AttachmentMesh0,AttachmentSkin0,AttachmentMesh1,AttachmentSkin1,AttachmentMesh2,AttachmentSkin2,HasInit;

final function FMyCustomChar LoadData()
{
	local FMyCustomChar R;

	if (HasInit==0)
	{
		AttachmentMesh0 = `CLEARED_ATTACHMENT_INDEX;
		AttachmentMesh1 = `CLEARED_ATTACHMENT_INDEX;
		AttachmentMesh2 = `CLEARED_ATTACHMENT_INDEX;
	}
	R.HeadMeshIndex = HeadMeshIndex;
	R.HeadSkinIndex = HeadSkinIndex;
	R.BodyMeshIndex = BodyMeshIndex;
	R.BodySkinIndex = BodySkinIndex;
	R.AttachmentMeshIndices[0] = AttachmentMesh0;
	R.AttachmentSkinIndices[0] = AttachmentSkin0;
	R.AttachmentMeshIndices[1] = AttachmentMesh1;
	R.AttachmentSkinIndices[1] = AttachmentSkin1;
	R.AttachmentMeshIndices[2] = AttachmentMesh2;
	R.AttachmentSkinIndices[2] = AttachmentSkin2;
	return R;
}

final function SaveData(FMyCustomChar R)
{
	HeadMeshIndex = R.HeadMeshIndex;
	HeadSkinIndex = R.HeadSkinIndex;
	BodyMeshIndex = R.BodyMeshIndex;
	BodySkinIndex = R.BodySkinIndex;
	AttachmentMesh0 = R.AttachmentMeshIndices[0];
	AttachmentSkin0 = R.AttachmentSkinIndices[0];
	AttachmentMesh1 = R.AttachmentMeshIndices[1];
	AttachmentSkin1 = R.AttachmentSkinIndices[1];
	AttachmentMesh2 = R.AttachmentMeshIndices[2];
	AttachmentSkin2 = R.AttachmentSkinIndices[2];
	HasInit = 1;
	SaveConfig();
}

defaultproperties
{

}