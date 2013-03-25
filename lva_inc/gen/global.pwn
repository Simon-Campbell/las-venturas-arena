//==============================================================================
//	littlewhitey Las Venturas Deathmatch (global.pwn)
//      Credits:	adamcs, BrandonB, littlewhitey, Mike, Simon
//      Version:    1.0
//==============================================================================

#if defined __global__included
	#endinput
#endif

#define __global__included

//==============================================================================
// Macros

#define minrand(%1,%2)		random(%2 - %1) + %1
#define dcmd(%1,%2,%3)		if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1  // Created by DracoBlue
#define SendUsage(%1,%2)    SendClientMessage(%1,COLOR_WHITE,"USAGE: " %2)
#define SendError(%1,%2)    SendClientMessage(%1,COLOR_RED,"ERROR: " %2)

//==============================================================================
// Functions

stock IsStringSame( const string1[ ], const string2[ ], len )
{
	// Created by Sintax.
	// Checks if string1 is the same as string 2.
	
	for(new i = 0; i < len; i++)
	{
	    if ( string1[ i ] != string2[ i ] )
			return 0;
		
		if ( string1[ i ] == '\0' || string1[i] == '\n' )
			return 1;
	}
	return 1;
}

stock GetXYInFrontOfPlayer( PlayerID, &Float:fPlayerX, &Float:fPlayerY, Float:fPlayerDistance )
{
	// Created by Y_Less with a simple mod by Simon (getting vehicle angle).
	// Gets the X and Y coordinates in front of a player.
	
	new
	    _:		iPlayerVehicleID= GetPlayerVehicleID( PlayerID ),
		Float:	fPlayerAngle	= 0.0;

	GetPlayerPos( PlayerID, fPlayerX, fPlayerY, fPlayerAngle );
	
	if ( iPlayerVehicleID )
		GetVehicleZAngle( iPlayerVehicleID, fPlayerAngle );
	else
	    GetPlayerFacingAngle( PlayerID, fPlayerAngle );


	fPlayerX += ( fPlayerDistance * floatsin( -fPlayerAngle, degrees ) );
	fPlayerY += ( fPlayerDistance * floatcos( -fPlayerAngle, degrees ) );
}

stock IsValidSkin(skinid)
{
	// Created by Simon.
	// Checks whether the skinid parsed is crashable or not.

	#define	MAX_BAD_SKINS   14

	new badSkins[MAX_BAD_SKINS] = {
		3, 4, 5, 6, 8, 42, 65, 74, 86,
		119, 149, 208, 273, 289
	};

	if  (skinid < 0 || skinid > 299) return false;
	for (new i = 0; i < MAX_BAD_SKINS; i++) {
	    if (skinid == badSkins[i]) return false;
	}

	#undef MAX_BAD_SKINS
	return true;
}

stock IsPlayerInRange( PlayerID, Float:X, Float:Y, Float:Z, Float:Range, Float:ZRange=4.0 )
{
	/* Checks if the player is in the range of the specified coordinates
	 * using the specified range.
	 */
	 
	new
		Float:pX,
		Float:pY,
		Float:pZ;

	GetPlayerPos( PlayerID, pX, pY, pZ );

	if ( floatsqroot( floatpower( floatabs( floatsub( X, pX ) ),2 ) + floatpower ( floatabs (floatsub( Y, pY ) ),2 ) ) < Range && ( pZ < Z + ZRange ) && ( pZ > Z - ZRange ) )
		return 1;

	else
		return 0;
}

