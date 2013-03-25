//==============================================================================
//	littlewhitey Las Venturas Deathmatch (gangs.pwn)
//      Credits:	adamcs, BrandonB, littlewhitey, Mike, Simon
//      Version:    1.0
//==============================================================================

#if defined __gangs__included
	#endinput
#endif

#define __gangs__included

//==============================================================================
// Defines

#define INVALID_GANG_ID 0xFF

//==============================================================================
// Enumerators

enum E_GANG_LEAVE_REASON
{
	/*	Reasons for leaving gangs.
	    GANG_LEAVE_QUIT		-> Quit reason.
	    GANG_LEAVE_KICK		-> Kick reason. When used with RemovePlayerFromGang it
	    there should be a otherid.
	    GANG_LEAVE_UNKNOWN	-> Unknown reason.
	*/
	
	GANG_LEAVE_QUIT,
	GANG_LEAVE_KICK,
	GANG_LEAVE_UNKNOWN
};

enum E_GANG_DATA
{
	/*	Types of gang data.
	    G_NAME		-> Name of gang.
	    G_LEADER	-> Leader of the gang.
	    G_TOTALS	-> Number of gang members in gang.
	    G_KILLS		-> Number of kills the gang has made.
	    G_DEATHS	-> Number of deaths the gang has made.
	    G_BANK		-> Amount of money in the gang's bank.
	    G_COLOR		-> The gangs colour.
	    G_ZONE_TEXT -> The text ID for when a zone is owned by a gang.
	*/
	
	G_NAME		[ MAX_GANG_NAME ],
	G_MEMBERS	[ MAX_GANG_MEMBERS ],
	G_LEADER,
	G_TOTALS,
	G_KILLS,
	G_DEATHS,
	G_ALLY,
	G_BANK,
	G_COLOR,
	Text:G_BANK_TEXT,
	Text:G_ZONE_TEXT
};

//==============================================================================
// Variables

new gData[ MAX_GANGS ][ E_GANG_DATA ], gTotals;

//==============================================================================
// Forwards

// Callbacks
forward OnPlayerCreateGang( playerid, gangid );
forward OnPlayerJoinGang( playerid, gangid );
forward OnPlayerLeaveGang( playerid, gangid, isleader, reason, otherid );
forward OnGangDeath( gangid, leaderid, gname[ ] );

// Timer functions.
forward TextDrawHideForGang( gangid, Text:_txt );

//==============================================================================
// Functions

stock IsPlayerInAnyGang( playerid )
{
	/*	Checks if a player is in any gang. Returns 1 if true and 0 if false.
		@playerid:	playerid you want to check.
	*/
		
	if ( pData[ playerid ][ P_GANG_ID ] != INVALID_GANG_ID )
		return 1;
	else
		return 0;
}

stock IsPlayerInGang( playerid, gangid )
{
	/*	Checks if the player is in the specified gangid.
		@playerid:	playerid you want to check is in gang.
		@gangid:	gangid you want to see if player is in.
	*/
		
	if ( pData[ playerid ][ P_GANG_ID ] == gangid && pData[ playerid ][ P_GANG_ID ] != INVALID_GANG_ID )
	    return 1;
	else
		return 0;
}

stock IsValidGang( gangid )
{
	/*  Checks if the gangid is a valid gang.
	    @gangid:    Gang you'd like to check.
	*/
	    
	if ( gangid < 0 || gangid > MAX_GANGS || !gData[ gangid ][ G_TOTALS ] )
	    return 0;
	else
	    return 1;
}

stock SendClientMessageToGang( gangid, color, msg[ ] )
{
	/*  Sends a client message to all of the gang with the
	    specified colour.
		@gangid:    Gang you'd like to send message to.
	    @color:     Colour of the message.
	    @msg:       Message to send to gang.
	*/
	
	// Loop through all players in gang and if their gang is equal to gangid then
	// send them the client message.

	for ( new memberid = 0; memberid < gData[ gangid ][ G_TOTALS ]; memberid++ )
	{
	    if ( IsPlayerConnected( gData[ gangid ][ G_MEMBERS ][ memberid ] ) )
			SendClientMessage( gData[ gangid ][ G_MEMBERS ][ memberid ], color, msg );
	}
	    
	return 1;
}

