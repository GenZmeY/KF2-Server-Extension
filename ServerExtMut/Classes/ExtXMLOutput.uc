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

Class ExtXMLOutput extends FileWriter implements(ExtStatWriter);

var transient string Intendent;
var transient array<string> StackedSect;

event PreBeginPlay();

final function DumpXML(ExtPerkManager M)
{
	OpenFile(class'OnlineSubsystem'.Static.UniqueNetIdToString(M.PRIOwner.UniqueId),FWFT_Stats,".xml",false);
	M.OutputXML(Self);
	CloseFile();
	ResetFile();
}

function WriteValue(string Key, string Value)
{
	Logf(Intendent$"<"$Key$">"$Value$"</"$Key$">");
}

function StartIntendent(string Section, optional string Key, optional string Value)
{
	if (Key!="")
		Logf(Intendent$"-<"$Section$" "$Key$"=\""$Value$"\">");
	else Logf(Intendent$"-<"$Section$">");
	Intendent $= Chr(9);
	StackedSect.AddItem(Section);
}

function EndIntendent()
{
	Intendent = Left(Intendent,Len(Intendent)-1);
	Logf(Intendent$"</"$StackedSect[StackedSect.Length-1]$">");
	StackedSect.Remove(StackedSect.Length-1,1);
}

function ResetFile()
{
	Intendent = "";
	StackedSect.Length = 0;
}

defaultproperties
{
	bFlushEachWrite=false
}