stock strtok( const string[], &index )
{
	/* Seperates a string into chunks using spaces.
	 * Starts checking at index.
	 */
	new length = strlen( string );
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

stock IsPlayerInArea( PlayerID, Float:MinX, Float:MaxX, Float:MinY, Float:MaxY, Float:MinZ=-99999.0, Float:MaxZ=99999.9 )
{
	// Checks if the player is inside the cube specified.

	new Float:pX, Float:pY, Float:pZ;

	GetPlayerPos(PlayerID, pX, pY, pZ);

	if (pX > MinX && pX < MaxX && pY > MinY && pY < MaxY && pZ > MinZ && pZ < MaxZ) return 1;
	else return 0;
}

stock IsPointInArea( Float:pX, Float:pY, Float:pZ, Float:MinX, Float:MaxX, Float:MinY, Float:MaxY, Float:MinZ=-99999.9, Float:MaxZ=99999.9 )
{
	// Checks if a point is inside the cube specified.

	if (pX > MinX && pX < MaxX && pY > MinY && pY < MaxY && pZ > MinZ && pZ < MaxZ) return 1;
	else return 0;
}

/*----------------------------------------------------------------------------*-
Function:
	sscanf
Params:
	string[] - String to extract parameters from.
	format[] - Parameter types to get.
	{Float,_}:... - Data return variables.
Return:
	0 - Successful, not 0 - fail.
Notes:
	A fail is either insufficient variables to store the data or insufficient
	data for the format string - excess data is disgarded.

	A string in the middle of the input data is extracted as a single word, a
	string at the end of the data collects all remaining text.

	The format codes are:

	c - A character.
	d, i - An integer.
	h, x - A hex number (e.g. a colour).
	f - A float.
	s - A string.
	z - An optional string.
	pX - An additional delimiter where X is another character.
	'' - Encloses a literal string to locate.
	u - User, takes a name, part of a name or an id and returns the id if they're connected.

	Now has IsNumeric integrated into the code.

	Added additional delimiters in the form of all whitespace and an
	optionally specified one in the format string.
-*----------------------------------------------------------------------------*/

stock sscanf(string[], format[], {Float,_}:...)
{
	#if defined isnull
		if (isnull(string))
	#else
		if (string[0] == 0 || (string[0] == 1 && string[1] == 0))
	#endif
		{
			return format[0];
		}
	#pragma tabsize 4
	new
		formatPos = 0,
		stringPos = 0,
		paramPos = 2,
		paramCount = numargs(),
		delim = ' ';
	while (string[stringPos] && string[stringPos] <= ' ')
	{
		stringPos++;
	}
	while (paramPos < paramCount && string[stringPos])
	{
		switch (format[formatPos++])
		{
			case '\0':
			{
				return 0;
			}
			case 'i', 'd':
			{
				new
					neg = 1,
					num = 0,
					ch = string[stringPos];
				if (ch == '-')
				{
					neg = -1;
					ch = string[++stringPos];
				}
				do
				{
					stringPos++;
					if ('0' <= ch <= '9')
					{
						num = (num * 10) + (ch - '0');
					}
					else
					{
						return -1;
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num * neg);
			}
			case 'h', 'x':
			{
				new
					num = 0,
					ch = string[stringPos];
				do
				{
					stringPos++;
					switch (ch)
					{
						case 'x', 'X':
						{
							num = 0;
							continue;
						}
						case '0' .. '9':
						{
							num = (num << 4) | (ch - '0');
						}
						case 'a' .. 'f':
						{
							num = (num << 4) | (ch - ('a' - 10));
						}
						case 'A' .. 'F':
						{
							num = (num << 4) | (ch - ('A' - 10));
						}
						default:
						{
							return -1;
						}
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num);
			}
			case 'c':
			{
				setarg(paramPos, 0, string[stringPos++]);
			}
			case 'f':
			{
				setarg(paramPos, 0, _:floatstr(string[stringPos]));
			}
			case 'p':
			{
				delim = format[formatPos++];
				continue;
			}
			case '\'':
			{
				new
					end = formatPos - 1,
					ch;
				while ((ch = format[++end]) && ch != '\'') {}
				if (!ch)
				{
					return -1;
				}
				format[end] = '\0';
				if ((ch = strfind(string, format[formatPos], false, stringPos)) == -1)
				{
					if (format[end + 1])
					{
						return -1;
					}
					return 0;
				}
				format[end] = '\'';
				stringPos = ch + (end - formatPos);
				formatPos = end + 1;
			}
			case 'u':
			{
				new
					end = stringPos - 1,
					id = 0,
					bool:num = true,
					ch;
				while ((ch = string[++end]) && ch != delim)
				{
					if (num)
					{
						if ('0' <= ch <= '9')
						{
							id = (id * 10) + (ch - '0');
						}
						else
						{
							num = false;
						}
					}
				}
				if (num && IsPlayerConnected(id))
				{
					setarg(paramPos, 0, id);
				}
				else
				{
					#if !defined foreach
						#define foreach(%1,%2) for (new %2 = 0; %2 < MAX_PLAYERS; %2++) if (IsPlayerConnected(%2))
						#define __SSCANF_FOREACH__
					#endif
					string[end] = '\0';
					num = false;
					new
						name[MAX_PLAYER_NAME];
					id = end - stringPos;
					foreach (Player, playerid)
					{
						GetPlayerName(playerid, name, sizeof (name));
						if (!strcmp(name, string[stringPos], true, id))
						{
							setarg(paramPos, 0, playerid);
							num = true;
							break;
						}
					}
					if (!num)
					{
						setarg(paramPos, 0, INVALID_PLAYER_ID);
					}
					string[end] = ch;
					#if defined __SSCANF_FOREACH__
						#undef foreach
						#undef __SSCANF_FOREACH__
					#endif
				}
				stringPos = end;
			}
			case 's', 'z':
			{
				new
					i = 0,
					ch;
				if (format[formatPos])
				{
					while ((ch = string[stringPos++]) && ch != delim)
					{
						setarg(paramPos, i++, ch);
					}
					if (!i)
					{
						return -1;
					}
				}
				else
				{
					while ((ch = string[stringPos++]))
					{
						setarg(paramPos, i++, ch);
					}
				}
				stringPos--;
				setarg(paramPos, i, '\0');
			}
			default:
			{
				continue;
			}
		}
		while (string[stringPos] && string[stringPos] != delim && string[stringPos] > ' ')
		{
			stringPos++;
		}
		while (string[stringPos] && (string[stringPos] == delim || string[stringPos] <= ' '))
		{
			stringPos++;
		}
		paramPos++;
	}
	do
	{
		if ((delim = format[formatPos++]) > ' ')
		{
			if (delim == '\'')
			{
				while ((delim = format[formatPos++]) && delim != '\'') {}
			}
			else if (delim != 'z')
			{
				return delim;
			}
		}
	}
	while (delim > ' ');
	return 0;
}

stock IsNumeric(const string[]) {
	new length=strlen(string);
	if (length==0) return false;
	for (new i = 0; i < length; i++) {
		if (
		(string[i] > '9' || string[i] < '0' && string[i]!='-' && string[i]!='+') // Not a number,'+' or '-'
		|| (string[i]=='-' && i!=0)                                             // A '-' but not at first.
		|| (string[i]=='+' && i!=0)                                             // A '+' but not at first.
		) return false;
	}
	if (length==1 && (string[0]=='-' || string[0]=='+')) return false;
	return true;
}

stock strcpy( dest[ ], src[ ], startdest = 0, startsrc = 0 )
{
	// Created by Peter
	
	for ( new i = startsrc, j = strlen( src ); i < j; i++ )
	{
		dest[ startdest++ ] = src[ i ];
	}
	dest[ startdest ] = 0;
}

#define WEAPON_NOSLOT -1

stock GetWeaponSlot(weaponid)
{
	// Created by Betamaster.
	
	new slot;
	switch(weaponid){
		case 0, 1: slot = 0;            // No weapon
		case 2 .. 9: slot = 1;          // Melee
		case 22 .. 24: slot = 2;        // Handguns
		case 25 .. 27: slot = 3;        // Shotguns
		case 28, 29, 32: slot = 4;      // Sub-Machineguns
		case 30, 31: slot = 5;          // Machineguns
		case 33, 34: slot = 6;          // Rifles
		case 35 .. 38: slot = 7;        // Heavy Weapons
		case 16, 18, 39: slot = 8;      // Projectiles
		case 42, 43: slot = 9;          // Special 1
		case 14: slot = 10;             // Gifts
		case 44 .. 46: slot = 11;       // Special 2
		case 40: slot = 12;             // Detonators
		default: slot = WEAPON_NOSLOT;  // No slot
	}
	return slot;
}

stock power( x, y )
{
	assert y >= 0;
	new r = 1;
	for ( new i = 0; i < y; i++ )
		r *= x;
	return r;
}