stock ShiftGangIDs( gangid, startid, shift )
{
	/*	Shifts all gang positions in the direction of choice starting
		from startid.
		@gangid:	Gang to shift gang positions.
		@startid:	Gang position to start shift.
		@shift:		Direction to shift ID's.
	*/
	
	for ( new playerid = 0, j = GetMaxPlayers( ); playerid < j; playerid++ )
	{
	    if ( pData[ playerid ][ P_GANG_ID ] == gangid )
	    {
	        // If player gang position is greater than or equal to start position
		    if ( pData[ playerid ][ P_GANG_POS ] >= startid )
		    {
		        // Add shift onto the players current gang position.
				pData[ playerid ][ P_GANG_POS ] += shift;
				
				// If gang position is 0 then set the gang's leader
				// to this player.
				if ( !pData[ playerid ][ P_GANG_POS ] )
					gData[ gangid ][ G_LEADER ] = playerid;
			}
		}
	}
	
	return 1;
}

stock DestroyGangs( )
{
	/*	Destroys all gangs and removes all references to them.
	*/
	
	// Loop through all players and remove all references to gangs.
	
	for ( new playerid = 0, j = GetMaxPlayers( ); playerid < j; playerid++ )
	{
	    if ( IsPlayerInAnyGang( playerid ) )
			TextDrawHideForPlayer( playerid, gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK_TEXT ] );
	    
	    pData[ playerid ][ P_GANG_ID ]  	= INVALID_GANG_ID;
	    pData[ playerid ][ P_GANG_POS ]		= 0;
	    pData[ playerid ][ P_GANG_INVITE ]  = INVALID_GANG_ID;
	}
	
	// Loop through all gangs and clear all of the gangs data and statistics.
    for ( new gangid = 0; gangid < MAX_GANGS; gangid++ )
	{
        gData[ gangid ][ G_NAME ]		= '\0';
	    gData[ gangid ][ G_LEADER ]		= INVALID_PLAYER_ID;
		gData[ gangid ][ G_TOTALS ]		= 0;
		gData[ gangid ][ G_KILLS ]		= 0;
		gData[ gangid ][ G_DEATHS ]		= 0;
		gData[ gangid ][ G_BANK ]		= 0;
		gData[ gangid ][ G_ALLY ]       = INVALID_GANG_ID;

		
		if ( gData[ gangid ][ G_BANK_TEXT ] != INVALID_TEXT_DRAW )
		{
			TextDrawDestroy( gData[ gangid ][ G_BANK_TEXT ] );
			gData[ gangid ][ G_BANK_TEXT ]	= INVALID_TEXT_DRAW;
		}
		
		#if VERSION_LITE == false
		if ( gData[ gangid ][ G_ZONE_TEXT ] != TEXT_NoZoneOwner	&&
			 gData[ gangid ][ G_ZONE_TEXT ] != INVALID_TEXT_DRAW )
		{
			
			TextDrawDestroy( gData[ gangid ][ G_ZONE_TEXT ] );
			gData[ gangid ][ G_ZONE_TEXT ] = TEXT_NoZoneOwner;
		}
		#endif
		
		for ( new member = 0; member < MAX_GANG_MEMBERS; member++ )
		    gData[ gangid ][ G_MEMBERS ][ member ] = INVALID_PLAYER_ID;
	}
	
	// No gangs so gTotals is equal to 0.
	gTotals = 0;
	
	return 1;
}

