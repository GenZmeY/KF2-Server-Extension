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

Class KFGUI_ListItem extends Object
	transient;

var KFGUI_ListItem Next;
var array<string> Columns,SortColumns;
var int Index,Value;

var transient string Temp; // Cache sorting key.

function SetValue(string S, int i, string SortStr)
{
	ParseStringIntoArray(S,Columns,"\n",false);
	if (SortStr=="")
		SortColumns.Length = 0;
	else ParseStringIntoArray(Caps(SortStr),SortColumns,"\n",false);
	Value = i;
}

// Return string to draw on HUD.
function string GetDisplayStr(int Column)
{
	if (Column<Columns.Length)
		return Columns[Column];
	return "";
}

// Return string to compare string with.
function string GetSortStr(int Column)
{
	if (SortColumns.Length>0)
	{
		if (Column<SortColumns.Length)
			return SortColumns[Column];
	}
	if (Column<Columns.Length)
		return Caps(Columns[Column]);
	return "";
}

// Clear
function Clear()
{
	Columns.Length = 0;
}