stock DestroyGang( gangid )
{
	/*	Destroys the selected gang and removes all references to it. Triggers
	    the OnGangDeath callback.
		@gangid:	The gang to destroy.
	*/
	
	// Call the "OnGangDeath" callback.
	OnGangDeath( gangid, gData[ gangid ][ G_LEADER ], gData[ gangid ][ G_NAME ] );
//	CallRemoteFunction( "OnGangDeath", "ii", gangid, gData[ gangid ][ G_LEADER ], gData[ gangid ][ G_NAME ] );
	
	// Clear all of the gangs data and statistics.
	gData[ gangid ][ G_NAME ]		= '\0';
	gData[ gangid ][ G_LEADER ]		= INVALID_PLAYER_ID;
	gData[ gangid ][ G_TOTALS ]		= 0;
	gData[ gangid ][ G_KILLS ]		= 0;
	gData[ gangid ][ G_DEATHS ]		= 0;
	gData[ gangid ][ G_BANK ]		= 0;
	gData[ gangid ][ G_COLOR ]  	= 0;
	gData[ gangid ][ G_ALLY ]       = INVALID_GANG_ID;
	
	// Decrease gTotals for GetMaxGangs function.
	gTotals--;

	// Loop through all players and remove all references to the gang if the gang is referenced.
	for ( new playerid = 0, j = GetMaxPlayers( ); playerid < j; playerid++ )
	{
	    if ( pData[ playerid ][ P_FULLY_CONNECTED ] )
	    {
		    if ( pData[ playerid ][ P_GANG_ID ] == gangid )
			{
				TextDrawHideForPlayer( playerid, gData[ gangid ][ G_BANK_TEXT ] );

				pData[ playerid ][ P_GANG_POS ]	= 0;
				pData[ playerid ][ P_GANG_ID ]	= INVALID_GANG_ID;
			}

		    if ( pData[ playerid ][ P_GANG_INVITE ] == gangid )
				pData[ playerid ][ P_GANG_INVITE ] = INVALID_GANG_ID;
		}
	}
	
	for ( new member = 0; member < MAX_GANG_MEMBERS; member++ )
		gData[ gangid ][ G_MEMBERS ][ member ] = INVALID_PLAYER_ID;


	if ( gData[ gangid ][ G_BANK_TEXT ] != INVALID_TEXT_DRAW )
	{
		TextDrawDestroy( gData[ gangid ][ G_BANK_TEXT ] );
		gData[ gangid ][ G_BANK_TEXT ]	= INVALID_TEXT_DRAW;
	}

	#if VERSION_LITE == false
	if ( gData[ gangid ][ G_ZONE_TEXT ] != TEXT_NoZoneOwner	&&
		 gData[ gangid ][ G_ZONE_TEXT ] != INVALID_TEXT_DRAW )
	{
		TextDrawDestroy( gData[ gangid ][ G_ZONE_TEXT ] );
		gData[ gangid ][ G_ZONE_TEXT ] = TEXT_NoZoneOwner;
	}
	#endif

	return 1;
}

stock CreateGang( leaderid, name[ ] )
{
	/*	Creates a gang with the leaderid for the gang's leader and with the
		specified name.
		@leaderid:	The gang leaders playerid.
		@name:		The name of the new gang. String.
	*/
	
	if ( strlen( name ) >= MAX_GANG_NAME )
		return INVALID_GANG_ID;
		
	for ( new gangid = 0; gangid < MAX_GANGS; gangid++ )
	{
		if ( !gData[ gangid ][ G_TOTALS ] )
	    {
			// Set initial gang stats ...
			strcpy( gData[ gangid ][ G_NAME ], name, 0, 0 );
			
	    	gData[ gangid ][ G_LEADER ]			= leaderid;
	    	gData[ gangid ][ G_TOTALS ]			= 1;
	    	gData[ gangid ][ G_KILLS ]			= pData[ leaderid ][ P_KILLS ];
	    	gData[ gangid ][ G_DEATHS ]			= pData[ leaderid ][ P_DEATHS ];
	    	gData[ gangid ][ G_COLOR ]  		= pColors[ leaderid ];
	    	gData[ gangid ][ G_BANK ]       	= 0;
	    	gData[ gangid ][ G_BANK_TEXT ]		= CreateGangBankText( gangid );
	    	gData[ gangid ][ G_ALLY ]       	= INVALID_GANG_ID;
	    	gData[ gangid ][ G_MEMBERS ][ 0 ]	= leaderid;

			// Set player gang stats
	    	pData[ leaderid ][ P_GANG_ID ]	= gangid;
	    	pData[ leaderid ][ P_GANG_POS ]	= 0;
	    	
	    	if ( pData[ leaderid ][ P_ACTIVITY ] >= _:P_ACTIVITY_BANK && pData[ leaderid ][ P_ACTIVITY ] <= _:G_BANK_WITHDRAW  )
				TextDrawShowForPlayer( leaderid, gData[ gangid ][ G_BANK_TEXT ] );
	    	
	    	// Increase gTotals because a new gang is created.
	    	gTotals++;
	    	
			// Call the callback OnPlayerCreateGang.
			OnPlayerCreateGang( leaderid, gangid );
//			CallRemoteFunction( "OnPlayerCreateGang", "ii", leaderid, gangid );
			
			// Return the gang id since it's successful.
			return gangid;
	    }
	}
	// Return invalid gang id since it's not successful.
	return INVALID_GANG_ID;
}

stock GetMaxGangs( )
{
	/*  Returns the current amount of gangs.
	*/
	
	// Return the gTotals variable.
	return gTotals;
}

stock SetPlayerGang( playerid, gangid )
{
	/*  Set the players gang to the gangid.
	*/
	
	// Call OnPlayerJoinGang callback.
	OnPlayerJoinGang( playerid, gangid );
//	CallRemoteFunction( "OnPlayerJoinGang", "ii", playerid, gangid );
	
    // Set the player's stats to reference the gang.
	pData[ playerid ][ P_GANG_POS ]	= gData[ gangid ][ G_TOTALS ];
	pData[ playerid ][ P_GANG_ID ]	= gangid;
	
	// Update the gangs stats.
	gData[ gangid ][ G_TOTALS ]										++;
	gData[ gangid ][ G_KILLS ]										+= pData[ playerid ][ P_KILLS ];
	gData[ gangid ][ G_DEATHS ]										+= pData[ playerid ][ P_DEATHS ];
	gData[ gangid ][ G_MEMBERS ][ pData[ playerid ][ P_GANG_POS ] ]	= playerid;
	
	if ( pData[ playerid ][ P_ACTIVITY ] > _:P_ACTIVITY_BANK && pData[ playerid ][ P_ACTIVITY ] <= _:G_BANK_WITHDRAW )
	{
	    TextDrawHideForPlayer( playerid, gData[ gangid ][ G_BANK_TEXT ] );
		TextDrawShowForPlayer( playerid, gData[ gangid ][ G_BANK_TEXT ] );
	}

	return 1;
}

stock RemovePlayerFromGang( playerid, E_GANG_LEAVE_REASON:reason = GANG_LEAVE_UNKNOWN, otherid = INVALID_PLAYER_ID )
{
	/*  Remove the player from the selected gang.
	    @playerid:	Player who you'd like to remove from's gang.
	    @reason:    The reason the player left the gang.
	    @otherid:   Used when another ID is associated with the kicking.
	*/
	
	// Grab some temporary stats before closing the gang down.
	new
		gangid		= pData[ playerid ][ P_GANG_ID ],
		gangposition= pData[ playerid ][ P_GANG_POS ],
		isleader	= ( gData[ gangid ][ G_LEADER ] == playerid ),
		oldtotal    = gData[ gangid ][ G_TOTALS ];

	// Decrease the gang's statistics.
	gData[ gangid ][ G_TOTALS ]						--;
	gData[ gangid ][ G_KILLS ]						-= pData[ playerid ][ P_KILLS ];
	gData[ gangid ][ G_DEATHS ]						-= pData[ playerid ][ P_DEATHS ];
	gData[ gangid ][ G_MEMBERS ][ gangposition ]	= INVALID_PLAYER_ID;
	
	#if VERSION_LITE == false
	if ( pData[ playerid ][ P_GANG_ZONE ] != INVALID_GANG_ZONE )
	{
		zTicks[ gangid ][ pData[ playerid ][ P_GANG_ZONE ] ][ 1 ]	--;

		if ( !gZones[ pData[ playerid ][ P_GANG_ZONE ] ][ G_ZONE_WAR ] && !zTicks[ gangid ][ pData[ playerid ][ P_GANG_ZONE ] ][ 1 ] )
			zTicks[ gangid ][ pData[ playerid ][ P_GANG_ZONE ] ][ 0 ]	= 0;
	}
	#endif

	// Update the player's statistics.
	pData[ playerid ][ P_GANG_ID ]	= INVALID_GANG_ID;
	pData[ playerid ][ P_GANG_POS ]	= 0;

	if ( pData[ playerid ][ P_ACTIVITY ] > _:P_ACTIVITY_BANK && pData[ playerid ][ P_ACTIVITY ] <= _:G_BANK_WITHDRAW )
		TextDrawHideForPlayer( playerid, gData[ gangid ][ G_BANK_TEXT ] );
    
    // If no more players are in the gang then destroy it.
	if ( !gData[ gangid ][ G_TOTALS ] )
		return DestroyGang( gangid );
	
	else
	{
		// If players are still in the gang then shift the gang ID's
	    // and allow a new leader.

		for ( new member = gangposition + 1; member < oldtotal; member++ )
		{
		    if ( IsPlayerConnected( gData[ gangid ][ G_MEMBERS ][ member ] ) && pData[ gData[ gangid ][ G_MEMBERS ][ member ] ][ P_FULLY_CONNECTED ] )
		    {
				gData[ gangid ][ G_MEMBERS ][ member - 1 ]						= gData[ gangid ][ G_MEMBERS ][ member ];
				pData[ gData[ gangid ][ G_MEMBERS ][ member ] ][ P_GANG_POS ]	= ( member - 1 );
				
				if ( !pData[ gData[ gangid ][ G_MEMBERS ][ member ] ][ P_GANG_POS ] )
				    gData[ gangid ][ G_LEADER ] = gData[ gangid ][ G_MEMBERS ][ member ];
		    }
		}
		
		// Call the OnPlayerLeaveGang callback.
		OnPlayerLeaveGang( playerid, gangid, isleader, _:reason, otherid );

	//	CallRemoteFunction( "OnPlayerLeaveGang", "iiii", playerid, gangid, isleader, _:reason, otherid );
	
	    return 1;
	}
}

stock TextDrawShowForGang( gangid, Text:_txt )
{
	/*  Show text draw for a whole gang.
	    @gangid:    Gang you'd like to show text draw to.
	    @_txt:      ID of text you'd like to show the gang. Should be Text: tagged variable.
	*/
	
	for ( new memberid = 0; memberid < gData[ gangid ][ G_TOTALS ]; memberid++ )
	{
	    if ( IsPlayerConnected( gData[ gangid ][ G_MEMBERS ][ memberid ] ) )
	        TextDrawShowForPlayer( gData[ gangid ][ G_MEMBERS ][ memberid ], _txt );
	}
}

//==============================================================================
// Timer functions

public TextDrawHideForGang( gangid, Text:_txt )
{
	/*  Hide text draw for a gang. Is public so it can be timed.
	    @gangid:    Gang you'd like to hide text from.
	    @_txt:      ID of text you'd like to show the gang. Should be Text: tagged variable.
	*/
	
	for ( new memberid = 0; memberid < gData[ gangid ][ G_TOTALS ]; memberid++ )
	{
	    if ( IsPlayerConnected( gData[ gangid ][ G_MEMBERS ][ memberid ] ) )
	        TextDrawHideForPlayer( gData[ gangid ][ G_MEMBERS ][ memberid ], _txt );
	}
}
