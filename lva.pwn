//******************************************************************************
//	Gamemode: Las Venturas Arena (LVA)
//
//	20/08/2007, 8:24 p.m
//	lva.pwn, littlewhitey Scripting Team.
//******************************************************************************

#include <a_samp>

#include "lva_inc\lva_h.pwn"

// Since SetDisabledWeapons was removed in 0.3 we will
// check if the user is compiling for 0.3 and then
// create a dummy version of SetDisabledWeapons. We'll
// also forward OnPlayerPrivMsg based on this assumption:

#if !defined SetDisabledWeapons
	#define _SRV_03_ASSUMPTION_ true

	forward OnPlayerPrivmsg(playerid, recieverid, text[]);
#else
	#define _SRV_03_ASSUMPTION_ false
#endif

//******************************************************************************
//  Callbacks: SA:MP
//******************************************************************************

main( )
{
	print( "\n==============================================================================");
	print( "| " SZ_GAMEMODE_S_NAME " v" #VERSION_MAJOR "." #VERSION_MINOR "." #VERSION_BUILD );
	print( "| Credits:" );
	print( "| \tadamcs, Brandon, jacob, jax, LnX," );
	print( "| \tlittlewhitey, Mike, Peter, Sintax, Simon" );
	print( "| Options:" );
	print( "| \tMAX_RANDOM_PICKUPS = " #MAX_RANDOM_PICKUPS ", MAX_SCRIPT_ZONES = " #MAX_SCRIPT_ZONES "" );
	print( "| \tMAX_GANG_NAME = " #MAX_GANG_NAME ", MAX_GANGS = " #MAX_GANGS ", MAX_ZONE_TICKS = " #MAX_ZONE_TICKS "" );
	print( "| \tMAX_GANG_MEMBERS = " #MAX_GANG_MEMBERS ", WEP_LIMIT = " #WEP_LIMIT"" );
	print( "| \tPOCKET_MONEY = " #POCKET_MONEY ", TEAM_INTERIOR = " #TEAM_INTERIOR "" );
	print( "==============================================================================\n");
	#if VERSION_LITE == true
	print( "==============================================================================" );
	print( "| \tLite Version" );
	print( "==============================================================================" );
	#endif
}

//******************************************************************************
//  Callbacks: SA:MP
//******************************************************************************

public OnGameModeInit( )
{
	#if VERSION_LITE == false
	SetGameModeText		( "" SZ_GAMEMODE_S_NAME " v" #VERSION_MAJOR "." #VERSION_MINOR "." #VERSION_BUILD "" );
	#else
	SetGameModeText		( "Lite: " SZ_GAMEMODE_S_NAME " v" #VERSION_MAJOR "." #VERSION_MINOR "." #VERSION_BUILD "" );
	#endif
	
	// Options
	UsePlayerPedAnims	( );
	AllowInteriorWeapons( 1 );
	SetWorldTime		( sHour );
	
	#if _SRV_03_ASSUMPTION_ != true
	EnableZoneNames		( 1 );
	EnableTirePopping	( 1 );
	SetDisabledWeapons	(
							1, 4, 6, 7, 8, 9,
							14, 15, 35, 36, 37,
							38, 39, 41, 43, 44, 45
						);
	#endif
	
	// Menus
	GenerateMenus( );
	
	sMaxPlayers = GetMaxPlayers( );
    
    if ( sMaxPlayers > MAX_PLAYERS )
    {
        SendClientMessageToAll	( COLOR_RED, "RUNTIME ERROR: The script's MAX_PLAYERS is less than the servers set maximum players." );
        SendClientMessageToAll  ( COLOR_RED, "Kicking all players on connect ..." );
        printf					( "RUNTIME ERROR: The script's MAX_PLAYERS (%d) is less than the servers set maximum players (%d).\r\nKicking all players on connect ...", MAX_PLAYERS, sMaxPlayers );

		sGameModeExit = 1;
	}
	
	// Spawns
	for ( new i = 280; i < 300; i++ )
	    if ( IsValidSkin( i ) )							AddPlayerClass( i, 1958.3783, 1343.1572, 15.3746, 270.1425, 0, 0, 0, 0, 0, 0 );
	
	for ( new i = 0; i < 280; i++ )
	{
	    // 217 - Male Staff
	    // 211 - Female Staff
	    
	    if ( IsValidSkin( i ) && i != 217 && i != 211 )	AddPlayerClass( i,1958.3783, 1343.1572, 15.3746, 270.1425, 0, 0, 0, 0, 0, 0 );
	}

	AddStaticVehicle(538,1466.7051,2634.2603,10.5424,269.5424,1,1);	// Brown Streak!
	
	loadV_Admin	( );
	
	new
		vSet = random( 2 );



	switch ( vSet )
	{
	    case 0:
	    {
	        print ( "Simon's Vehicle set loaded ..." );
			SendClientMessageToAdmins( COLOR_RED, "Simon's Vehicle set loaded ..." );

			loadV_Simon( );
		}
		
		case 1:
		{
			print ( "adamcs's Vehicle set loaded ..." );
			SendClientMessageToAdmins( COLOR_RED, "adamcs's Vehicle set loaded ..." );
			
			loadV_adamcs( );
		}

	}

    // Pickups
	AddStaticPickup( 371, 15, 1710.3359, 1614.3585, 10.1191 );	// Parachute
	AddStaticPickup( 371, 15, 1964.4523, 1917.0341, 130.9375 );	// Parachute
	AddStaticPickup( 371, 15, 2055.7258, 2395.8589, 150.4766 );	// Parachute
	AddStaticPickup( 371, 15, 2265.0120, 1672.3837, 94.9219 );	// Parachute
	AddStaticPickup( 371, 15, 2265.9739, 1623.4060, 94.9219 );	// Parachute
	AddStaticPickup( 366, 15, 381.978, -56.9461, 1001.49 );		// Fire Extinguisher
	AddStaticPickup( 366, 15, 379.485, -116.57, 1001.33 );		// Fire Extinguisher
	AddStaticPickup( 366, 15, 381.444, -188.315, 1000.56 );		// Fire Extinguisher
	
	sStrip[ 0 ]	= CreatePickup( 1239, DEFAULT_PICKUP_TYPE, 1214.0721, -27.1754, 1000.953 );	// Strip Info Icon
	sStrip[ 1 ] = CreatePickup( 1239, DEFAULT_PICKUP_TYPE, 1220.6227, -6.2027, 1001.3281 );	// Strip Info Icon
	sBeer		= CreatePickup( 1484, DEFAULT_PICKUP_TYPE, 508.2607, -70.2400, 998.7578 );	// Beer
	sPirate		= CreatePickup( 1239, DEFAULT_PICKUP_TYPE, 1999.5806, 1540.4535, 13.5859 );	// Pirate Info Icon
	
	#if NEW_PIRATE_MODE == true
	sPirateBriefcase	= CreatePickup( 1210, DEFAULT_PICKUP_TYPE, 2002.7188,1548.1165,13.5859 );		// Pirate Briefcase
	sPirateBriefcaseObj = CreateObject( 1318,2002.7188, 1548.1165, 0.0, 0.0, 0.0, 0.0 );				// Pirate Arrow
	#endif
	
	// Pirate Ship
	CreateObject( 8493,1957.396,1510.484,24.975,0.0,0.0,-159.141 );	// Pirateship
	CreateObject( 9159,1957.351,1510.507,24.959,0.0,0.0,200.781 );	// Pirateship_Sales&Fence
	CreateObject( 3886,1991.424,1540.095,11.605,0.0,0.0,293.841 );	// Boardwalk1
	CreateObject( 3886,1984.211,1536.949,11.580,0.0,0.0,112.577 );	// Boardwalk2
	CreateObject( 3886,1962.288,1527.296,11.705,0.0,0.0,113.463 );	// Boardwalk3
	CreateObject( 3886,1969.436,1530.477,11.680,0.0,0.0,293.841 );	// Boardwalk4

	#if RANDOM_PICKUPS == true
	for ( new i = 0; i < MAX_RANDOM_PICKUPS; i++ )
		GenerateRandomPickup( i );
	#endif

	for ( new tmpSave = 0; tmpSave < MAX_SAVES; tmpSave++ )
	{

		for ( new i = 0; i < MAX_WEAPON_SLOT; i++ )
		{
		    tData[ tmpSave ][ T_SPAWN_WEAPONS ][ i ]	= 0;
		    tData[ tmpSave ][ T_SPAWN_AMMO ][ i ]		= 0;
		    tData[ tmpSave ][ T_TEMP_WEAPONS ][ i ]		= 0;
		    tData[ tmpSave ][ T_TEMP_AMMO ][ i ]        = 0;
		}

		tData[ tmpSave ][ T_NAME ]		= '\0';
	    tData[ tmpSave ][ T_MONEY ]		= tData[ tmpSave ][ T_MUTE ] = tData[ tmpSave ][ T_BANK ] = tData[ tmpSave ][ T_BOUNTY ] = 0;
		tData[ tmpSave ][ T_SKIN ]		= -1;
		tData[ tmpSave ][ T_ARMOR ]		= 0.0;
		tData[ tmpSave ][ T_HEALTH ]	= 100.0;
		tData[ tmpSave ][ T_TICKS ]     = 4;
	}

	for ( new playerid = 0; playerid < MAX_PLAYERS; playerid++ )
	{
	    pData[ playerid ][ P_LIST_PREVIOUS_ID ]		= INVALID_PLAYER_ID;
	    pData[ playerid ][ P_LIST_NEXT_ID ]         = INVALID_PLAYER_ID;
		pData[ playerid ][ P_RETURNING_SPAWN ]		= 0;
		pData[ playerid ][ P_MONEY ]				= 0;
		pData[ playerid ][ P_HEALTH ]				= 100.0;
		pData[ playerid ][ P_ARMOR ]				= 0.0;
		pData[ playerid ][ P_KILLS ]        		= 0;
		pData[ playerid ][ P_DEATHS ]       		= 0;
		pData[ playerid ][ P_BANK ]         		= 0;
		pData[ playerid ][ P_BOUNTY ]       		= 0;
		pData[ playerid ][ P_SHIP_CASH ]			= SHIP_CASH_DEFAULT;
		pData[ playerid ][ P_SKIN ]         		= -1;
		pData[ playerid ][ P_GANG_ID ]      		= INVALID_GANG_ID;
		pData[ playerid ][ P_GANG_POS ]     		= 0;
		pData[ playerid ][ P_GANG_INVITE ]			= INVALID_GANG_ID;
		pData[ playerid ][ P_MUTE ]         		= 0;
		pData[ playerid ][ P_GANG_ZONE ]    		= INVALID_GANG_ZONE;
		pData[ playerid ][ P_IN_ZONE ]      		= 0;
		pData[ playerid ][ P_LAST_PM_ID ]   		= INVALID_PLAYER_ID;
		pData[ playerid ][ P_NO_WEAPON_AREA ]		= 0;
		pData[ playerid ][ P_CHECKPOINT_AREA ]		= 255;
		pData[ playerid ][ P_IN_CHECKPOINT ]		= 0;
		pData[ playerid ][ P_ARMOR ]            	= 0.0;
		pData[ playerid ][ P_HEALTH ]           	= 100.0;
		pData[ playerid ][ P_BANK_TEXT ]            = INVALID_TEXT_DRAW;
		
		for ( new i = 0; i < MAX_WEAPON_SLOT; i++ )
		{
			pData[ playerid ][ P_TEMP_WEAPONS ][ i ]    = 0;
			pData[ playerid ][ P_TEMP_AMMO ][ i ]		= 0;
			pData[ playerid ][ P_SPAWN_WEAPONS ][ i ]	= 0;
			pData[ playerid ][ P_SPAWN_AMMO ][ i ]      = 0;
		}

		pData[ playerid ][ P_TEMP_WEAPONS ][ 2 ]	= START_WEAPON;
		pData[ playerid ][ P_TEMP_AMMO ][ 2 ]		= START_AMMO;
		
		if( IsPlayerConnected( playerid ) )
			AC_ResetPlayerMoney( playerid );
	}
	
	for ( new i = 0, j = 0; i < sizeof( sWeapons ); i++ )
	{
	    if ( sWeapons[ i ][ WEAPON_SPAWN_WEAPON ] )
			sWeapon[ j++ ] = i;
	}
	
	#if VERSION_LITE == false
	TEXT_NoZoneOwner = TextDrawCreate( 615.0, 400.0, "~y~Unoccupied~s~ Territory" );
	
	TextDrawFont			( TEXT_NoZoneOwner, 1 );
 	TextDrawSetOutline		( TEXT_NoZoneOwner, 1 );
  	TextDrawSetProportional	( TEXT_NoZoneOwner, 1 );
   	TextDrawAlignment		( TEXT_NoZoneOwner, 3 );
   	#endif
	
	new
	   	sString[ 128 ];
   	
   	format( sString, sizeof( sString ), "~y~%s", sDays[ sDay ] );
   	
   	TEXT_Day = TextDrawCreate( 623.25, 8.75, sString );
   	TextDrawFont( TEXT_Day, 3 );
	TextDrawSetOutline( TEXT_Day, 2 );
  	TextDrawSetProportional( TEXT_Day, 1 );
   	TextDrawAlignment( TEXT_Day, 3 );
   	TextDrawLetterSize( TEXT_Day, 0.6667, 1.6667 );

	GetServerVarAsString( "hostname", sString, sizeof( sString ) );
   	format( sString, sizeof( sString ), "~r~%s ~w~: ~y~" SZ_GAMEMODE_S_NAME " v" #VERSION_MAJOR "." #VERSION_MINOR "." #VERSION_BUILD "", sString );
   	
   	TEXT_SpawnScreenInfo = TextDrawCreate( 615.0, 425.0, sString );
    TextDrawFont( TEXT_SpawnScreenInfo, 1 );
 	TextDrawSetOutline( TEXT_SpawnScreenInfo, 1 );
  	TextDrawSetProportional( TEXT_SpawnScreenInfo, 1 );
   	TextDrawAlignment( TEXT_SpawnScreenInfo, 3 );
   	
   	#if VERSION_LITE == false
	TEXT_WarProvokedAttack = TextDrawCreate( 615.0, 375.0, "Your gang has provoked a ~r~Gang War." );
 	TextDrawFont( TEXT_WarProvokedAttack, 1 );
 	TextDrawSetOutline( TEXT_WarProvokedAttack, 1 );
  	TextDrawSetProportional( TEXT_WarProvokedAttack, 1 );
	TextDrawAlignment( TEXT_WarProvokedAttack, 3 );

	TEXT_WarProvokedDefense = TextDrawCreate( 615.0, 375.0, "A gang has provoked a ~r~Gang War~w~ on your gang's turf." );
 	TextDrawFont( TEXT_WarProvokedDefense, 1 );
 	TextDrawSetOutline( TEXT_WarProvokedDefense, 1 );
  	TextDrawSetProportional( TEXT_WarProvokedDefense, 1 );
	TextDrawAlignment( TEXT_WarProvokedDefense, 3 );

	TEXT_TurfIsYours = TextDrawCreate( 615.0, 375.0, "Your gang has taken a turf." );
 	TextDrawFont( TEXT_TurfIsYours, 1 );
 	TextDrawSetOutline( TEXT_TurfIsYours, 1 );
  	TextDrawSetProportional( TEXT_TurfIsYours, 1 );
	TextDrawAlignment( TEXT_TurfIsYours, 3 );

	TEXT_TurfLost = TextDrawCreate( 615.0, 375.0, "Your gang has lost a turf." );
 	TextDrawFont( TEXT_TurfLost, 1 );
 	TextDrawSetOutline( TEXT_TurfLost, 1 );
  	TextDrawSetProportional( TEXT_TurfLost, 1 );
	TextDrawAlignment( TEXT_TurfLost, 3 );

	TEXT_TurfDefended = TextDrawCreate( 615.0, 375.0, "Your gang has sucessfully defended your turf." );
 	TextDrawFont( TEXT_TurfDefended, 1 );
 	TextDrawSetOutline( TEXT_TurfDefended, 1 );
  	TextDrawSetProportional( TEXT_TurfDefended, 1 );
	TextDrawAlignment( TEXT_TurfDefended, 3 );
	#endif
	
	for ( new gangid = 0; gangid < MAX_GANGS; gangid++ )
	{
	    #if VERSION_LITE == false
		gData[ gangid ][ G_ZONE_TEXT ]	= INVALID_TEXT_DRAW;
		#endif
		
	    gData[ gangid ][ G_BANK_TEXT ] 	= INVALID_TEXT_DRAW;
	}

	#if VERSION_LITE == false
	for ( new zoneid = 0; zoneid < MAX_SCRIPT_ZONES; zoneid++ )
	{
		gZones[ zoneid ][ G_ZONE_TEXT ] = TEXT_NoZoneOwner;
		gZones[ zoneid ][ G_ZONE_ID ]	= GangZoneCreate( gZones[ zoneid ][ G_ZONE_MINX ], gZones[ zoneid ][ G_ZONE_MINY ], gZones[ zoneid ][ G_ZONE_MAXX ], gZones[ zoneid ][ G_ZONE_MAXY ] );
	}
	#endif

	DestroyGangs( );
	
    // Timers
	sTimerIDs[ 0 ] = SetTimer( "ScriptSync",	999,	1 );
	sTimerIDs[ 1 ] = SetTimer( "PropertySync",	5007,   1 );
	sTimerIDs[ 2 ] = SetTimer( "WeatherSync",	22003,	1 );
	sTimerIDs[ 3 ] = SetTimer( "SaveSync",		75015,	1 );
	sTimerIDs[ 4 ] = SetTimer( "BanSync",       300321, 1 );
	
#if TEXT_DRAWS_INSTEAD_OF_CLIENT_MESSAGES == true
	//LnX Make initialise the textdraws
	lredrawall();
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
	    lclear(i);
	}
#endif
	return 1;
}

public OnGameModeExit( )
{
	sGameModeExit = 1;
    
    for ( new iTmr = 0; iTmr < sizeof( sTimerIDs ); iTmr++ )
    {
        if ( sTimerIDs[ iTmr ] != -1 )
            KillTimer( sTimerIDs[ iTmr ] );
    }
    
	for ( new SaveID = 0; SaveID < MAX_SAVES; SaveID++ )
	{
		tData[ SaveID ][ T_BOUNTY ]	= tData[ SaveID ][ T_MONEY ] = tData[ SaveID ][ T_NAME ] = 0;
		tData[ SaveID ][ T_ARMOR ]	= 0.0;
		tData[ SaveID ][ T_HEALTH ] = 100.0;

		for ( new i = 0; i < MAX_WEAPON_SLOT; i++ )
		{
		    tData[ SaveID ][ T_SPAWN_WEAPONS ][ i ]	= 0;
		    tData[ SaveID ][ T_SPAWN_AMMO ][ i ]	= 0;
		    tData[ SaveID ][ T_TEMP_WEAPONS ][ i ]	= 0;
		    tData[ SaveID ][ T_TEMP_AMMO ][ i ]		= 0;
		}
	}

	for ( new playerid = 0; playerid < MAX_PLAYERS; playerid++ )
		if( IsPlayerConnected( playerid ) )
			AC_ResetPlayerMoney( playerid );

	return 1;
}

public OnPlayerConnect( playerid )
{
	// If the gamemode is exiting we won't accept anymore new connections.
	if ( sGameModeExit )
		return Kick( playerid );

	// This will prevent the code from being executed until
	// the player really connects (when they view OnPlayerRequestClass).
	if ( !pData[ playerid ][ P_FULLY_CONNECTED ] )
		return 1;
		
	new
	    szLastIP	[ 16 ],
	    szCurrentIP	[ 16 ],
		szPlayerName[ MAX_PLAYER_NAME ];
		
	GetPlayerName	( playerid, szPlayerName, MAX_PLAYER_NAME );
	GetPlayerIp		( playerid, szCurrentIP, sizeof( szCurrentIP ) );

	if ( isdigit( szPlayerName[ 0 ] ) )
	{
		SendClientMessage	( playerid, COLOR_GREY, "Invalid nickname. Your nickname must not start with a number." );
		Kick				( playerid );
        return 1;
	}
	
	g_iTotalPlayerCnt	++;
	g_iCurrentPlayerCnt	++;

	#if LOOP_TYPE != 0
	// Code to make loopPlayers work correctly, this will
	// update the variables so you don't have to loop through
	// all playerid's to check if they're connected.
	
	pData[ playerid ][ P_LIST_PREVIOUS_ID ]	= g_iLastJoinedPlayerID;
	pData[ playerid ][ P_LIST_NEXT_ID ]		= INVALID_PLAYER_ID;
	
	if ( g_iLastJoinedPlayerID != INVALID_PLAYER_ID )
		pData[ g_iLastJoinedPlayerID ][ P_LIST_NEXT_ID ] = playerid;

	g_iLastJoinedPlayerID = playerid;
	// loopPlayers code end
	#endif

	// Send welcome message to the newly connected player.
	SendClientMessage	( playerid, COLOR_RED,		gWelcomeMSG1 );
	SendClientMessage	( playerid, COLOR_YELLOW,	gWelcomeMSG2 );

	// Reset the players money so that they don't join with a large
	// amount (might bug) and also so that their AC money level starts
	// off clean.
	AC_ResetPlayerMoney	( playerid );

	pData[ playerid ][ P_ACCOUNT_BAN ]			= 0;
	pData[ playerid ][ P_REGISTERED ]			= 0;
	pData[ playerid ][ P_LOGGED_IN ]			= 1;
	pData[ playerid ][ P_LEVEL ]                = 0;
	pData[ playerid ][ P_GANG_ID ]      		= INVALID_GANG_ID;
	pData[ playerid ][ P_GANG_POS ]     		= 0;
	pData[ playerid ][ P_GANG_INVITE ]			= INVALID_GANG_ID;
	pData[ playerid ][ P_MUTE ]         		= 0;
	pData[ playerid ][ P_GANG_ZONE ]    		= INVALID_GANG_ZONE;
	pData[ playerid ][ P_IN_ZONE ]      		= 0;
	pData[ playerid ][ P_LAST_PM_ID ]   		= INVALID_PLAYER_ID;
	pData[ playerid ][ P_NO_WEAPON_AREA ]		= 0;
	pData[ playerid ][ P_CHECKPOINT_AREA ]		= 255;
	pData[ playerid ][ P_IN_CHECKPOINT ]		= 0;
	pData[ playerid ][ P_ACTIVITY ]				= _:P_ACTIVITY_NONE;
	pData[ playerid ][ P_ONLINE_TICKS ]			= 0;
	pData[ playerid ][ P_INVINCIBLE_TICKS ]		= 0;
	
	new
		DB:Database = db_open( SZ_SQLITE_DB );
	
	if ( Database )
	{
		for ( new SaveID = 0; SaveID < MAX_SAVES; SaveID++ )
		{
			if ( IsStringSame( tData[ SaveID ][ T_NAME ], szPlayerName, MAX_PLAYER_NAME ) )
//			if ( !strcmp( szPlayerName, tData[ SaveID ][ T_NAME ], true ) )
			{
				pData[ playerid ][ P_RETURNING_SPAWN ]	= 1;
				pData[ playerid ][ P_MONEY ]	= tData[ SaveID ][ T_MONEY ];
				pData[ playerid ][ P_BANK ]		= tData[ SaveID ][ T_BANK ];
				pData[ playerid ][ P_BOUNTY ]	= tData[ SaveID ][ T_BOUNTY ];
				pData[ playerid ][ P_ARMOR ]    = tData[ SaveID ][ T_ARMOR ];
				pData[ playerid ][ P_HEALTH ]   = tData[ SaveID ][ T_HEALTH ];
				pData[ playerid ][ P_MUTE ]     = tData[ SaveID ][ T_MUTE ];
				pData[ playerid ][ P_KILLS ]    = tData[ SaveID ][ T_KILLS ];
				pData[ playerid ][ P_DEATHS ]	= tData[ SaveID ][ T_DEATHS ];

				tData[ SaveID ][ T_MUTE ]	= tData[ SaveID ][ T_BOUNTY ]	= tData[ SaveID ][ T_MONEY ] = tData[ SaveID ][ T_NAME ] = 0;
			    tData[ SaveID ][ T_ARMOR ]	= 0.0;
				tData[ SaveID ][ T_HEALTH ] = 100.0;
				tData[ SaveID ][ T_TICKS ]  = 0;
					
				for ( new i = 0; i < MAX_WEAPON_SLOT; i++ )
				{
					pData[ playerid ][ P_TEMP_WEAPONS ][ i ]    = tData[ SaveID ][ T_TEMP_WEAPONS ][ i ];
					pData[ playerid ][ P_TEMP_AMMO ][ i ]		= tData[ SaveID ][ T_TEMP_AMMO ][ i ];
					pData[ playerid ][ P_SPAWN_WEAPONS ][ i ]	= tData[ SaveID ][ T_SPAWN_WEAPONS ][ i ];
					pData[ playerid ][ P_SPAWN_AMMO ][ i ]      = tData[ SaveID ][ T_SPAWN_AMMO ][ i ];
						
					tData[ SaveID ][ T_TEMP_WEAPONS ][ i ]	= 0;
					tData[ SaveID ][ T_TEMP_AMMO ][ i ]		= 0;
					tData[ SaveID ][ T_SPAWN_WEAPONS ][ i ]	= 0;
					tData[ SaveID ][ T_SPAWN_AMMO ][ i ]	= 0;
				}
				
				if ( tData[ SaveID ][ T_SKIN ] != -1 )
				{
					pData[ playerid ][ P_SKIN ] = tData[ SaveID ][ T_SKIN ];
					tData[ playerid ][ T_SKIN ] = -1;
				}
				
				SendClientMessage( playerid, COLOR_GREEN, "Your money and weapons have been restored." );
				
				break;
			}
		}
		
		if ( pData[ playerid ][ P_TEMP_AMMO ][ 2 ] < 300 )
			pData[ playerid ][ P_TEMP_AMMO ][ 2 ]	= START_AMMO;
			
		if ( !pData[ playerid ][ P_TEMP_WEAPONS ][ 2 ] )
			pData[ playerid ][ P_TEMP_WEAPONS ][ 2 ]= START_WEAPON;
		
		if ( !pData[ playerid ][ P_RETURNING_SPAWN ] )
		{
			pData[ playerid ][ P_SKIN ]         		= -1;
			pData[ playerid ][ P_MONEY ]				= POCKET_MONEY;
			pData[ playerid ][ P_BANK ]         		= 0;
			pData[ playerid ][ P_BOUNTY ]       		= 0;
			pData[ playerid ][ P_ARMOR ]				= 0.0;
			pData[ playerid ][ P_HEALTH ]				= 100.0;
			pData[ playerid ][ P_KILLS ]        		= 0;
			pData[ playerid ][ P_DEATHS ]       		= 0;

			for ( new i = 0; i < MAX_WEAPON_SLOT; i++ )
			{
				pData[ playerid ][ P_TEMP_WEAPONS ][ i ]	= 0;
				pData[ playerid ][ P_TEMP_AMMO ][ i ]		= 0;
				pData[ playerid ][ P_SPAWN_WEAPONS ][ i ]	= 0;
				pData[ playerid ][ P_SPAWN_AMMO ][ i ]		= 0;
			}

			pData[ playerid ][ P_TEMP_WEAPONS ][ 2 ]    = START_WEAPON;
			pData[ playerid ][ P_TEMP_AMMO ][ 2 ]		= START_AMMO;
		}
		
		if ( IsUserRegisteredEx( Database, szPlayerName, szLastIP ) )
		{
			pData[ playerid ][ P_REGISTERED ]	= 1;
			pData[ playerid ][ P_LOGGED_IN ]	= 0;
			pData[ playerid ][ P_ACCOUNT_BAN ]	= IsUserBanned( Database, szPlayerName );
			
			if ( pData[ playerid ][ P_ACCOUNT_BAN ] )
				KickPlayer( Database, playerid, 1000, "Attempted login on banned account." );

			else if ( !strcmp( szLastIP, szCurrentIP ) )
			{
				new
					szString[ MAX_CLIENT_MSG ];
			    
				LoginUser( Database, playerid, szPlayerName, szLastIP, 1 );
				
				format( szString, sizeof( szString ), "You have automatically been logged into your account (Level: %d, UserID: %d).", pData[ playerid ][ P_LEVEL ], pData[ playerid ][ P_USERID ] );
				SendClientMessage( playerid, COLOR_GREEN, szString );
				
				format( szString, sizeof( szString ), "Player %s (ID:%d) has logged in (Level: %d, UserID: %d) with autologin.", szPlayerName, playerid, pData[ playerid ][ P_LEVEL ], pData[ playerid ][ P_USERID ] );
				SendClientMessageToAdmins( COLOR_ORANGE, szString );

				format	( szString, sizeof( szString ), "[login] %s %d %d %d", szPlayerName, playerid, pData[ playerid ][ P_USERID ], pData[ playerid ][ P_LEVEL ] );
				add_log	( szString );
			}

			else
			{
				SendClientMessage( playerid, COLOR_ORANGE,	"This username is registered, please login using the /login command." );
				SendClientMessage( playerid, COLOR_RED,		"If you are not the owner of this account, please quit the game and rejoin with another nickname." );
			}
		}
		
		else
		{
		    pData[ playerid ][ P_REGISTERED ]	= 0;
			pData[ playerid ][ P_LOGGED_IN ]	= 1;
			
			SendClientMessage( playerid, COLOR_GREEN,	"You can register your username using the /register command." );
			
		}
		db_close( Database );

	}
	else
		print( "[ERROR] No database!" );

	loopPlayers( i )
	{
		if ( pData[ i ][ P_NO_WEAPON_AREA ] )
			SetPlayerTeam( i, TEAM_INTERIOR );
	}
		
	SetPlayerColor		( playerid, setAlpha( pColors[ playerid ], 0x40 ) );
	TogglePlayerClock	( playerid, 1 );
	SetPlayerTime		( playerid, sHour, sMinute );

	SendDeathMessage	( INVALID_PLAYER_ID, playerid, 200 );

	return 1;
}

public OnPlayerDisconnect( playerid, reason )
{
	new
		pName[ MAX_PLAYER_NAME ];

	GetPlayerName( playerid, pName, MAX_PLAYER_NAME );
	
	if ( pData[ playerid ][ P_REGISTERED ] && pData[ playerid ][ P_LOGGED_IN ] )
	{
		new DB:Database = db_open( SZ_SQLITE_DB );

		if ( Database )
		{
		    SaveUser( Database, playerid, pName );
		    db_close( Database );
		}
		else
		    print ( "[ERROR] NO DATABASE!" );
	}
	
	if ( sGameModeExit )
		return 1;

	g_iCurrentPlayerCnt--;

	#if LOOP_TYPE != 0
	// loopPlayers macro code start
	if ( g_iLastJoinedPlayerID == playerid )
	    g_iLastJoinedPlayerID = pData[ playerid ][ P_LIST_PREVIOUS_ID ];

	else
	{
		if ( pData[ playerid ][ P_LIST_NEXT_ID ] != INVALID_PLAYER_ID )
			pData[ pData[ playerid ][ P_LIST_NEXT_ID ] ][ P_LIST_PREVIOUS_ID ]	= pData[ playerid ][ P_LIST_PREVIOUS_ID ];

		if ( pData[ playerid ][ P_LIST_PREVIOUS_ID ] != INVALID_PLAYER_ID )
			pData[ pData[ playerid ][ P_LIST_PREVIOUS_ID ] ][ P_LIST_NEXT_ID ]	= pData[ playerid ][ P_LIST_NEXT_ID ];
	}
	// loopPlayers macro code end
	#endif
	
	pData[ playerid ][ P_FULLY_CONNECTED ]	= 0;
	pData[ playerid ][ P_DROP_WARNED ]      = 0;
	pData[ playerid ][ P_SHIP_CASH ]        = SHIP_CASH_DEFAULT;
	pData[ playerid ][ P_RETURNING_SPAWN ]	= 0;
	pData[ playerid ][ P_LEVEL ]            = _:P_LEVEL_NONE;
	
	SendDeathMessage( INVALID_PLAYER_ID, playerid, 201 );
	
	if ( pData[ playerid ][ P_BANK_TEXT ] != INVALID_TEXT_DRAW )
	{
		TextDrawDestroy( pData[ playerid ][ P_BANK_TEXT ] );
		pData[ playerid ][ P_BANK_TEXT ] = INVALID_TEXT_DRAW;
	}
	
	pData[ playerid ][ P_BOUNTY ] = 0;
	
	if ( sHighBountyPlayer == playerid )
	{
		sHighBountyPlayer = 0;

		loopPlayers( i )
		{
			if ( pData[ i ][ P_BOUNTY ] > pData[ sHighBountyPlayer ][ P_BOUNTY ] && pData[ i ][ P_BOUNTY ] > 0 )
		        sHighBountyPlayer	= i;
		}
		
		if ( pData[ sHighBountyPlayer ][ P_BOUNTY ] < 1 )
			sHighBountyPlayer	= INVALID_PLAYER_ID;
			
		if ( sHighBountyPlayer != INVALID_PLAYER_ID && sHighBountyPlayer != playerid )
		{
			new
				szString[ 128 ];

			GetPlayerName( sHighBountyPlayer, szString, MAX_PLAYER_NAME );

			format( szString, sizeof( szString ), "* %s (%d) has the highest bounty ($%d). Look for the ORANGE blip.", szString, sHighBountyPlayer, pData[ sHighBountyPlayer ][ P_BOUNTY ] );
			SendClientMessageToAll( COLOR_ORANGE, szString );

			SetPlayerColor( sHighBountyPlayer, COLOR_ORANGE );
		}
	}
	
	if ( sRhinoOwner == playerid )
		sRhinoOwner = INVALID_PLAYER_ID;

	#if NEW_PIRATE_MODE == true
	if ( sPirateOwner == playerid )
	{
		DestroyObject		( sPirateBriefcaseObj );
		sPirateBriefcaseObj = CreateObject( 1318,2002.7188, 1548.1165, 0.0, 0.0, 0.0, 0.0 );
		
		sPirateOwner	= INVALID_PLAYER_ID;
		sPirateBriefcase= CreatePickup( 1210,DEFAULT_PICKUP_TYPE, 2002.7188, 1548.1165, 13.5859 );
	}
	#endif

	for ( new property = 0, j = sizeof ( gPropertyData ); property < j; property++ )
	{
	    if ( gPropertyData[ property ][ PROPERTY_OWNER ] == playerid )
		{
			AC_GivePlayerMoney( playerid, gPropertyData[ property ][ PROPERTY_PRICE ] );

			gPropertyData[ property ][ PROPERTY_OWNER ]			= INVALID_PLAYER_ID;
			gPropertyData[ property ][ PROPERTY_CAN_BE_BOUGHT ]	= 1;
		}
	}
	
	if ( pData[ playerid ][ P_GANG_ZONE ] != INVALID_GANG_ZONE )
	{
	    pData[ playerid ][ P_GANG_ZONE ]	= INVALID_GANG_ZONE;
	    pData[ playerid ][ P_IN_ZONE ]		= 0;
	}

	tData[ sSave ][ T_NAME ]    = pName;
	tData[ sSave ][ T_KILLS ]   = pData[ playerid ][ P_KILLS ];
	tData[ sSave ][ T_DEATHS ]  = pData[ playerid ][ P_DEATHS ];
    tData[ sSave ][ T_MUTE ]    = pData[ playerid ][ P_MUTE ];
	tData[ sSave ][ T_BANK ]	= pData[ playerid ][ P_BANK ];
	tData[ sSave ][ T_BOUNTY ]	= pData[ playerid ][ P_BOUNTY ];
	tData[ sSave ][ T_SKIN ]	= GetPlayerSkin( playerid );
	tData[ sSave ][ T_TICKS ]	= 4;	// Seconds and is 5 minutes until data is cleared.

    pData[ playerid ][ P_BOUNTY ] = pData[ playerid ][ P_BANK ] = pData[ playerid ][ P_MUTE ] = 0;

	if ( GetPlayerState( playerid ) )
	{
		GetPlayerArmour( playerid, tData[ sSave ][ T_ARMOR ] );
		
		if ( pData[ playerid ][ P_INVINCIBLE_TICKS ] )
			tData[ sSave ][ T_HEALTH ] = pData[ playerid ][ P_HEALTH ];
			
	    else
			GetPlayerHealth( playerid, tData[ sSave ][ T_HEALTH ] );
			
		tData[ sSave ][ T_MONEY ]	= GetPlayerMoney( playerid );
		
		#if		MODE_PROTECTED_WEAPONS == 0
		
		if ( pData[ playerid ][ P_NO_WEAPON_AREA ] )
		{
			for ( new i = 0; i < MAX_WEAPON_SLOT; i++ )
			{
				tData[ sSave ][ T_SPAWN_WEAPONS ][ i ]	= pData[ playerid ][ P_SPAWN_WEAPONS ][ i ];
				tData[ sSave ][ T_SPAWN_AMMO ][ i ]		= pData[ playerid ][ P_SPAWN_AMMO ][ i ];
				tData[ sSave ][ T_TEMP_WEAPONS ][ i ]   = pData[ playerid ][ P_TEMP_WEAPONS ][ i ];
				tData[ sSave ][ T_TEMP_AMMO ][ i ]      = pData[ playerid ][ P_TEMP_AMMO ][ i ];

				pData[ playerid ][ P_TEMP_WEAPONS ][ i ]	= pData[ playerid ][ P_TEMP_AMMO ][ i ]		= 0;
				pData[ playerid ][ P_SPAWN_WEAPONS ][ i ]	= pData[ playerid ][ P_SPAWN_AMMO ][ i ]	= 0;
			}
		}
		else
		{
		
		#endif
		
			for ( new i = 0; i < MAX_WEAPON_SLOT; i++ )
			{
			    GetPlayerWeaponData(playerid, i, tData[sSave][T_TEMP_WEAPONS][i], tData[sSave][T_TEMP_AMMO][i]);

				tData[ sSave ][ T_SPAWN_WEAPONS ][ i ]	= pData[ playerid ][ P_SPAWN_WEAPONS ][ i ];
				tData[ sSave ][ T_SPAWN_AMMO ][ i ]		= pData[ playerid ][ P_SPAWN_AMMO ][ i ];

				pData[ playerid ][ P_TEMP_WEAPONS ][ i ]	= pData[ playerid ][ P_TEMP_AMMO ][ i ]	= 0;
				pData[ playerid ][ P_SPAWN_WEAPONS ][ i ]	= pData[ playerid ][ P_SPAWN_AMMO ][ i ]= 0;
			}
			
        #if		MODE_PROTECTED_WEAPONS == 0
        
		}
		
		#endif
	}
	else
	{
		tData[ sSave ][ T_ARMOR ]	= pData[ playerid ][ P_ARMOR ];
		tData[ sSave ][ T_HEALTH ]  = pData[ playerid ][ P_HEALTH ];
		tData[ sSave ][ T_MONEY ]	= pData[ playerid ][ P_MONEY ];
		
		for ( new i = 0; i < MAX_WEAPON_SLOT; i++ )
		{
			tData[ sSave ][ T_TEMP_WEAPONS ][ i ]	= pData[ playerid ][ P_TEMP_WEAPONS ][ i ];
			tData[ sSave ][ T_TEMP_AMMO ][ i ]		= pData[ playerid ][ P_TEMP_AMMO ][ i ];
			tData[ sSave ][ T_SPAWN_WEAPONS ][ i ]	= pData[ playerid ][ P_SPAWN_WEAPONS ][ i ];
			tData[ sSave ][ T_SPAWN_AMMO ][ i ]		= pData[ playerid ][ P_SPAWN_AMMO ][ i ];
			
			pData[ playerid ][ P_TEMP_WEAPONS ]			= pData[ playerid ][ P_TEMP_AMMO ][ i ]		= 0;
			pData[ playerid ][ P_SPAWN_WEAPONS ][ i ]	= pData[ playerid ][ P_SPAWN_AMMO ][ i ]	= 0;
		}
	}

	if ( IsPlayerInAnyGang( playerid ) )
		RemovePlayerFromGang( playerid, GANG_LEAVE_QUIT );

	sSave++;
	
	if ( sSave >= MAX_SAVES ) sSave = 0;
	
	pData[ playerid ][ P_SEEN_CLASS_SELECT ]	= 0;
	pData[ playerid ][ P_ADMIN_SPAWN ]			= 0;

#if TEXT_DRAWS_INSTEAD_OF_CLIENT_MESSAGES == true
	//LnX
	lredrawall();
	lclear(playerid);
#endif

	pData[ playerid ][ P_REGISTERED ]		= 0;
	pData[ playerid ][ P_LOGGED_IN ]		= 0;
	pData[ playerid ][ P_LOGIN_ATTEMPTS ]	= 0;
	
	return 1;
}

public OnPlayerSpawn( playerid )
{
	// Callback: LVA - OnPlayerSpawn
	
	// If the player is a returning spawn, we'll welcome them
	// back to the server with GameText.
//	if ( pData[ playerid ][ P_RETURNING_SPAWN ] )
//		GameTextForPlayer( playerid, "~y~Welcome Back", 7500, 0 );

	if ( pData[ playerid ][ P_SEND_TO_CLASS_SELECT ] )
	{
		ForceClassSelection	( playerid );
	    SetPlayerHealth		( playerid, 0.0 );
	    
	    SetPlayerInterior	( playerid, 12 );
		SetPlayerCameraPos	( playerid, 2322.507812, -1146.331054, 1050.710083 );
		SetPlayerCameraLookAt( playerid, 2324.0,-1143.0,1050.5 );
	    
		return 0;
	}
	
	if ( pData[ playerid ][ P_LEVEL ] >= _:P_LEVEL_MOD || IsPlayerAdmin( playerid ) )
	{
	    // If the player's level is greater than or equal to
	    // moderator level then we'll unlock the admin vehicles
	    // for them.
	    
	    if ( pData[ playerid ][ P_ADMIN_SPAWN ] )
	    {
			// If the player has admin spawn then we'll
	        // set additional adminny stuff for them.
	        
		    SetPlayerVirtualWorld	( playerid, 0 );
		    SetPlayerInterior		( playerid, 0 );
			GivePlayerWeapon		( playerid, WEAPON_SAWEDOFF, 999999 );
			SetPlayerHealth			( playerid, 100.0 );
			SetPlayerArmour			( playerid, 100.0 );
		}
		
		// Vehicle unlockage!
		for ( new i = 0; i < MAX_ADMIN_VEHICLES; i++ )
			SetVehicleParamsForPlayer( aVehicle[ i ], playerid, 0, 0 );
	}
	else
	{
		for ( new i = 0; i < MAX_ADMIN_VEHICLES; i++ )
			SetVehicleParamsForPlayer( aVehicle[ i ], playerid, 0, 1 );
	}

	if ( !pData[ playerid ][ P_ADMIN_SPAWN ] )
	{
	    // If the player is not on admin spawn.
		SetPlayerRandomSpawn( playerid );
		SetPlayerArmour		( playerid, pData[ playerid ][ P_ARMOR ] );
		SetPlayerHealth		( playerid, pData[ playerid ][ P_HEALTH ] );
		
		if ( pData[ playerid ][ P_BOUNTY ] > 0 && ( sHighBountyPlayer == INVALID_PLAYER_ID || pData[ playerid ][ P_BOUNTY ] > pData[ sHighBountyPlayer ][ P_BOUNTY ] ) )
		{
		    // If the players bounty is greater than 0 AND the highest bounty is an INVALID_PLAYER_ID or
		    // the players bounty is greater than the highest bounty.
			new
				szString[ 128 ];

			sHighBountyPlayer = playerid;

			GetPlayerName			( playerid, szString, MAX_PLAYER_NAME );
			format					( szString, sizeof( szString ), "* %s (%d) has the highest bounty ($%d). Look for the ORANGE blip.", szString, sHighBountyPlayer, pData[ sHighBountyPlayer ][ P_BOUNTY ] );
			SendClientMessageToAll	( COLOR_ORANGE, szString );
		}
		
		if ( sHighBountyPlayer == playerid )
		{
			SetPlayerColor( sHighBountyPlayer, COLOR_ORANGE );

			if ( IsPlayerInAnyGang( playerid ) )
			{
				for ( new memberid = 0; memberid < gData[ pData[ playerid ][ P_GANG_ID ] ][ G_TOTALS ]; memberid++ )
				{
				    if ( IsPlayerConnected( gData[ pData[ playerid ][ P_GANG_ID ] ][ G_MEMBERS ][ memberid ] ) )
						SetPlayerMarkerForPlayer( playerid, gData[ pData[ playerid ][ P_GANG_ID ] ][ G_MEMBERS ][ memberid ], setAlpha( gData[ pData[ playerid ][ P_GANG_ID ] ][ G_COLOR ], 0xAA ) );
				}
			}
		}
			
		else if ( !IsPlayerInAnyGang( playerid ) )
			SetPlayerColor( playerid, setAlpha( pColors[ playerid ], 0x40 ) );
			
		else
		{
			// If the spawning player is in a gang and is not the highest bounty player.
			// BUG: New spawning player is transparent to his gang members,
			
			// Set the new spawning players colour to his gang colour with alpha of 0x40.

			SetPlayerColor	( playerid, setAlpha( gData[ pData[ playerid ][ P_GANG_ID ] ][ G_COLOR ], 0x40 ) );
			SetTimerEx		( "SpawnFinish", 1337, 0, "i", playerid );
		}
		
		pData[ playerid ][ P_SKIN ] = GetPlayerSkin( playerid );
		
		AC_GivePlayerMoney( playerid, pData[ playerid ][ P_MONEY ] );
	}

	SetPlayerTime( playerid, sHour, sMinute );
	
	// Bank Blips
	SetPlayerMapIcon( playerid, 1, 2193.2351, 1990.9645, 12.2969, 52, 0 );
	SetPlayerMapIcon( playerid, 2, 2097.6602, 2223.3584, 11.0234, 52, 0 );
	SetPlayerMapIcon( playerid, 3, 1936.5438, 2307.1543, 10.8203, 52, 0 );
	SetPlayerMapIcon( playerid, 4, 2546.6885, 1971.7012, 10.8203, 52, 0 );
	SetPlayerMapIcon( playerid, 5, 2452.4104, 2064.3025, 10.8203, 52, 0 );
	SetPlayerMapIcon( playerid, 6, 2247.6313, 2397.0142, 10.8203, 52, 0 );
	SetPlayerMapIcon( playerid, 7, 2886.1011, 2452.4561, 11.0690, 52, 0 );
	SetPlayerMapIcon( playerid, 8, 2001.3333, 1544.2572, 13.5859, 37, 0 );

	for ( new i = 0; i < MAX_WEAPON_SLOT; i++ )
	{
		if ( pData[ playerid ][ P_TEMP_WEAPONS ][ i ] > 0 && pData[ playerid ][ P_TEMP_AMMO ][ i ] > 0 )
			GivePlayerWeapon( playerid, pData[ playerid ][ P_TEMP_WEAPONS ][ i ], pData[ playerid ][ P_TEMP_AMMO ][ i ] );
			
		else if ( pData[ playerid ][ P_SPAWN_WEAPONS ][ i ] > 0 && pData[ playerid ][ P_SPAWN_AMMO ][ i ] > 0 )
			GivePlayerWeapon( playerid, pData[ playerid ][ P_SPAWN_WEAPONS ][ i ], pData[ playerid ][ P_SPAWN_AMMO ][ i ] );
	}


    #if VERSION_LITE == false
	for ( new i = 0; i < sizeof( gZones ); i++ )
	{
		GangZoneShowForPlayer( playerid, gZones[ i ][ G_ZONE_ID ], gZones[ i ][ G_ZONE_COLOR ] );

		if ( gZones[ i ][ G_ZONE_WAR ] )
		    GangZoneFlashForPlayer( playerid, gZones[ i ][ G_ZONE_ID ], 0xFF000080 );
	}
	
	#endif

	pData[ playerid ][ P_SEEN_CLASS_SELECT ]	= 0;
	pData[ playerid ][ P_RETURNING_SPAWN ]		= 0;
	pData[ playerid ][ P_KILL_SPREE ]			= 0;
	pData[ playerid ][ P_INVINCIBLE_TICKS ]		= 4;
	
	SetPlayerHealth( playerid, 3.40282346638528860e38 );
	SetPlayerWantedLevel( playerid, 0 );
	TextDrawHideForPlayer( playerid, TEXT_SpawnScreenInfo );

	return 1;
}

public OnPlayerRequestClass( playerid, classid )
{
	if ( !pData[ playerid ][ P_FULLY_CONNECTED ] )
	{
		TextDrawShowForPlayer( playerid, TEXT_Day );

        #if NEW_PIRATE_MODE
		if ( sPirateOwner != INVALID_PLAYER_ID )
		{
			DestroyObject		( sPirateBriefcaseObj );
			sPirateBriefcaseObj = CreateObject( 1318,2002.7188, 1548.1165, 0.0, 0.0, 0.0, 0.0 );
			AttachObjectToPlayer( sPirateBriefcaseObj, sPirateOwner, 0.0, 0.0, 2.25, 0.0, 0.0, 90.0 );
		}
		#endif
		
	    pData[ playerid ][ P_FULLY_CONNECTED ]	= 1;
	    pData[ playerid ][ P_RESAVE_TICKS ]		= 0;
	    
		OnPlayerConnect( playerid );
	}

	if ( !pData[ playerid ][ P_LOGGED_IN ] )
	{
		SetPlayerPos			( playerid, 2109.0, 1456.75, 30.0 );
		SetPlayerCameraPos		( playerid, 2109.0, 1456.75, 55.0 );
		SetPlayerCameraLookAt	( playerid, 1969.0, 1555.00, 8.50 );
		
		return 1;
	}
	
	else if ( pData[ playerid ][ P_SKIN ] != -1 )
	{
		SetSpawnInfo	( playerid, playerid, pData[ playerid ][ P_SKIN ], 1958.3783, 1343.1572, 15.3746, 270.1425, 0, 0, 0, 0, 0, 0 );
		SpawnPlayer		( playerid );
		
		return 1;
	}
	
	else if ( !pData[ playerid ][ P_SEEN_CLASS_SELECT ] )
	{
		TextDrawShowForPlayer( playerid, TEXT_SpawnScreenInfo );

		SetPlayerInterior		( playerid, 12 );
		SetPlayerPos			( playerid, 2324.0,-1143.0,1050.4922 );
		SetPlayerFacingAngle	( playerid, 148.7130 );
		SetPlayerCameraPos		( playerid, 2322.507812, -1146.331054, 1050.710083 );
		SetPlayerCameraLookAt	( playerid, 2324.0,-1143.0,1050.5 );
	}

    new
		r = random( 2 );

	switch ( r )
	{
	    case 0:
	    {
			static
				RAPPING[ ][ ] =
					{
						"RAP_A_Loop", "RAP_B_Loop", "RAP_C_Loop"
					};

	        r = random( sizeof( RAPPING ) );

			ApplyAnimation( playerid, "RAPPING", RAPPING[ r ], 4.0, 1, 0, 0, 1, 1 );
	    }
	    case 1:
	    {
			static
				ON_LOOKERS[ ][ ] =
					{
						"lkaround_loop","lkup_loop", "panic_loop",
						"point_loop",	"shout_loop","wave_loop"
					};

	        r = random( sizeof( ON_LOOKERS ) );

	        ApplyAnimation( playerid, "ON_LOOKERS", ON_LOOKERS[ r ], 4.0, 1, 0, 0, 1, 1 );
	    }
	}

	pData[ playerid ][ P_SEND_TO_CLASS_SELECT ] = 0;
	pData[ playerid ][ P_SEEN_CLASS_SELECT ]	= 1;
	pData[ playerid ][ P_ADMIN_SPAWN ]			= 0;

	return 1;
}

public OnPlayerDeath( playerid, killerid, reason )
{
	if ( pData[ playerid ][ P_SEND_TO_CLASS_SELECT ] )
	{
		SetPlayerInterior		( playerid, 12 );
		SetPlayerCameraPos		( playerid, 2322.507812, -1146.331054, 1050.710083 );
		SetPlayerCameraLookAt	( playerid, 2324.0,-1143.0,1050.5 );
		
		return 0;
	}

	new
		_:		pMoney	= GetPlayerMoney( playerid ),
		Menu:	pMenu	= GetPlayerMenu( playerid ),
		Float:	pX,
		Float:	pY,
		Float:	pZ;

	GetPlayerPos( playerid, pX, pY, pZ );
	
	pData[ playerid ][ P_SHIP_CASH ]	= SHIP_CASH_DEFAULT;
	pData[ playerid ][ P_KILL_SPREE ]	= 0;

    if ( IsPlayerInAnyGang( playerid ) )
    {
		gData[ pData[ playerid ][ P_GANG_ID ] ][ G_DEATHS ]++;

        #if VERSION_LITE == false
		// If the players current gang zone does not equal an invalid gang zone, then
		// increase the deaths for the gang in that zone.
		if ( pData[ playerid ][ P_GANG_ZONE ] != INVALID_GANG_ZONE )
			zDeaths[ pData[ playerid ][ P_GANG_ID ] ][ pData[ playerid ][ P_GANG_ZONE ] ][ 1 ]++;
		#endif
	}

	if ( pData[ playerid ][ P_ACTIVITY ] >= _:P_ACTIVITY_BANK && pData[ playerid ][ P_ACTIVITY ] <= _:G_BANK_WITHDRAW )
	{
		// Hide the bank text for the player.
		TextDrawHideForPlayer( playerid, pData[ playerid ][ P_BANK_TEXT ] );

		// If IsPlayerInAnyGang then hide the gang bank text.
		if ( IsPlayerInAnyGang( playerid ) )
			TextDrawHideForPlayer( playerid, gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK_TEXT ] );
	}

	// Menu's are an activity so we'll set the player to _P_ACTIVITY_NONE since the script
	// currently only allows ONE activity.
	pData[ playerid ][ P_ACTIVITY ] = _:P_ACTIVITY_NONE;

	if ( pMenu != INVALID_MENU )
		HideMenuForPlayer( pMenu, playerid );

    if ( killerid != INVALID_PLAYER_ID )
    {
        pData[ killerid ][ P_KILL_SPREE ] ++;

		if ( !( pData[ killerid ][ P_KILL_SPREE ] % 5 ) )
        {
            new
                iKillerWantedLevel
					= GetPlayerWantedLevel( killerid );

			if ( iKillerWantedLevel < 6 )
				SetPlayerWantedLevel( killerid, iKillerWantedLevel + 1 );
        }

        new
			Float:kX, Float:kY, Float:kZ;
			
		GetPlayerPos( killerid, kX, kY, kZ );

        #if NEW_PIRATE_MODE == true
        if ( playerid == sPirateOwner )
        {
			if ( IsPlayerInAnyGang( playerid ) && !IsPlayerInGang( killerid, pData[ playerid ][ P_GANG_ID ] ) )
			{
				// If the killer is not in the players gang then ...

				AC_GivePlayerMoney	( killerid, 1000 );
				SendClientMessage	( killerid, COLOR_GREEN, "You killed the Pirate Ship owner and gained a $1000 bonus." );
			}

			// Restore the Pickup.
			DestroyObject		( sPirateBriefcaseObj );
			sPirateBriefcaseObj = CreateObject( 1318,2002.7188, 1548.1165, 0.0, 0.0, 0.0, 0.0 );

			sPirateOwner	= INVALID_PLAYER_ID;
			sPirateBriefcase= CreatePickup( 1210,DEFAULT_PICKUP_TYPE, pX, pY, pZ );
		}
		#endif

        if ( pMoney > 0 )
        {
            new
				iTmpMoney;

            if ( reason == 34 )
				iTmpMoney = ( pMoney / 100 ) * 50;
				
			else
				iTmpMoney = ( pMoney / 100 ) * 10;

        	AC_GivePlayerMoney( killerid, iTmpMoney );
        	AC_GivePlayerMoney( playerid, -iTmpMoney );
       	}

		// If the dead person is not in the same
		// gang as the killer.
		
		if ( !IsPlayerInGang( killerid, pData[ playerid ][ P_GANG_ID ] ) )
       	{
       	    if ( pData[ playerid ][ P_BOUNTY ] > 0 )
       	    {

	       	    new
					kString[ MAX_CLIENT_MSG ];

				GetPlayerName		( playerid, kString, MAX_PLAYER_NAME );
	       	    format				( kString, sizeof( kString ), "* You got $%d for killing %s.", pData[ playerid ][ P_BOUNTY ], kString );
	       	    SendClientMessage	( killerid, COLOR_GREEN, kString );
	       	    AC_GivePlayerMoney	( killerid, pData[ playerid ][ P_BOUNTY ] );

				pData[ playerid ][ P_BOUNTY ] = 0;

				if ( sHighBountyPlayer == playerid )
				{
					sHighBountyPlayer = 0;

					loopPlayers( i )
					{
						if ( pData[ i ][ P_BOUNTY ] > pData[ sHighBountyPlayer ][ P_BOUNTY ] && pData[ playerid ][ P_BOUNTY ] > 0 )
					        sHighBountyPlayer = i;
					}

					if ( pData[ sHighBountyPlayer ][ P_BOUNTY ] < 1 || sHighBountyPlayer == playerid )
					    sHighBountyPlayer = INVALID_PLAYER_ID;

					if ( sHighBountyPlayer != INVALID_PLAYER_ID )
					{
					    new
							szString[ 128 ];

						GetPlayerName			( playerid, szString, MAX_PLAYER_NAME );
						format					( szString, sizeof( szString ), "* %s (%d) has the highest bounty ($%d). Look for the ORANGE blip.", szString, sHighBountyPlayer, pData[ sHighBountyPlayer ][ P_BOUNTY ] );
						SendClientMessageToAll	( COLOR_ORANGE, szString );

					    SetPlayerColor( sHighBountyPlayer, COLOR_ORANGE );
					}
				}
			}
       	}

        if ( IsPlayerInAnyGang( killerid ) )
        {
	    	gData[ pData[ killerid ][ P_GANG_ID ] ][ G_KILLS ]++;

            #if VERSION_LITE == false
			if ( pData[ killerid ][ P_GANG_ZONE ] != INVALID_GANG_ZONE )
				zDeaths[ pData[ killerid ][ P_GANG_ID ] ][ pData[ killerid ][ P_GANG_ZONE ] ][ 0 ] ++;
			#endif
		}
		
        pData[ killerid ][ P_KILLS ]++;
    }
    #if NEW_PIRATE_MODE == true
    else if ( sPirateOwner == playerid )
    {
		// Restore the Pickup.
		
		DestroyObject		( sPirateBriefcaseObj );
		sPirateBriefcaseObj = CreateObject( 1318,2002.7188, 1548.1165, 0.0, 0.0, 0.0, 0.0 );

		sPirateOwner	= INVALID_PLAYER_ID;
		sPirateBriefcase= CreatePickup( 1210,DEFAULT_PICKUP_TYPE, pX, pY, pZ );
    }
    #endif

    CreateDeathPickups( playerid );

    pMoney = GetPlayerMoney( playerid );

	if ( pMoney > 0 )
	{
		AC_ResetPlayerMoney( playerid );
		
		pData[ playerid ][ P_MONEY ] = POCKET_MONEY;
	}
		
	ResetPlayerWeapons( playerid );
	SendDeathMessage( killerid, playerid, reason );

	for ( new i = 0; i < MAX_WEAPON_SLOT; i++ )
	{
		pData[ playerid ][ P_TEMP_WEAPONS ][ i ]= 0;
		pData[ playerid ][ P_TEMP_AMMO ][ i ]	= 0;
	}

	if	(
			( pData[ playerid ][ P_SPAWN_WEAPONS ][ 2 ] == START_WEAPON || !pData[ playerid ][ P_SPAWN_WEAPONS ][ 2 ] )
			&&
			( pData[ playerid ][ P_SPAWN_AMMO ][ 2 ] < START_AMMO )
		)
	{
		pData[ playerid ][ P_TEMP_WEAPONS ][ 2 ]= START_WEAPON;
		pData[ playerid ][ P_TEMP_AMMO ][ 2 ]	= START_AMMO;
	}

	pData[ playerid ][ P_SKIN ]		=	-1;
    pData[ playerid ][ P_ARMOR ]	=	0.0;
    pData[ playerid ][ P_HEALTH ]	=	100.0;
    pData[ playerid ][ P_DEATHS ]	++;

	return 1;
}

public OnVehicleSpawn( vehicleid )
{
    // Callback: LVA - OnVehicleSpawn
    
	// Link the newly spawned vehicle to interior 0,
	// since all vehicle spawns are outside by default.
	LinkVehicleToInterior( vehicleid, 0 );
	
	if ( sRhino == vehicleid )
	{
	    // If the new vehicle is the Rhino found
		// at Area 69 then destroy it.
		DestroyVehicle( vehicleid );
		
		// Set the variable containing the Rhino
		// vehicleid to 0 so it doesn't get reused.
		sRhino = 0;
	}

	return 1;
}

public OnPlayerCommandText( playerid, cmdtext[ ] )
{
    // Callback: LVA - OnPlayerCommandText
    
    // All commands in this callback are using DracoBlue's
    // dcmd macro, the format is:
    //  dcmd(name,name_len,source);
    // The source being cmdtext obviously
    
	// If the player is not connected properly then return 0
	// so they cannot use commands.
	if ( !IsPlayerConnected( playerid ) )
		return 0;

	// Put these commands before the print statement
	// so that it doesn't print private data (such as
	// passwords, email, etc) directly to console.
    dcmd(nick,4,cmdtext);
	dcmd(login,5,cmdtext);
	dcmd(email,5,cmdtext);
	dcmd(register,8,cmdtext);
	dcmd(password,8,cmdtext);

	// Command logger, will print the command directly to console
	// and log it to server_log.txt
	printf( "Command (ID:%d): %s", playerid, cmdtext );
    
    if ( !IsPlayerAdmin( playerid ) )
	{
	    // If the player is RCON administrator then they
		// can override the not logged in blocks and mutes.
	    
	    // If the player is not logged in then RETURN an error. Returning the error will return
	    // the return value of SendClientMessage (which is 1 at the time of writing this script).
	    // It will refuse standard output by returning 1.
	    
	    if ( !pData[ playerid ][ P_LOGGED_IN ] )
	    	return SendError( playerid, "This username is registered. You must login before using commands!" );

		if ( pData[ playerid ][ P_LEVEL ] < _:P_LEVEL_MOD )
		{
		    // Players greater than or equal to the moderator level can avoid
		    // personal mutes and server mutes.
		    
		    // If the server is muted then RETURN an error and refuse standard output.
			if ( sMute )
			    return SendError( playerid, "The server is muted." );

			// If the player is muted then RETURN an error and refuse standard output.
		    if ( pData[ playerid ][ P_MUTE ] )
				return SendError( playerid, "You are muted." );
		}
	}

	if ( IsPlayerAdmin( playerid ) || pData[ playerid ][ P_LEVEL ] >= _:P_LEVEL_MOD )
	{
		// Moderator level commands block.
		// If the player is RCON admin or the players level is greater than or equal to
		// moderator then they can use the commands in this block.
		
	    dcmd(mods,4,cmdtext);
		dcmd(kick,4,cmdtext);
		dcmd(mute,4,cmdtext);
		dcmd(admins,6,cmdtext);
		dcmd(unmute,6,cmdtext);
		dcmd(mutelist,8,cmdtext);
	}
	
	if ( IsPlayerAdmin( playerid ) || pData[ playerid ][ P_LEVEL ] >= _:P_LEVEL_ADMIN )
	{
		// Administrator level commands block.
		// If the player is RCON admin or the players level is greater than or equal to
		// administrator then they can use the commands in this block.
		
		#if ADMIN_SPAWN_COMMAND == true
		dcmd(as,2,cmdtext);
		#endif
		dcmd(do,2,cmdtext);
		dcmd(ban,3,cmdtext);
	    dcmd(unban,5,cmdtext);
	    dcmd(muteall,7,cmdtext);
	    dcmd(unmuteall,9,cmdtext);
	}
	
	if ( IsPlayerAdmin( playerid ) || pData[ playerid ][ P_LEVEL ] >= _:P_LEVEL_SERVER )
	{
	    // Server level commands block.
		// If the player is RCON admin or the players level is greater than or equal to
		// server level then they can use the commands in this block.
		
	    dcmd(drop,4,cmdtext);
	    dcmd(setname,7,cmdtext);
	    dcmd(wenable,7,cmdtext);
	    dcmd(setlevel,8,cmdtext);
	    dcmd(wdisable,8,cmdtext);
	}
	
	// Anybody that's not muted, logged in and is connected
	// properly can use the commands below.
	
	#if _SRV_03_ASSUMPTION_ == false
	if (!strcmp(cmdtext, "/pm", true, 3) || !strcmp(cmdtext, "/msg", true, 4))
	{
	    new
			iSendTo = INVALID_PLAYER_ID,
			sPersonalMsg[128];

		if (sscanf(cmdtext, "sus", sPersonalMsg, iSendTo, sPersonalMsg))
	        return SendUsage(playerid, "/pm [id/name] [msg]");

		if (!IsPlayerConnected(iSendTo))
		    return SendError(playerid, "Player not found!");

		else
			return OnPlayerPrivmsg(playerid, iSendTo, sPersonalMsg);
	}
	#endif
	
	dcmd(me,2,cmdtext);
	dcmd(buy,3,cmdtext);
	dcmd(tips,4,cmdtext);
	dcmd(sell,4,cmdtext);
	dcmd(help,4,cmdtext);
	dcmd(gang,4,cmdtext);
	dcmd(bank,4,cmdtext);
	dcmd(strip,5,cmdtext);
	dcmd(stats,5,cmdtext);
	dcmd(gbank,5,cmdtext);
	dcmd(gangs,5,cmdtext);
#if TEXT_DRAWS_INSTEAD_OF_CLIENT_MESSAGES == true
	dcmd(clear,5,cmdtext);
#endif
	dcmd(hitman,6,cmdtext);
	dcmd(bounty,6,cmdtext);
	dcmd(player,6,cmdtext);
	dcmd(report,6,cmdtext);
	dcmd(balance,7,cmdtext);
	dcmd(credits,7,cmdtext);
	dcmd(commands,8,cmdtext);
	dcmd(gbalance,8,cmdtext);
	dcmd(bounties,8,cmdtext);
	dcmd(givecash,8,cmdtext);
	dcmd(withdraw,8,cmdtext);
	dcmd(objective,9,cmdtext);
	dcmd(gwithdraw,9,cmdtext);
	dcmd(buyweapon,9,cmdtext);
	
	#if VERSION_LITE == false
	dcmd(territory,9,cmdtext);
	#endif
	
	dcmd(weaponlist,10,cmdtext);
	dcmd(properties,10,cmdtext);

	// Return standard output "SERVER: Unknown command"
	// with return 0.
	
	return 0;
}

public OnPlayerText( playerid, text[ ] )
{
	// Callback: LVA - OnPlayerText
	
	// If the player is not connected properly then return 0
	// so they cannot talk.
	if ( !IsPlayerConnected( playerid ) )
		return 0;
	
	if ( !IsPlayerAdmin( playerid ) )
	{
	    // RCON administrators are able to override chat block
	    // on not logged in accounts, server mutes and player
	    // mutes.
	    
		if ( !pData[ playerid ][ P_LOGGED_IN ] )
		{
		    // If the player is not administrator and is not logged in then refuse
		    // text with an error and return 0;
		    
			SendError( playerid, "This username is registered. You must login before talking!" );
			
			return 0;
		}

		if ( pData[ playerid ][ P_LEVEL ] < _:P_LEVEL_MOD )
		{
		    // Players greater than or equal to moderator
		    // status are able to override server mutes and
		    // mutes on themselves.
		    
			if ( sMute )
			{
			    // If server is muted then send an error and refuse
			    // normal output with return 0.
			    
				SendError( playerid, "The server is muted." );
				
			    return 0;
			}

		    if ( pData[ playerid ][ P_MUTE ] )
		    {
		        // If the player is muted then send an
		        // error and refuse normal output with return 0
		        
				SendError( playerid, "You are muted." );
				
				return 0;
			}
		}
	}
	
	if ( text[ 0 ] == '!' )
	{
		// ! is the prefix for Gang Chat.
	    // For example !message will send the message "message" to
	    // the players current gang if they're in one.
	    
	    if ( IsPlayerInAnyGang( playerid ) )
	    {
			// If the player is not in a gang then we can send
			// gang chat using SendClientMessageToGang and
			// refusing normal output with return 0

			new
				szString[ MAX_CLIENT_MSG ];

	        GetPlayerName			( playerid, szString, MAX_PLAYER_NAME );
	        format					( szString, sizeof ( szString ), "(Gang) %s: %s", szString, text[ 1 ] );
	        SendClientMessageToGang	( pData[ playerid ][ P_GANG_ID ], COLOR_CYAN, szString );
	        
	        return 0;
		}
	}
	
	else if ( text[ 0 ] == '@' )
	{
	    // @ is the prefix for Admin Chat.
	    // For example @message will send the message "message" to
	    // the administrators logged in via RCON or people whose
	    // level is higher than 2 (admin+)
	    
		if ( text[ 1 ] == '@' )
		{
		    // @@ is the prefix for moderator+ chat.
			// For example @@message will send the message "message" to
			// administrators logged in via RCON or people whose level is
			// higher than 1 (moderator+).
		    if ( pData[ playerid ][ P_LEVEL ] >= _:P_LEVEL_MOD || IsPlayerAdmin( playerid ) )
		    {
		        // Moderator chat which sends to moderators using the function
		        // SendMessageToLevelAndHigher.
		        // It refuses standard output with return 0.

                new
					szString[ MAX_CLIENT_MSG ];

		        GetPlayerName				( playerid, szString, MAX_PLAYER_NAME );
		        format						( szString, sizeof( szString ), "(Mod) %s: %s", szString, text[ 2 ] );
		        SendMessageToLevelAndHigher	( _:P_LEVEL_MOD, COLOR_YELLOW, szString );

		        return 0;
		    }
	    }
	    
		else if ( pData[ playerid ][ P_LEVEL ] >= _:P_LEVEL_ADMIN || IsPlayerAdmin( playerid ) )
	    {
	        // If the second letter wasn't @ (moderator chat) then we
			// can continue with normal admin chat using the function
			// SendClientMessageToAdmins.
			// It refuses standard output with return 0.
			
			new
				szString[ MAX_CLIENT_MSG ];
			
	        GetPlayerName				( playerid, szString, MAX_PLAYER_NAME );
	        format						( szString, sizeof ( szString ), "(Admin) %s: %s", szString, text[ 1 ] );
	        SendClientMessageToAdmins	( COLOR_RED, szString );

	        return 0;
	    }
	}

	else if ( text[ 0 ] == '#' )
	{
	    // # is the prefix for Last PM Chat.
	    // For example #message will send the message "message" to
	    // the last person the player has personal messaged (if any).

	    // If last personal message is INVALID_PLAYER_ID then send an error.
	    if ( pData[ playerid ][ P_LAST_PM_ID ] == INVALID_PLAYER_ID )
		    SendError( playerid, "You must have PM'ed someone to use this feature." );

		// If the last personal messaged playerid is not connected then
		// send an error.
		else if ( !IsPlayerConnected( pData[ playerid ][ P_LAST_PM_ID ] ) )
		    SendError( playerid, "Your last PM'ed playerid is not connected." );

		// Else call the function / callback OnPlayerPrivmsg, which is used for normal
		// PM's.

		else
		    OnPlayerPrivmsg( playerid, pData[ playerid ][ P_LAST_PM_ID ], text[ 1 ] );

		// Refuse standard output.

		return 0;
	}

	// Refuse standard output and send the player messages to all using
	// the native function SendPlayerMessageToAll.
	
	SendPlayerMessageToAll( playerid, text );

	return 0;
}


public OnPlayerInteriorChange( playerid, newinteriorid, oldinteriorid )
{
	// Callback: LVA - OnPlayerInteriorChange
	
	/*
	// If newinteriorid is equal to 0 (outside) then set them to a
	// unique team.
	if ( !newinteriorid )
		SetPlayerTeam( playerid, playerid );
		
	// Otherwise if they're in an interior then set them to TEAM_INTERIOR
	// so they cannot attack other people in interiors.
	else
		SetPlayerTeam( playerid, TEAM_INTERIOR );
	*/

	if ( !newinteriorid && GetPlayerState( playerid ) == PLAYER_STATE_ONFOOT  )
	{
		if ( !pData[ playerid ][ P_INVINCIBLE_TICKS ] )
			GetPlayerHealth( playerid, pData[ playerid ][ P_HEALTH ] );

		SetPlayerHealth( playerid, 3.40282346638528860e38 );

		pData[ playerid ][ P_INVINCIBLE_TICKS ]	= 3 ;
	}

	return 1;
}

public OnPlayerRequestSpawn( playerid )
{
	// Callback: LVA - OnPlayerRequestSpawn
	
	if ( !pData[ playerid ][ P_LOGGED_IN ] && !IsPlayerAdmin( playerid ) )
	{
	    // If the player is not logged in AND if the player is not admin
	    // then we will refuse spawn with return 0
	    
		// RCON administrators are able to override non-logged in account
		// spawn blocking.
	    
		SendError( playerid, "This username is registered. You must login before spawning!" );
		
		return 0;
	}

	// All is fine then let them spawn with return 1
	
	return 1;
}

public OnPlayerPickUpPickup( playerid, pickupid )
{
	// Callback: LVA - OnPlayerPickUpPickup
	
	if ( pickupid == sBeer )
	{
	    // If the pickupid is equal to the Beer pickup found
	    // in the "Shithole Bar" (Craw Bar)
	    
		new
			_:		iMoney		= GetPlayerMoney( playerid ),
			Float:	fHealth;

		GetPlayerHealth( playerid, fHealth );
	    
		if ( iMoney >= 100 )
	    {
	        // If the player has $100 or more then
	        // we will remove $100 from them.
	        
			AC_GivePlayerMoney( playerid, -100 );

			// If the players health is less than 80.0 then we'll
			// add 20.0 to it.
	        if ( fHealth < 80.0 )
	        	SetPlayerHealth( playerid, fHealth + 20.0 );

			// Otherwise we'll set the players health to 100.0 (full health).
			else
			    SetPlayerHealth( playerid, 100.0 );

			// Apply the drunk animation twice so that the effect is set correctly,
			// sometimes the player doesn't animate :(
			ApplyAnimation( playerid, "PED", "WALK_DRUNK", 4.1, 1, 1, 1, 1, 1 );
			ApplyAnimation( playerid, "PED", "WALK_DRUNK", 4.1, 1, 1, 1, 1, 1 );
			
			// Notify the player what the hell has just happened!
			SendClientMessage( playerid, COLOR_GREEN, "You lost $100 and gained some health from the beer." );

			if ( gPropertyData[ 16 ][ PROPERTY_OWNER ] != INVALID_PLAYER_ID )
			{
			    // If the property owner of the "Shithole Bar" (Craw Bar)
			    // is valid then we'll give them $100 and notify them why.
			    AC_GivePlayerMoney	( gPropertyData[ 16 ][ PROPERTY_OWNER ], 100 );
				SendClientMessage	( gPropertyData[ 16 ][ PROPERTY_OWNER ], COLOR_GREEN, "You gained $100 because somebody purchased a drink from your Shithole Bar property." );
			}

		}
		
		else
		{
		    // If the player has less than $100
		    SetPlayerHealth		( playerid, ( fHealth - 10.0 ) );
		    
		    ApplyAnimation		( playerid, "PED", "KO_skid_front", 4.1, 0, 1, 1, 0, -1 );
		    ApplyAnimation		( playerid, "PED", "KO_skid_front", 4.1, 0, 1, 1, 0, -1 );
		    
		    SendClientMessage	( playerid, COLOR_GREEN, "You do not have enough money for a beer!" );
		}
		
		return 1;
	}
	
	#if NEW_PIRATE_MODE == true
	else if ( pickupid == sPirateBriefcase )
	{
	    DestroyPickup		( sPirateBriefcase );
		AttachObjectToPlayer( sPirateBriefcaseObj, playerid, 0.0, 0.0, 2.25, 0.0, 0.0, 90.0 );
		SendClientMessage	( playerid, COLOR_GREEN, "The briefcase is yours! You will now generate $100 per second on the Pirate Ship." );

		sPirateBriefcase= -1;
		sPirateOwner	= playerid;
		
		return 1;
	}
	#endif
	
	else if ( pickupid == sPirate )
	{
		SendClientMessage( playerid, COLOR_GREEN, "Pirate Ship:" );
		
		#if NEW_PIRATE_MODE == true
	    SendClientMessage( playerid, COLOR_YELLOW, "You will earn $100 per second if you hold the briefcase on the Pirate Ship." );
	    #else
	    SendClientMessage( playerid, COLOR_YELLOW, "You will earn $25 per second if you stand on the Pirate Ships." );
	    #endif
	    
	    return 1;
	}
	
	else
	{
		for ( new i = 0; i < sizeof( sStrip ); i++ )
		{
			if ( pickupid == sStrip[ i ] )
			   return SendClientMessage( playerid, COLOR_GREEN, "Strippers can dance inside the strip club between 8pm and 4am to earn $25 per second (/strip)." );
		}
		
		for ( new i = 0; i < sMaxPlayers; i++ )
		{
		    for ( new j = 1; j < 6; j++ )
		    {
		        if ( moneyPickups[ i ][ j ] == pickupid )
		        {
		            AC_GivePlayerMoney( playerid, moneyPickups[ i ][ 0 ] );
		            DestroyPickup( pickupid );
		            moneyPickups[ i ][ j ] = -1;

		            return 1;
		        }
		    }
		}

		#if RANDOM_PICKUPS == true
		for ( new i = 0; i < MAX_RANDOM_PICKUPS; i++ )
		{
			if ( randPickups[ i ] == pickupid )
			{
				DestroyPickup( pickupid );
				GenerateRandomPickup( i );
				
				return 1;
		 	}
		}
		#endif
	}

	return 1;
}

public OnPlayerPrivmsg( playerid, recieverid, text[] )
{
	#define	receiverid recieverid

	if ( !( IsPlayerAdmin( receiverid ) || IsPlayerAdmin( playerid ) ) )
	{
	    // If the player is an admin OR the receiver is admin
	    // then the not logged in and muted checks will be ignored.
		if ( !pData[ playerid ][ P_LOGGED_IN ] )
			return SendClientMessage( playerid, COLOR_RED, "You are not logged in!" );
		
		if ( pData[ playerid ][ P_MUTE ] )
		    return SendClientMessage( playerid, COLOR_RED, "You are muted! You can only PM admins." );
	}

	new
				szString		[ MAX_CLIENT_MSG ],
				szSenderName	[ MAX_PLAYER_NAME ],
				szReceiverName	[ MAX_PLAYER_NAME ],
		Float:	pX,
		Float:	pY,
		Float:	pZ;

	GetPlayerPos( receiverid, pX, pY, pZ );

	PlayerPlaySound( receiverid, 1139, pX, pY, pZ );
	GameTextForPlayer( receiverid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~                ~y~New Personal Message ...", 5000, 3 );

    GetPlayerName( receiverid, szReceiverName, MAX_PLAYER_NAME );
	format( szString, sizeof( szString ), "PM to %s (ID:%d): %s", szReceiverName, receiverid, text );
	SendClientMessage( playerid, COLOR_YELLOW, szString );

	GetPlayerName( playerid, szSenderName, MAX_PLAYER_NAME );
	format( szString, sizeof( szString ), "PM from %s (ID:%d): %s", szSenderName, playerid, text );
	SendClientMessage( receiverid, COLOR_YELLOW, szString );
	
	format	( szString, sizeof( szString ), "[pm] %d %s %d %s %s", playerid, szSenderName, receiverid, szReceiverName, text );
	add_log	( szString );
	
	pData[ playerid ][ P_LAST_PM_ID ] = receiverid;
	
	return 1;

	#undef receiverid
}

public OnPlayerCreateGang( playerid, gangid )
{
	new
		gString[ MAX_CLIENT_MSG ];

	format( gString, sizeof( gString ), "* You created the gang %s (ID: %d).", gData[ gangid ][ G_NAME ], gangid );
	SendClientMessage( playerid, COLOR_GREEN, gString );
	
	if ( playerid != sRhinoOwner && playerid != sHighBountyPlayer )
		SetPlayerColor( playerid, setAlpha( gData[ gangid ][ G_COLOR ], 0x40 ) );

    #if VERSION_LITE == false
	gData[ pData[ playerid ][ P_GANG_ID ] ][ G_ZONE_TEXT ] = CreateTerritoryText( gData[ gangid ][ G_NAME ] );

    
	if ( pData[ playerid ][ P_GANG_ZONE ] != INVALID_GANG_ZONE )
		zTicks[ gangid ][ pData[ playerid ][ P_GANG_ZONE ] ][ 1 ] = 1;
	#endif

	return 1;
}

public OnPlayerLeaveGang( playerid, gangid, isleader, reason, otherid )
{
	if ( !gData[ gangid ][ G_TOTALS ] )
		return 0;

    #if VERSION_LITE == false
	TextDrawHideForPlayer( playerid, TEXT_WarProvokedAttack );
	TextDrawHideForPlayer( playerid, TEXT_WarProvokedDefense );
	TextDrawHideForPlayer( playerid, TEXT_TurfLost );
	TextDrawHideForPlayer( playerid, TEXT_TurfIsYours );
	TextDrawHideForPlayer( playerid, TEXT_TurfDefended );
	#endif

    gData[ gangid ][ G_COLOR ] = pColors[ gData[ gangid ][ G_LEADER ] ];
    
    #if VERSION_LITE == false
    if ( pData[ playerid ][ P_GANG_ZONE ] != INVALID_GANG_ZONE )
		zTicks[ gangid ][ pData[ playerid ][ P_GANG_ZONE ] ][ 1 ] --;
	#endif
    
	new
		gString[ MAX_CLIENT_MSG ];

	GetPlayerName( playerid, gString, MAX_PLAYER_NAME );

    switch ( reason )
    {
        case GANG_LEAVE_QUIT:
		{
			format( gString, sizeof( gString ), "* %s (ID: %d) left the gang (Quit).", gString, playerid );
			SendClientMessageToGang( gangid, COLOR_ORANGE, gString );

			format( gString, sizeof( gString ), "* You left the gang %s (ID: %d).", gData[ gangid ][ G_NAME ], gangid );
			SendClientMessage( playerid, COLOR_GREEN, gString );
		}
		
		case GANG_LEAVE_KICK:
		{
			format( gString, sizeof( gString ), "* %s (ID: %d) left the gang (Kicked).", gString, playerid );
			SendClientMessageToGang( gangid, COLOR_ORANGE, gString );

			GetPlayerName( otherid, gString, MAX_PLAYER_NAME );
			format( gString, sizeof( gString ), "* %s (ID:%d) kicked you from the gang %s (ID:%d).", gString, otherid, gData[ gangid ][ G_NAME ], gangid );
			SendClientMessage( playerid, COLOR_ORANGE, gString );
		}
		
		case GANG_LEAVE_UNKNOWN:
		{
			format( gString, sizeof( gString ), "* %s (ID: %d) left the gang (Unknown).", gString, playerid );
			SendClientMessageToGang( gangid, COLOR_ORANGE, gString );
		}
	}
	
	if ( isleader )
	{
	    GetPlayerName( gData[ gangid ][ G_LEADER ], gString, MAX_PLAYER_NAME );
		format( gString, sizeof( gString ), "* Your new gang leader is %s (ID: %d).", gString, gData[ gangid ][ G_LEADER ] );

		if ( playerid != sRhinoOwner && playerid != sHighBountyPlayer )
			SetPlayerColor( playerid, setAlpha( pColors[ playerid ], 0x40 ) );

		for ( new memberid = 0; memberid < gData[ gangid ][ G_TOTALS ]; memberid++ )
		{
		    if ( IsPlayerConnected( gData[ gangid ][ G_MEMBERS ][ memberid ] ) )
		    {
				if ( sRhinoOwner == gData[ gangid ][ G_MEMBERS ][ memberid ] || sHighBountyPlayer == gData[ gangid ][ G_MEMBERS ][ memberid ] )
				{
					// We don't need to set "memberid"'s colour ...

					for ( new omemberid = 0; omemberid < gData[ gangid ][ G_TOTALS ]; omemberid++ )
					{
						if ( !IsPlayerConnected( gData[ gangid ][ G_MEMBERS ][ omemberid ] ) )
							continue;

						// We need to set "omemberid"'s colour
						if( sRhinoOwner != gData[ gangid ][ G_MEMBERS ][ omemberid ] && sHighBountyPlayer != gData[ gangid ][ G_MEMBERS ][ omemberid ] )
				  			SetPlayerMarkerForPlayer( gData[ gangid ][ G_MEMBERS ][ memberid ], gData[ gangid ][ G_MEMBERS ][ omemberid ], setAlpha( gData[ gangid ][ G_COLOR ], 0xAA ) );
					}
     			}
     			
     			else
     			{
     				// We need to set memberid's colour.
					SetPlayerColor( gData[ gangid ][ G_MEMBERS ][ memberid ], setAlpha( gData[ gangid ][ G_COLOR ], 0x40 ) );

					for ( new omemberid = 0; omemberid < gData[ gangid ][ G_TOTALS ]; omemberid++ )
					{
 						if ( !IsPlayerConnected( gData[ gangid ][ G_MEMBERS ][ omemberid ] ) )
							continue;

						// We don't need to set "j"'s colour.
						if ( sRhinoOwner == gData[ gangid ][ G_MEMBERS ][ omemberid ] || sHighBountyPlayer == gData[ gangid ][ G_MEMBERS ][ omemberid ] )
							SetPlayerMarkerForPlayer( gData[ gangid ][ G_MEMBERS ][ omemberid ], gData[ gangid ][ G_MEMBERS ][ memberid ], setAlpha( gData[ gangid ][ G_COLOR ], 0xAA ) );

						// We need to set "j"'s and "i"'s colour.
	        			else
						{
							SetPlayerMarkerForPlayer( gData[ gangid ][ G_MEMBERS ][ memberid ], gData[ gangid ][ G_MEMBERS ][ omemberid ], setAlpha( gData[ gangid ][ G_COLOR ], 0xAA ) );
							SetPlayerMarkerForPlayer( gData[ gangid ][ G_MEMBERS ][ omemberid ], gData[ gangid ][ G_MEMBERS ][ memberid ], setAlpha( gData[ gangid ][ G_COLOR ], 0xAA ) );
						}
					}

					SendClientMessage( gData[ gangid ][ G_MEMBERS ][ memberid ], COLOR_GREEN, gString );
				}
     			
			}
		}
		
        #if VERSION_LITE == false
		for ( new gZ = 0; gZ < sizeof( gZones ); gZ++ )
		{
		    if ( gZones[ gZ ][ G_ZONE_OWNER ] == gangid )
		    {
				gZones[ gZ ][ G_ZONE_COLOR ] = ( gData[ gangid ][ G_COLOR ] & 0xFFFFFF00 ) | 0x80;

				GangZoneShowForAll( gZones[ gZ ][ G_ZONE_ID ], gZones[ gZ ][ G_ZONE_COLOR ] );

				if ( gZones[ gZ ][ G_ZONE_WAR ] )
					GangZoneFlashForAll( gZones[ gZ ][ G_ZONE_ID ], 0xFF000080 );
			}
		}
		#endif
	}
	else
	{
		// We need to show a new colour for i because he has no special colour.
		if ( sRhinoOwner != playerid && sHighBountyPlayer != playerid )
		    SetPlayerColor( playerid, setAlpha( pColors[ playerid ], 0x40 ) );

		for ( new memberid = 0; memberid < gData[ gangid ][ G_TOTALS ]; memberid++ )
		{
		    if ( !IsPlayerConnected( gData[ gangid ][ G_MEMBERS ][ memberid ] ) )
				continue;

			if ( sRhinoOwner != gData[ gangid ][ G_MEMBERS ][ memberid ] && sHighBountyPlayer != gData[ gangid ][ G_MEMBERS ][ memberid ] )
				SetPlayerMarkerForPlayer( playerid, gData[ gangid ][ G_MEMBERS ][ memberid ], setAlpha( gData[ gangid ][ G_COLOR ], 0xAA ) );
		}
	}
	
	return 1;
}

public OnPlayerJoinGang( playerid, gangid )
{
	new
		gString[ MAX_CLIENT_MSG ];

	format( gString, sizeof( gString ), "* You joined the gang %s (ID: %d).", gData[ gangid ][ G_NAME ], gangid );
	SendClientMessage( playerid, COLOR_GREEN, gString );

	GetPlayerName( playerid, gString, MAX_PLAYER_NAME );
	format( gString, sizeof( gString ), "* %s (ID: %d) joined your gang.", gString, playerid );
	SendClientMessageToGang( gangid, COLOR_ORANGE, gString );

	if ( pData[ playerid ][ P_ACTIVITY ] == _:P_ACTIVITY_BANK )
	{
		HideMenuForPlayer( mBank[ e_BANK_MENU_MAIN_NO_GANG ], playerid );
		ShowMenuForPlayer( mBank[ e_BANK_MENU_MAIN_IN_GANG ], playerid );
	}
	
	#if VERSION_LITE == false
	if ( pData[ playerid ][ P_GANG_ZONE ] != INVALID_GANG_ZONE )
		zTicks[ gangid ][ pData[ playerid ][ P_GANG_ZONE ] ][ 1 ]++;
	#endif

	if ( playerid != sRhinoOwner && playerid != sHighBountyPlayer )
	{
		SetPlayerColor( playerid, setAlpha( gData[ gangid ][ G_COLOR ], 0x40 ) );
		
		for ( new memberid = 0; memberid < gData[ gangid ][ G_TOTALS ]; memberid++ )
		{
			if ( IsPlayerConnected( gData[ gangid ][ G_MEMBERS ][ memberid ] ) && gData[ gangid ][ G_MEMBERS ][ memberid ] != sRhinoOwner && gData[ gangid ][ G_MEMBERS ][ memberid ] != sHighBountyPlayer )
			{
				SetPlayerMarkerForPlayer( gData[ gangid ][ G_MEMBERS ][ memberid ], playerid, setAlpha( gData[ gangid ][ G_COLOR ], 0xAA ) );
				SetPlayerMarkerForPlayer( playerid, gData[ gangid ][ G_MEMBERS ][ memberid ], setAlpha( gData[ gangid ][ G_COLOR ], 0xAA ) );
			}
		}
	}
	else
	{
		// We don't need to set playerid's colour
		for ( new memberid = 0; memberid < gData[ gangid ][ G_TOTALS ]; memberid++ )
		{
			if ( IsPlayerConnected( gData[ gangid ][ G_MEMBERS ][ memberid ] ) && gData[ gangid ][ G_MEMBERS ][ memberid ] != sRhinoOwner && gData[ gangid ][ G_MEMBERS ][ memberid ] != sHighBountyPlayer )
				SetPlayerMarkerForPlayer( playerid, gData[ gangid ][ G_MEMBERS ][ memberid ], setAlpha( gData[ gangid ][ G_COLOR ], 0xAA ) );
		}
	}

	return 1;
}

public OnGangDeath( gangid, leaderid, gname[ ] )
{
	new
		gString[ MAX_CLIENT_MSG ];
	
    #if VERSION_LITE == false
	TextDrawHideForPlayer( leaderid, TEXT_WarProvokedAttack );
	TextDrawHideForPlayer( leaderid, TEXT_WarProvokedDefense );
	TextDrawHideForPlayer( leaderid, TEXT_TurfLost );
	TextDrawHideForPlayer( leaderid, TEXT_TurfIsYours );
	TextDrawHideForPlayer( leaderid, TEXT_TurfDefended );
	#endif
	
	format( gString, sizeof( gString ), "* You left the gang %s (ID: %d).", gname, gangid );
	SendClientMessage( leaderid, COLOR_GREEN, gString );

    #if VERSION_LITE == false
	for ( new zoneid = 0; zoneid < MAX_SCRIPT_ZONES; zoneid++ )
	{
		if ( gZones[ zoneid ][ G_ZONE_OWNER ] == gangid )
	 	{
	 	    if ( gZones[ zoneid ][ G_ZONE_WAR ] )
				EndGangWar( zoneid );
	 	    
	 	    else
	 	    {
				for ( new memberid = 0; memberid < gData[ gangid ][ G_TOTALS ]; memberid++ )
				{
					if ( IsPlayerConnected( gData[ gangid ][ G_MEMBERS ][ memberid ] ) && pData[ gData[ gangid ][ G_MEMBERS ][ memberid ] ][ P_GANG_ZONE ] == zoneid )
					{
						TextDrawHideForPlayer( gData[ gangid ][ G_MEMBERS ][ memberid ], gZones[ zoneid ][ G_ZONE_TEXT ] );
						TextDrawShowForPlayer( gData[ gangid ][ G_MEMBERS ][ memberid ], TEXT_NoZoneOwner );
					}
	 	        }
	 	        
				gZones[ zoneid ][ G_ZONE_OWNER ]	= INVALID_GANG_ID;
	 			gZones[ zoneid ][ G_ZONE_COLOR ]	= COLOR_ZONE_DEFAULT;
		 		gZones[ zoneid ][ G_ZONE_TEXT ]		= TEXT_NoZoneOwner;
		 		
		 		zTicks	[ gangid ][ zoneid ][ 0 ]	= zTicks[ gangid ][ zoneid ][ 1 ]	= 0;
		 		zDeaths	[ gangid ][ zoneid ][ 0 ]	= zDeaths[ gangid ][ zoneid ][ 1 ]	= 0;
		 		
				GangZoneHideForAll	( zoneid );
		 		GangZoneShowForAll	( zoneid, gZones[ zoneid ][ G_ZONE_COLOR ] );
		 	}
		}
	}
	#endif
	
	if ( leaderid != sRhinoOwner && leaderid != sHighBountyPlayer )
		SetPlayerColor( leaderid, setAlpha( pColors[ leaderid ], 0x40 ) );

	return 1;
}

#if VERSION_LITE == false
public OnPlayerEnterGangZone( playerid, zoneid )
{
	// Can't be bothered typing this stuff all the time..
	// Lets create a easy to remember variable.
	new gangid = pData[ playerid ][ P_GANG_ID ];

	// If playerid is not OFFICIALLY in this zone.
	if ( !pData[ playerid ][ P_IN_ZONE ] )
	{
	    // Show zone name to player.
	    TextDrawShowForPlayer( playerid, gZones[ zoneid ][ G_ZONE_TEXT ] );

	    // Set player status to OFFICIALLY in zone so this won't increase again
	    // until he leaves.
	    pData[ playerid ][ P_IN_ZONE ] = 1;
	    
		// Increase amount of gang members in zone.
	    if ( IsPlayerInAnyGang( playerid ) )
	    	zTicks[ gangid ][ zoneid ][ 1 ]++;
	}

    // End code if player is not in any gang.
	if ( !IsPlayerInAnyGang( playerid ) )
		return 0;

	// If zone owner does not equal an invalid gang.
	if ( gZones[ zoneid ][ G_ZONE_OWNER ] != INVALID_GANG_ID )
	{
	    // If the players gang is allied with the zone owner then return 0.
		if ( gData[ pData[ playerid ][ P_GANG_ID ] ][ G_ALLY ] == gZones[ zoneid ][ G_ZONE_OWNER ] )
		    return 0;
	}

	// If gang war is happening.
	if ( gZones[ zoneid ][ G_ZONE_WAR ] )
	{
	    // Decrease gang ticks.
	    zTicks[ gangid ][ zoneid ][ 0 ]--;

	    // If no ticks for this gang ...
	    if ( !zTicks[ gangid ][ zoneid ][ 0 ] )
	    {
	        // Since this gang ended the war we'll give them
	        // 1 more kill.
	        zDeaths[ gangid ][ zoneid ][ 0 ]++;

	        // End the gang war.
			EndGangWar( zoneid );
	    }
	}
	
	//		zTicks[ gangid ][ zoneid ][ Ticks(0) | Players(1) ]
	// If there's less than two players in the turf then return 0.
	else if ( zTicks[ pData[ playerid ][ P_GANG_ID ] ][ zoneid ][ 1 ] < 2 )
		return 0;
	    
	// NO GANG WAR STARTED BELOW!!!

	// If the player is not in the zone owners gang.
	else if ( !IsPlayerInGang( playerid, gZones[ zoneid ][ G_ZONE_OWNER ] ) )
	{
	    // If zone ticks for the gang is greater than MAX_ZONE_TICKS.
	    if ( zTicks[ gangid ][ zoneid ][ 0 ] > MAX_ZONE_TICKS )
	    {
	        // Clear deaths/kills for all gangs for this zone.
	        // This makes it so kills that did not happen in the turf war are not counted.
	        
			for ( new g = 0; g < MAX_GANGS; g++ )
			{
			    zDeaths[ g ][ zoneid ][ 0 ] = 0; // Kills
			    zDeaths[ g ][ zoneid ][ 1 ] = 0; // Deaths
			}
	    
	        // If the zone owner is an INVALID_GANG_ID we'll make it the
	        // players gang's turf.
	        if ( gZones[ zoneid ][ G_ZONE_OWNER ] == INVALID_GANG_ID )
	        {
	            // Get our old text id for use.
	            new
					Text:oldText = gZones[ zoneid ][ G_ZONE_TEXT ];
					
				SendClientMessageToGang( gangid, COLOR_GREEN, "* $1000 was deposited into your gangs bank account for taking the turf." );
				gData[ gangid ][ G_BANK ] += 1000;
				
	            // Set new zone variables.
				gZones[ zoneid ][ G_ZONE_COLOR ] = ( gData[ gangid ][ G_COLOR ] & 0xFFFFFF00 ) | 0x80;
	            gZones[ zoneid ][ G_ZONE_OWNER ] = gangid;
	            gZones[ zoneid ][ G_ZONE_TEXT ]	 = gData[ gangid ][ G_ZONE_TEXT ];

	            // Hide the current gang zone text and show new text for all players in the zone.
				loopPlayers( i )
	            {
	                if ( pData[ i ][ P_GANG_ZONE ] == zoneid )
	                {
	                    TextDrawHideForPlayer( i, oldText );
						TextDrawShowForPlayer( i, gZones[ zoneid ][ G_ZONE_TEXT ] );
	                }
	            }

	            // Show the new gangzone for all players.
	            GangZoneShowForAll( zoneid, gZones[ zoneid ][ G_ZONE_COLOR ] );

	            // Show TurfIsYours text to the new gang zone owner.
	            TextDrawShowForGang( gangid, TEXT_TurfIsYours );

	            // Hide the TurfIsYours text after 10 seconds.
				SetTimerEx( "TextDrawHideForGang", 10000, 0, "ii", gangid, _:TEXT_TurfIsYours );
			}

			// Otherwise we'll start a turfwar.
			else
			{
			    #define TURF_WAR_TIME   480000  // 8 minutes, milliseconds
			    #define TURF_WAR_TICK   240     // 4 minutes for one players, seconds

			    // Set turf status to started.
			    gZones[ zoneid ][ G_ZONE_WAR ] = 1;

			    // Give gang one kill for starting gang war.
			    zDeaths[ gangid ][ zoneid ][ 0 ] += 1;
			    
				// Clear deaths/kills for all gangs for this zone.
				// This makes it so kills that did not happen in the turf war are not counted.
				
			    for ( new g = 0; g < MAX_GANGS; g++ )
				{
				    zDeaths[ g ][ zoneid ][ 0 ] = 0; // Kills
				    zDeaths[ g ][ zoneid ][ 1 ] = 0; // Deaths
				}

			    for ( new gID = 0; gID < MAX_GANGS; gID++ )
			    {
			        if ( gData[ gID ][ G_TOTALS ] )
			        {
			            zTicks[ gID ][ zoneid ][ 0 ]	= TURF_WAR_TICK;
			            zDeaths[ gID ][ zoneid ][ 0 ]	= zDeaths[ gID ][ zoneid ][ 1 ] = 0;
					}
			    }

			    // Make the zone flash.
				GangZoneFlashForAll( zoneid, 0xFF000080 );

				// Tell the attacking gang that they've provoked a war.
				TextDrawShowForGang( gangid, TEXT_WarProvokedAttack );

				// Tell the defense gang that a war has been provoked.
				TextDrawShowForGang( gZones[ zoneid ][ G_ZONE_OWNER ], TEXT_WarProvokedDefense );

				// Make text draws disappear after 10 seconds.
				SetTimerEx( "TextDrawHideForGang", 10000, 0, "ii", pData[ playerid ][ P_GANG_ID ], _:TEXT_WarProvokedAttack );
				SetTimerEx( "TextDrawHideForGang", 10000, 0, "ii", gZones[ zoneid ][ G_ZONE_OWNER ], _:TEXT_WarProvokedDefense );

				// End the gang war after 10 minutes if it doesn't end itself.
				gZones[ zoneid ][ G_ZONE_TIMER ] = SetTimerEx( "EndGangWar", TURF_WAR_TIME, 0, "i", zoneid );

				#undef TURF_WAR_TIME
			    #undef TURF_WAR_TICK
			}
		}
		// Otherwise increase ticks in zone.
		else zTicks[ gangid ][ zoneid ][ 0 ]++;
	}
	return 1;
}

public OnPlayerLeaveGangZone( playerid, zoneid )
{
	TextDrawHideForPlayer( playerid, gZones[ zoneid ][ G_ZONE_TEXT ] );

	if ( IsPlayerInAnyGang( playerid ) )
    {
        new gangid = pData[ playerid ][ P_GANG_ID ];

   		if ( pData[ playerid ][ P_IN_ZONE ] )
		{
	    	zTicks[ gangid ][ zoneid ][ 1 ]	--;
	    	
	    	if ( !gZones[ zoneid ][ G_ZONE_WAR ] && !zTicks[ gangid ][ zoneid ][ 1 ] )
				zTicks[ gangid ][ zoneid ][ 0 ]	= 0;
		}

//		if ( !zTicks[ gangid ][ zoneid ][ 1 ] ) zTicks[ gangid ][ zoneid ][ 0 ] = 0;
//		else if ( zTicks[ gangid ][ zoneid ][ 0 ] ) zTicks[ gangid ][ zoneid ][ 0 ] += zTicks[ gangid ][ zoneid ][ 0 ] / zTicks[ gangid ][ zoneid ][ 1 ];
    }

    pData[ playerid ][ P_IN_ZONE ] = 0;

	return 1;
}
#endif

public OnPlayerEnterCheckpoint( playerid )
{
	if ( !pData[ playerid ][ P_IN_CHECKPOINT ] )
	{
		pData[ playerid ][ P_IN_CHECKPOINT ] = 1;

		switch ( pData[ playerid ][ P_CHECKPOINT_AREA ] )
		{
		    case CP_S_BANK, CP_L_BANK:
			{
				SendClientMessage( playerid, COLOR_GREEN, "24/7 Bank:" );
				SendClientMessage( playerid, COLOR_YELLOW, "You can use the bank to store cash in your bank account." );
				SendClientMessage( playerid, COLOR_YELLOW, "Commands: /bank [amount], /withdraw [amount], /balance" );

				if ( IsPlayerInAnyGang( playerid ) )
				{
					gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK_TEXT ] = CreateGangBankText( pData[ playerid ][ P_GANG_ID ] );
				    SendClientMessage( playerid, COLOR_YELLOW, "Commands: /gbank [amount], /gwithdraw [amount], /gbalance" );
				}
				
				SetPlayerPos( playerid, gCheckpoints[ pData[ playerid ][ P_CHECKPOINT_AREA ] ][ CP_POS_X ] + minrand( -1, 1 ), gCheckpoints[ pData[ playerid ][ P_CHECKPOINT_AREA ] ][ CP_POS_Y ] + minrand( -1, 1 ), gCheckpoints[ pData[ playerid ][ P_CHECKPOINT_AREA ] ][ CP_POS_Z ] );
				SetPlayerFacingAngle( playerid, 180.0 );
				
				pData[ playerid ][ P_BANK_TEXT ] = CreateBankText( playerid );
				ShowBankMenu( playerid );
			}

			case CP_S_AMMUNATION, CP_M_AMMUNATION, CP_L_AMMUNATION:
			{
			    SendClientMessage( playerid, COLOR_GREEN, "Spawn Weapons:" );
			    SendClientMessage( playerid, COLOR_YELLOW, "You can buy weapons to spawn with here using the command" );
			    SendClientMessage( playerid, COLOR_YELLOW, "/buyweapon [weaponid] [amount]. To see a list of weapons type /weaponlist" );
			    
			    SetPlayerPos( playerid, gCheckpoints[ pData[ playerid ][ P_CHECKPOINT_AREA ] ][ CP_POS_X ] + minrand( -1, 1 ), gCheckpoints[ pData[ playerid ][ P_CHECKPOINT_AREA ] ][ CP_POS_Y ] + minrand( -1, 1 ), gCheckpoints[ pData[ playerid ][ P_CHECKPOINT_AREA ] ][ CP_POS_Z ] );
			    
			    ShowWeaponMenu( playerid );
			}

			case CP_ZIP .. CP_DIDIER_SACHS:
			{
			    new
					tString[ MAX_CLIENT_MSG ],
					tPropertyID = pData[ playerid ][ P_CHECKPOINT_AREA ] - _:CP_ZIP;

				if ( gPropertyData[ tPropertyID ][ PROPERTY_OWNER ] == playerid )
				{
					format( tString, sizeof( tString ), "* You can sell %s for $%d with /sell.", gPropertyData[ tPropertyID ][ PROPERTY_NAME ], gPropertyData[ tPropertyID ][ PROPERTY_PRICE ] );
				    SendClientMessage( playerid, COLOR_YELLOW, tString );
				    
				    ShowPropertyMenu( playerid );
				}
				
				else
				{
				    if ( gPropertyData[ tPropertyID ][ PROPERTY_CAN_BE_BOUGHT ] )
				    {
						format( tString, sizeof( tString ), "* You can purchase %s for $%d with /buy.", gPropertyData[ tPropertyID ][ PROPERTY_NAME ], gPropertyData[ tPropertyID ][ PROPERTY_PRICE ] );
					    SendClientMessage( playerid, COLOR_YELLOW, tString );
					    format( tString, sizeof( tString ), "* You will earn $%d regularly.", gPropertyData[ tPropertyID ][ PROPERTY_PAYMENT ] );
					    SendClientMessage( playerid, COLOR_YELLOW, tString );
					    
					    ShowPropertyMenu( playerid );
					}
					
					else
					    SendClientMessage( playerid, COLOR_RED, "This property is not for sale right now. Please check back soon." );

					if ( gPropertyData[ tPropertyID ][ PROPERTY_OWNER ] != INVALID_PLAYER_ID )
					{
						GetPlayerName( gPropertyData[ tPropertyID ][ PROPERTY_OWNER ], tString, MAX_PLAYER_NAME );

						format( tString, sizeof( tString ),  "* This property is currently owned by %s (ID: %d)", tString, gPropertyData[ tPropertyID ][ PROPERTY_OWNER ] );
						SendClientMessage( playerid, COLOR_RED, tString );
					}
				}
			}
			
			case CP_LIBERTY: GameTextForPlayer( playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Press ~r~~k~~PED_FIREWEAPON~ ~y~to go to Las Venturas", 3000, 3 );
		}
	}

	return 1;
}

public OnPlayerLeaveCheckpoint( playerid )
{
    pData[ playerid ][ P_IN_CHECKPOINT ] = 0;
	return 1;
}

public OnPlayerSelectedMenuRow( playerid, row )
{
	new
		Menu:tmpMenu = GetPlayerMenu( playerid ),   // Get the players menuid.
		bMenu = GetBankMenuID( tmpMenu );			// Get the bank menuid from the player menu.
	
	HideMenuForPlayer( tmpMenu, playerid );

	if ( bMenu != INVALID_BANK_MENU )
	{
		// If bMenu is not equal to INVALID_BANK_MENU then call to
		// our bank menu handler.
		
		OnPlayerSelectedBankRow( playerid, e_BANK_MENU:bMenu, row );
		
		return 1;
	}

	else if ( OnPlayerSelectedPropertyRow( playerid, tmpMenu, row ) )
	    return 1;
	    
	else if ( OnPlayerSelectedWeaponRow( playerid, tmpMenu, row ) )
		return 1;

	return 1;
}

public OnPlayerExitedMenu( playerid )
{
	if ( pData[ playerid ][ P_ACTIVITY ] >= _:P_ACTIVITY_BANK && pData[ playerid ][ P_ACTIVITY ] <= _:G_BANK_WITHDRAW )
	{
		// Hide the bank text for the player.
		TextDrawHideForPlayer( playerid, pData[ playerid ][ P_BANK_TEXT ] );

		// If IsPlayerInAnyGang then hide the gang bank text.
		if ( IsPlayerInAnyGang( playerid ) )
			TextDrawHideForPlayer( playerid, gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK_TEXT ] );

		// If the players activity is in between _P_ACTIVITY bank and _G_BANK_WITHDRAW (inclusive) then
		// show the main bank menu.
		if ( pData[ playerid ][ P_ACTIVITY ] != _:P_ACTIVITY_BANK )
			ShowBankMenu( playerid );
		else
		{
			// Menu's are an activity so we'll set the player to _P_ACTIVITY_NONE since the script
			// currently only allows ONE activity.
			
			pData[ playerid ][ P_ACTIVITY ] = _:P_ACTIVITY_NONE;
			TogglePlayerControllable( playerid, 1 );
		}
	}
	
	else if ( pData[ playerid ][ P_ACTIVITY ] >= _:P_ACTIVITY_AMMU_MAIN && pData[ playerid ][ P_ACTIVITY ] <= _:P_ACTIVITY_AMMU_ASSAULT )
	{
	    if ( pData[ playerid ][ P_ACTIVITY ] != _:P_ACTIVITY_AMMU_MAIN )
	        ShowWeaponMenu( playerid );
		else
		{
			// Menu's are an activity so we'll set the player to _P_ACTIVITY_NONE since the script
			// currently only allows ONE activity.
			
			pData[ playerid ][ P_ACTIVITY ] = _:P_ACTIVITY_NONE;
			TogglePlayerControllable( playerid, 1 );
		}
	}
	
	else if ( pData[ playerid ][ P_ACTIVITY ] == _:P_ACTIVITY_PROPERTY )
		TogglePlayerControllable( playerid, 1 );

	return 1;
}

public OnPlayerStateChange( playerid, newstate, oldstate )
{
	if ( newstate == PLAYER_STATE_DRIVER )
	{
		new
	        iVehicleID = GetPlayerVehicleID( playerid );

		if ( iVehicleID == sRhino )
		{
			sRhinoOwner = playerid;
			
			SetPlayerColor			( sRhinoOwner, COLOR_RED );
			SendClientMessageToAll	( COLOR_ORANGE, "(News) An unauthorized person has stolen a Rhino. The Rhino has been marked RED on your radar." );
		}
		
		return 1;
	}
	
	if ( oldstate == PLAYER_STATE_DRIVER )
	{
		new
	        iVehicleID = GetPlayerVehicleID( playerid );

	    if ( iVehicleID == sRhino || sRhinoOwner == playerid )
	    {
			if ( sHighBountyPlayer == playerid )
				SetPlayerColor( playerid, COLOR_ORANGE );

	    	else if ( !IsPlayerInAnyGang( playerid ) )
			    SetPlayerColor( playerid, setAlpha( pColors[ playerid ], 0x40 ) );

			else
			{
			    // If player isn't high bounty and if the player is in a gang...
				SetPlayerColor( playerid, setAlpha( gData[ pData[ playerid ][ P_GANG_ID ] ][ G_COLOR ], 0x40 ) );

				for ( new memberid = 0; memberid < gData[ pData[ playerid ][ P_GANG_ID ] ][ G_TOTALS ]; memberid++ )
				{
					if ( IsPlayerConnected( gData[ pData[ playerid ][ P_GANG_ID ] ][ G_MEMBERS ][ memberid ] ) )
					{
						SetPlayerMarkerForPlayer( gData[ pData[ playerid ][ P_GANG_ID ] ][ G_MEMBERS ][ memberid ], playerid, setAlpha( gData[ pData[ playerid ][ P_GANG_ID ] ][ G_COLOR ], 0xAA ) );
						
						if ( gData[ pData[ playerid ][ P_GANG_ID ] ][ G_MEMBERS ][ memberid ] != sRhinoOwner && gData[ pData[ playerid ][ P_GANG_ID ] ][ G_MEMBERS ][ memberid ] != sHighBountyPlayer )
							SetPlayerMarkerForPlayer( playerid, gData[ pData[ playerid ][ P_GANG_ID ] ][ G_MEMBERS ][ memberid ], setAlpha( gData[ pData[ playerid ][ P_GANG_ID ] ][ G_COLOR ], 0xAA ) );
					}
				}
			}

			sRhinoOwner = INVALID_PLAYER_ID;
	    }
	    
	    return 1;
	}
	
	return 1;
}

public OnPlayerExitVehicle( playerid )
{

	new
		iVehicleID = GetPlayerVehicleID( playerid );

	if ( iVehicleID == sRhino || sRhinoOwner == playerid )
	{
		if ( sHighBountyPlayer == playerid )
			SetPlayerColor( playerid, COLOR_ORANGE );

	    else if ( !IsPlayerInAnyGang( playerid ) )
			SetPlayerColor( playerid, setAlpha( pColors[ playerid ], 0x40 ) );

		else
		{
			// If player isn't high bounty and if the player is in a gang...
			SetPlayerColor( playerid, setAlpha( gData[ pData[ playerid ][ P_GANG_ID ] ][ G_COLOR ], 0x40 ) );

			for ( new memberid = 0; memberid < gData[ pData[ playerid ][ P_GANG_ID ] ][ G_TOTALS ]; memberid++ )
			{
				if ( IsPlayerConnected( gData[ pData[ playerid ][ P_GANG_ID ] ][ G_MEMBERS ][ memberid ] ) )
				{
					SetPlayerMarkerForPlayer( gData[ pData[ playerid ][ P_GANG_ID ] ][ G_MEMBERS ][ memberid ], playerid, setAlpha( gData[ pData[ playerid ][ P_GANG_ID ] ][ G_COLOR ], 0xAA ) );

					if ( gData[ pData[ playerid ][ P_GANG_ID ] ][ G_MEMBERS ][ memberid ] != sRhinoOwner && gData[ pData[ playerid ][ P_GANG_ID ] ][ G_MEMBERS ][ memberid ] != sHighBountyPlayer )
						SetPlayerMarkerForPlayer( playerid, gData[ pData[ playerid ][ P_GANG_ID ] ][ G_MEMBERS ][ memberid ], setAlpha( gData[ pData[ playerid ][ P_GANG_ID ] ][ G_COLOR ], 0xAA ) );
				}
			}
		}

		sRhinoOwner = INVALID_PLAYER_ID;
   }

	return 1;
}

public OnPlayerKeyStateChange( playerid, newkeys, oldkeys )
{
	if ( ( newkeys & KEY_FIRE ) && !( oldkeys & KEY_FIRE ) )
	{
		if ( pData[ playerid ][ P_CHECKPOINT_AREA ] == _:CP_LIBERTY && IsPlayerInCheckpoint( playerid ) )
	    {
			static const
				Float:SRSLY[ 7 ][ 4 ] =
				{
		            { 1674.9288,1447.7271,10.7889,267.6050 },
		            { 1666.4042,1423.3108,10.7832,270.9067 },
		            { 1677.5438,1394.1249,10.7260,303.3253 },
		            { 1703.5583,1365.9127,10.7502,355.6524 },
		            { 1667.1312,1472.3821,10.7750,272.3050 },
		            { 1679.9237,1502.2502,10.7687,242.5380 },
		            { 1703.4874,1526.3577,10.7578,181.4375 }
				};

			new
				ORLY = random( sizeof( SRSLY ) );

	        SetPlayerInterior( playerid, 0 );
	        SetPlayerPos( playerid, SRSLY[ ORLY ][ 0 ], SRSLY[ ORLY ][ 1 ], SRSLY[ ORLY ][ 2 ] );
	        SetPlayerFacingAngle( playerid, SRSLY[ ORLY ][ 3 ] );
	    }
	    else
	    {
		    new
				Float:pX,
				Float:pY,
				Float:pZ,
				pState = GetPlayerState( playerid );

			GetPlayerPos( playerid, pX, pY, pZ );

			if ( pX >= 8000.0 && pZ >= 100.0 && pState == PLAYER_STATE_DRIVER )
			{
				new
					plyrVehicle = GetPlayerVehicleID( playerid );
			    
			    loopPlayers( i )
			    {
					if ( GetPlayerVehicleID( i ) == plyrVehicle )
			        {
						SetPlayerInterior( i, 1 );
						SetPlayerPos( i, -784.3389,494.7509,1376.1953 );
						SetPlayerFacingAngle( i, 90.6109 );
				    }
			    }

				SetVehicleToRespawn( plyrVehicle );
		    }
	    }
	}

	return 1;
}

//******************************************************************************
//	Functions
//******************************************************************************

public GetPlayerLevel( playerid )
	return pData[ playerid ][ P_LEVEL ];

public AC_GetPlayerMoney( playerid )
	return AC_Money[ playerid ];

public AC_GivePlayerMoney( playerid, money )
{
	GivePlayerMoney( playerid, money );

	pData	[ playerid ][ P_SCRIPT_MONEY ]	+= 2;
	AC_Money[ playerid ]					+= money;
	
	return 1;
}

public AC_ResetPlayerMoney( playerid )
{
	ResetPlayerMoney( playerid );
	
	pData	[ playerid ][ P_SCRIPT_MONEY ]	+= 2;
	AC_Money[ playerid ]					= 0;

	return 1;
}

public PropertySync( )
{
	new
		pPayments	[ sizeof ( gPropertyData ) ][ 2 ],
		tString		[ MAX_CLIENT_MSG ];

	for ( new i = 0; i < sizeof ( gPropertyData ); i++ )
	{
	    //  Set this array to equal { INVALID_PLAYER_ID, 0 };
		pPayments[ i ] = { INVALID_PLAYER_ID, 0 };

		// If this property is owned by a valid player id
		if ( gPropertyData[ i ][ PROPERTY_OWNER ] != INVALID_PLAYER_ID )
		{
			gPropertyData[ i ][ PROPERTY_TICKS ]--;

			if ( !gPropertyData[ i ][ PROPERTY_TICKS ] )
			{
				gPropertyData[ i ][ PROPERTY_CAN_BE_BOUGHT ]= 1;
				gPropertyData[ i ][ PROPERTY_TICKS ]		= gPropertyData[ i ][ PROPERTY_TIME ];

				for ( new k = 0; k < sizeof ( gPropertyData ); k++ )
				{
					if ( pPayments[ k ][ 0 ] == gPropertyData[ i ][ PROPERTY_OWNER ] )
				    {
						pPayments[ k ][ 1 ] += gPropertyData[ i ][ PROPERTY_PAYMENT ];
						break;
					}

					else if ( pPayments[ k ][ 0 ] == INVALID_PLAYER_ID )
					{
					    pPayments[ k ][ 0 ] = gPropertyData[ i ][ PROPERTY_OWNER ];
					    pPayments[ k ][ 1 ] = gPropertyData[ i ][ PROPERTY_PAYMENT ];
						break;
					}
				}
			}
		}
	}

	for ( new i = 0; i < sizeof( gPropertyData ); i++ )
	{
	    if ( pPayments[ i ][ 0 ] !=	INVALID_PLAYER_ID )
	    {
			AC_GivePlayerMoney( pPayments[ i ][ 0 ], pPayments[ i ][ 1 ] );
			format( tString, sizeof( tString ), "* You earned $%d from your properties.", pPayments[ i ][ 1 ] );
	        SendClientMessage( pPayments[ i ][ 0 ], COLOR_GREEN, tString );
	    }
	}
}

public WeatherSync( )
{
	for ( new s = 0; s < 3; s++ )
	{
		sWeather[ s ][ 1 ]--;

		if ( !sWeather[ s ][ 1 ] )
		{
		    switch ( s )
		    {
				case 0 : sWeather[ s ][ 0 ]	= randarg( 10, 11, 12 );	// Las Venturas
				case 1 : sWeather[ s ][ 0 ]	= randarg( 17, 18, 19 );	// Desert
				default: sWeather[ s ][ 0 ]	= randarg( 0, 1, 2, 15 );   // Everywhere else
			}

			sWeather[ s ][ 1 ] = minrand( 2, 16 );
		}
	}
}

public SaveSync( )
{
	for ( new tmpSave = 0; tmpSave < MAX_SAVES; tmpSave++ )
	{
	    if ( !tData[ tmpSave ][ T_TICKS ] )
			continue;

		tData[ tmpSave ][ T_TICKS ]--;

		if ( !tData[ tmpSave ][ T_TICKS ] )
        {
			for ( new i = 0; i < MAX_WEAPON_SLOT; i++ )
			{
			    tData[ tmpSave ][ T_TEMP_WEAPONS ][ i ]	= tData[ tmpSave ][ T_TEMP_AMMO ][ i ]	= 0;
			    tData[ tmpSave ][ T_SPAWN_WEAPONS ][ i ]= tData[ tmpSave ][ T_SPAWN_AMMO ][ i ]	= 0;
			}

			tData[ tmpSave ][ T_NAME ]		= '\0';
		    tData[ tmpSave ][ T_MONEY ]		= tData[ tmpSave ][ T_MUTE ] = tData[ tmpSave ][ T_BANK ] = tData[ tmpSave ][ T_BOUNTY ] = 0;
			tData[ tmpSave ][ T_SKIN ]		= -1;
			tData[ tmpSave ][ T_ARMOR ]		= 0.0;
			tData[ tmpSave ][ T_HEALTH ]	= 100.0;
		}
	}
}

public ScriptSync( )
{
	new
		tString[ MAX_CLIENT_MSG ];

	#if NEW_PIRATE_MODE == true
	if ( sPirateOwner != INVALID_PLAYER_ID )
	{
	    new
	        Float:pX, Float:pY, Float:pZ;

		GetPlayerPos( sPirateOwner, pX, pY, pZ );
		
		// If the pirate owner is in the pirate ship area then give them $100.
		if	(
				pZ >= 10.75 && pZ <= 60.75 &&
				(
					IsPointInArea( pX, pY, pZ, 1995.5, 2006.0, 1518.0, 1569.0 )				||	// Ship 1
					IsPointInArea( pX, pY, pZ, 1930.7327, 1975.8258, 1471.5734, 1556.2048 ) ||	// Ship 2
					IsPointInArea( pX, pY, pZ, 1957.9447, 1997.2313, 1521.3459, 1548.3746 )     // BoardWalk
				)
			)	AC_GivePlayerMoney( sPirateOwner, 100 );
		
		else
		{
		    SendClientMessage	( sPirateOwner, COLOR_GREEN, "You lost the briefcase because you left the ship." );
		    DestroyObject		( sPirateBriefcaseObj );
		    sPirateBriefcaseObj = CreateObject( 1318,2002.7188, 1548.1165, 0.0, 0.0, 0.0, 0.0 );
		    
		    sPirateOwner	= INVALID_PLAYER_ID;
			sPirateBriefcase= CreatePickup( 1210,DEFAULT_PICKUP_TYPE, 2002.7188, 1548.1165, 13.5859 );
		}
	}
	#endif
	
	if ( sRhinoOwner != INVALID_PLAYER_ID )
		AC_GivePlayerMoney( sRhinoOwner, -25 );
	
	loopPlayers( playerid )
	{
		new
			pState = GetPlayerState( playerid );
        
        // Increase the amount of seconds online.
        pData[ playerid ][ P_ONLINE_TICKS ] ++;
        
	    // Set the players score to their money.
	    SetPlayerScore( playerid, GetPlayerMoney( playerid ) );
	    
	    // If the player has no state (aka not spawned) then go to next playerid.
		if ( !pState )
			continue;
			
		// If the minute is 0 (new hour) then resync the time.
		if ( !sMinute )
			SetPlayerTime( playerid, sHour, sMinute );
			
		// Create pOldGangZone to store old gangzone for when the player leaves
	    new
	        pOldCheckpoint	= pData[ playerid ][ P_CHECKPOINT_AREA],
			pOldGangZone	= pData[ playerid ][ P_GANG_ZONE ],
			pSpecialAction	= GetPlayerSpecialAction( playerid ),
			pMoney			= GetPlayerMoney( playerid ),
			pInterior		= GetPlayerInterior( playerid ),
			Float:pX,
			Float:pY,
			Float:pZ;
			
		GetPlayerPos( playerid, pX, pY, pZ );
		
		if ( !IsPlayerAdmin( playerid ) && pData[ playerid ][ P_LEVEL ] < _:P_LEVEL_SERVER )
		{
		    if ( pSpecialAction == SPECIAL_ACTION_USEJETPACK )
		    {
			    new
					DB:Database = db_open( SZ_SQLITE_DB );

				if ( Database )
				{
					BanPlayer	( Database, playerid, 1000, "Jetpack." );
					db_close    ( Database );
				}
				
				else
					BanEx( playerid, "Jetpack." );

				continue;
			}
		}
		
		if ( pData[ playerid ][ P_INVINCIBLE_TICKS ] )
		{
			pData[ playerid ][ P_INVINCIBLE_TICKS ]--;

			if ( !pData[ playerid ][ P_INVINCIBLE_TICKS ] )
			{
			    if ( pData[ playerid ][ P_HEALTH ] > 0.0 )
					SetPlayerHealth( playerid, pData[ playerid ][ P_HEALTH ] );
					
				else
				{
					SetPlayerHealth		( playerid, 100.0 );
					SendClientMessage	( playerid, COLOR_RED, "ERROR: FAILSAFE 001 APPLIED" );
					printf				( "ERROR: FAILSAFE 001 APPLIED TO PLAYER %d", playerid );
				}
			}
	    }
		
		if ( pState == PLAYER_STATE_DRIVER || pState == PLAYER_STATE_PASSENGER )
		{
		    if ( pX >= 8000.0 && pZ >= 100.0 )
		        GameTextForPlayer( playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Press ~r~~k~~PED_FIREWEAPON~ ~y~to go to Liberty City", 3000, 3 );
		}
		
		if ( pData[ playerid ][ P_LOGGED_IN ] && pData[ playerid ][ P_REGISTERED ] )
		{
			pData[ playerid ][ P_RESAVE_TICKS ]++;
			
			if ( pData[ playerid ][ P_RESAVE_TICKS ] > 1200 ) // SAVE EVERY 20 MINUTES
			{
				new
					DB:Database = db_open( SZ_SQLITE_DB );

				GetPlayerName( playerid, tString, MAX_PLAYER_NAME );
				
				if ( Database )
				{
					SaveUser			( Database, playerid, tString );
					SendClientMessage	( playerid, 0xFFFFFFFF, "* Your stats have been automatically saved." );
				    db_close			( Database );
				}
				else
				    print ( "[ERROR] NO DATABASE!" );
				    
				pData[ playerid ][ P_RESAVE_TICKS ] = 0;
			}
		}
		
		if ( ( sHour >= 20 || sHour <= 4 ) && IsPlayerStripper( playerid ) && IsPlayerInAnyStripClub( playerid ) && pSpecialAction == SPECIAL_ACTION_DANCE4 )
			AC_GivePlayerMoney( playerid, 25 );

		if ( !pInterior )
		{
			if ( IsPointInArea( pX, pY, pZ, 618.9274, 2966.18, 607.2495, 2989.536 ) )		// Las Venturas
				SetPlayerWeather( playerid, sWeather[ 0 ][ 0 ] );

			else if ( IsPointInArea( pX, pY, pZ, -1307.922, 618.9274, 910.8743, 2884.435 ) )// Desert
			    SetPlayerWeather( playerid, sWeather[ 1 ][ 0 ] );

			else
			    SetPlayerWeather( playerid, sWeather[ 2 ][ 0 ] );
		}
		else
		    SetPlayerWeather( playerid, 0 );
		    
		#if NEW_PIRATE_MODE == false
		if	(
				pZ >= 10.75 && pZ <= 60.75 &&
				(
					IsPointInArea( pX, pY, pZ, 1995.5, 2006.0, 1518.0, 1569.0 )				||	// Ship 1
					IsPointInArea( pX, pY, pZ, 1930.7327, 1975.8258, 1471.5734, 1556.2048 ) ||	// Ship 2
					IsPointInArea( pX, pY, pZ, 1957.9447, 1997.2313, 1521.3459, 1548.3746 )     // BoardWalk
				)
			)	AC_GivePlayerMoney( playerid, 25 );
		#endif
	    
	    if ( pInterior )
	    {
			// Majority of checkpoints are interior based so
			// we can start checking checkpoints here.
			pData[ playerid ][ P_GANG_ZONE ] = INVALID_GANG_ZONE;

			if	(
					 pData[ playerid ][ P_CHECKPOINT_AREA ] == 255 ||
					!IsPointInCheckpointArea( pInterior, pX, pY, pZ, pData[ playerid ][ P_CHECKPOINT_AREA ] )
			 	)
			{
			    pData[ playerid ][ P_CHECKPOINT_AREA ] = 255;
			    
				// Check if player is in any of the checkpoints.
				for ( new i = 0, j = sizeof ( gCheckpoints ); i < j; i++ )
				{
					// If player is in the checkpoint area for CPID i, then create the checkpoint,
					// set pInCP to 1 (true) and end the loop.
					if ( IsPointInCheckpointArea( pInterior, pX, pY, pZ, i ) )
					{
						CreateCheckpoint( playerid, i );
						
						break;
					}
				}
			}
	    }
	    
	    else
	    {
	        // All gang territories are not in interiors so
	        // we can start checking gangzones here.
	        
	        pData[ playerid ][ P_CHECKPOINT_AREA ] = 255;
	        
            #if VERSION_LITE == false
            
			if	(
					 pData[ playerid ][ P_GANG_ZONE ] == INVALID_GANG_ZONE	||
					!IsPointInGangZone( pX, pY, pZ, pData[ playerid ][ P_GANG_ZONE ] )
				)
			{
				pData[ playerid ][ P_GANG_ZONE ] = INVALID_GANG_ZONE;

				// Check if player is in any of the gang zones.
				for ( new i = 0, j = sizeof ( gZones ); i < j; i++ )
				{
					// If player is in gang zone then set current gang zone to the current
					// gangid and end the loop.

					if ( IsPointInGangZone( pX, pY, pZ, i ) )
					{
						pData[ playerid ][ P_GANG_ZONE ] = i;
						
						break;
					}
				}
			}
			
			#endif
	    }

	    // If players checkpoint is invalid then disable the checkpoint.
	    if ( pOldCheckpoint != 0xFF )
	    {
	        if ( pData[ playerid ][ P_CHECKPOINT_AREA ] == 0xFF )
	        {
				DisablePlayerCheckpoint( playerid );
				
				if ( pData[ playerid ][ P_NO_WEAPON_AREA ] )
				{
					// Player is in NO WEAPON AREA and is leaving it
				    // ...
				    
				    SetPlayerTeam		( playerid, playerid );
				    
				    #if		MODE_PROTECTED_WEAPONS == 0

					GameTextForPlayer	( playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~         ~y~Weapons Enabled:~n~        ~r~Fighting Allowed", 5000, 3 );

					for ( new i = 0; i < MAX_WEAPON_SLOT; i++ )
					{
						GivePlayerWeapon( playerid, pData[ playerid ][ P_TEMP_WEAPONS ][ i ], pData[ playerid ][ P_TEMP_AMMO ][ i ] );

						pData[ playerid ][ P_TEMP_AMMO ][ i ]	=0;
					    pData[ playerid ][ P_TEMP_WEAPONS ][ i ]=0;
					}
					
					#elseif	MODE_PROTECTED_WEAPONS == 1
					
					GameTextForPlayer	( playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~         ~y~Weapon Damage Enabled:~n~        ~r~Fighting Allowed", 5000, 3 );

					#endif
					
					pData[ playerid ][ P_NO_WEAPON_AREA ] = 0;
				}
				
			}
			
			else if ( pData[ playerid ][ P_NO_WEAPON_AREA ] )
			{
				#if		MODE_PROTECTED_WEAPONS == 0
			    
				new
					lTempWeaponData[ 2 ];

				for ( new i = 0; i < MAX_WEAPON_SLOT; i++ )
				{
					GetPlayerWeaponData( playerid, i, lTempWeaponData[ 0 ], lTempWeaponData[ 1 ] );

					if ( lTempWeaponData[ 0 ] && lTempWeaponData[ 1 ] && ( lTempWeaponData[ 1 ] < 65535 || !i || i == 1 || i == 10 || i == 12 ) )
					{
						pData[ playerid ][ P_TEMP_WEAPONS ][ i ]	= lTempWeaponData[ 0 ];
						pData[ playerid ][ P_TEMP_AMMO ][ i ]		+=lTempWeaponData[ 1 ];
					}
					
					lTempWeaponData[ 0 ] = 0;
					lTempWeaponData[ 1 ] = 0;
					
					SetPlayerAmmo( playerid, i, 0 );
				}
				
				GameTextForPlayer	( playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~         ~y~Weapons Disabled:~n~        ~r~Fighting Disallowed", 2000, 3 );
				ResetPlayerWeapons	( playerid );
				
				#elseif MODE_PROTECTED_WEAPONS == 1
				
				SetPlayerTeam( playerid, TEAM_INTERIOR );
				GameTextForPlayer	( playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~         ~y~Weapon Damage Disabled:~n~        ~r~Fighting Disallowed", 2000, 3 );
				
				#endif
			}
		}
		
        #if VERSION_LITE == false
		// If player gangzone is not equal to their old zone and old gang zone is not equal to
		// an invalid gang zone then call the callback OnPlayerLeaveGangZone.
		if ( pData[ playerid ][ P_GANG_ZONE ] != pOldGangZone && pOldGangZone != INVALID_GANG_ZONE )
		    OnPlayerLeaveGangZone( playerid, pOldGangZone );
//			CallRemoteFunction( "OnPlayerLeaveGangZone", "ii", playerid, pOldGangZone );

		// If the player gang zone is not equal to an invalid gang zone then call the
		// callback OnPlayerEnterGangZone.
		if ( pData[ playerid ][ P_GANG_ZONE ] != INVALID_GANG_ZONE )
		    OnPlayerEnterGangZone( playerid, pData[ playerid ][ P_GANG_ZONE ] );
//			CallRemoteFunction( "OnPlayerEnterGangZone", "ii", playerid, pData[ playerid ][ P_GANG_ZONE ] );
		#endif
		
		if ( !pData[ playerid ][ P_SCRIPT_MONEY ] )
		{
			if ( pMoney > AC_GetPlayerMoney( playerid ) + 5000 )
			{
			    new
					iACMoneyIncrease = pMoney - AC_GetPlayerMoney( playerid ),
					pName[ MAX_PLAYER_NAME ],
					mName[ 32 ] = "Unknown";

				GetPlayerName( playerid, pName, MAX_PLAYER_NAME );

				if ( IsPointInArea( pX, pY, pZ, 1995.5, 2006.0, 1518.0, 1569.0 ) )
					mName = "Pirate Ship";
					
				else
				{
					switch ( pData[ playerid ][ P_CHECKPOINT_AREA ] )
				    {
				        case CP_LIBERTY				: mName = "Liberty City";
				        case CP_S_BANK				: mName = "Small Bank";
				        case CP_L_BANK				: mName = "Large Bank";
				        case CP_S_AMMUNATION        : mName = "Small Ammunation";
				        case CP_M_AMMUNATION		: mName = "Medium Ammunation";
				        case CP_L_AMMUNATION        : mName = "Large Ammunation";
						case CP_ZIP .. CP_DANCE_CLUB: strcpy( mName, gPropertyData[ pData[ playerid ][ P_CHECKPOINT_AREA ] - _:CP_ZIP ][ PROPERTY_NAME ] );
				        default						: mName = "Unknown";
				    }
				}


				format( tString, sizeof( tString ), "(Warning) %s (%d)'s cash just increased by $%d ($%d -> $%d) (%s).",
					pName, playerid,
					iACMoneyIncrease, AC_GetPlayerMoney( playerid ),
					pMoney, mName
				);

				SendMessageToLevelAndHigher( _:P_LEVEL_MOD, 0xFF9900AA, tString );

				format( tString, MAX_CLIENT_MSG, "[cashincrease] %s %d %d %d %s",
					pName, playerid, AC_GetPlayerMoney( playerid ),
					pMoney, mName
				);

				add_log( tString );
			}
			
			AC_Money[ playerid ] = pMoney;
		}
		else
			pData[ playerid ][ P_SCRIPT_MONEY ]--;
	}


	// Increase sMinute.
	sMinute++;

	// Server minutes now equals the remainder of 60 divided by sMinute.
	sMinute %= 60;

	// If sMinute is 0 (New hour).
	if ( !sMinute )
	{
	    // Increase sHour and then make it the remainder of 24 divided by sHour. Set the world time to this hour also.
		sHour++; sHour %= 24; SetWorldTime( sHour );

		// If sHour is 0
		if ( !sHour )
		{
		    new str[ 64 ];

		    // Increase the sDay.
		    sDay++;

		    // sDay is now equal to the remainder of 7 divided by sDay.
		    sDay %= 7;

		    // Notify the server of the new day through client messages ...
		    // Might use text draw for this later on.

		    
		    if ( sDay == 6 )
		    {
		        format( str, sizeof( str ), "~y~%s", random( 2 ) ? ("Caturday") : ("Saturday") );
				
				if ( !sRhino )
				{
					sRhino = CreateVehicle( 432, 307.8188, 1801.3085, 17.6503, 179.5013, 43, 0, 960 );
					SetVehicleHealth( sRhino, 2500.0 );
				}
			}
		    else
		        format( str, sizeof( str ), "~y~%s", sDays[ sDay ] );
		        
			TextDrawSetString( TEXT_Day, str );
		}
	}
}

public SpawnFinish( playerid )
{
	#define gangid	pData[ playerid ][ P_GANG_ID ]
	
	for ( new memberid = 0; memberid < gData[ gangid ][ G_TOTALS ]; memberid++ )
	{
		if ( IsPlayerConnected( gData[ gangid ][ G_MEMBERS ][ memberid ] ) && sRhinoOwner != gData[ gangid ][ G_MEMBERS ][ memberid ] && sHighBountyPlayer != gData[ gangid ][ G_MEMBERS ][ memberid ] )
		{
			// If the players i and playerid are in the same gang then set the marker to the gang colour
			// with an alpha of 0xAA.

			SetPlayerMarkerForPlayer( gData[ gangid ][ G_MEMBERS ][ memberid ], playerid, setAlpha( gData[ gangid ][ G_COLOR ], 0xAA ) );
			SetPlayerMarkerForPlayer( playerid, gData[ gangid ][ G_MEMBERS ][ memberid ], setAlpha( gData[ gangid ][ G_COLOR ], 0xAA ) );
		}
	}

	#undef gangid
}

stock randarg( ... )
	return getarg( random( numargs( ) ) );

stock CreateDeathPickups( playerid )
{
	new
				tmpMoney = GetPlayerMoney( playerid ),
		Float:	pX,
		Float:	pY,
		Float:	pZ;

	GetPlayerPos( playerid, pX, pY, pZ );
	
	if ( moneyPickups[ playerid ][ 6 ] )
	{
		KillTimer			( moneyPickups[ playerid ][ 6 ] );
		DestroyDeathPickups	( playerid );
	}

	if ( tmpMoney > 0 )
	{
	    new
			pickup = 1212;
	    
		moneyPickups[ playerid ][ 0 ] = tmpMoney / 5;
		
		if ( moneyPickups[ playerid ][ 0 ] >= 10000 )
			pickup = 1550;
		
		for ( new i = 1; i < 6; i++ )
			moneyPickups[ playerid ][ i ] = CreatePickup( pickup, DEFAULT_PICKUP_TYPE, pX + minrand(-4, 4), pY + minrand(-4, 4), pZ );
	}

	moneyPickups[ playerid ][ 6 ] = SetTimerEx( "DestroyDeathPickups", 16000, 0, "i", playerid );
}

public DestroyDeathPickups( playerid )
{
	for ( new i = 1; i < 6; i++ )
	{
	    if ( moneyPickups[ playerid ][ i ] != -1 )
			DestroyPickup( moneyPickups[ playerid ][ i ] );

	    moneyPickups[ playerid ][ i ] = -1;
	}

	moneyPickups[ playerid ][ 0 ] = 0;
	moneyPickups[ playerid ][ 6 ] = 0;
}

stock IsPlayerInGangZone( playerid, zoneid )
{
	if ( IsPlayerInArea( playerid,
						 gZones[ zoneid ][ G_ZONE_MINX ],
						 gZones[ zoneid ][ G_ZONE_MAXX ],
						 gZones[ zoneid ][ G_ZONE_MINY ],
						 gZones[ zoneid ][ G_ZONE_MAXY ]
						) && !GetPlayerInterior( playerid ) ) return 1;
	else return 0;
}

stock IsPointInGangZone( Float:X, Float:Y, Float:Z, zoneid )
{
	if ( IsPointInArea(	 X, Y, Z,
						 gZones[ zoneid ][ G_ZONE_MINX ],
						 gZones[ zoneid ][ G_ZONE_MAXX ],
						 gZones[ zoneid ][ G_ZONE_MINY ],
						 gZones[ zoneid ][ G_ZONE_MAXY ]
						) ) return 1;
	else return 0;
}

stock IsPlayerInCheckpointArea( playerid, checkpointid )
{
	if ( 	GetPlayerInterior( playerid ) == gCheckpoints[ checkpointid ][ CP_INT_ID ] &&
			IsPlayerInArea( playerid,
						 gCheckpoints[ checkpointid ][ CP_MIN_X ],
	    				 gCheckpoints[ checkpointid ][ CP_MAX_X ],
	    				 gCheckpoints[ checkpointid ][ CP_MIN_Y ],
	    				 gCheckpoints[ checkpointid ][ CP_MAX_Y ],
	    				 gCheckpoints[ checkpointid ][ CP_MIN_Z ],
	    				 gCheckpoints[ checkpointid ][ CP_MAX_Z ]
						) ) return 1;
	else return 0;
}

stock IsPointInCheckpointArea( Interior, Float:X, Float:Y, Float:Z, checkpointid )
{
	if ( Interior == gCheckpoints[ checkpointid ][ CP_INT_ID ] &&
		 IsPointInArea(	 X, Y, Z,
						 gCheckpoints[ checkpointid ][ CP_MIN_X ],
	    				 gCheckpoints[ checkpointid ][ CP_MAX_X ],
	    				 gCheckpoints[ checkpointid ][ CP_MIN_Y ],
	    				 gCheckpoints[ checkpointid ][ CP_MAX_Y ],
	    				 gCheckpoints[ checkpointid ][ CP_MIN_Z ],
	    				 gCheckpoints[ checkpointid ][ CP_MAX_Z ]
						) ) return 1;
	else return 0;
}

stock CreateCheckpoint( playerid, checkpointid )
{
	pData[ playerid ][ P_CHECKPOINT_AREA ]	= checkpointid;
    
	SetPlayerCheckpoint( playerid, gCheckpoints[ checkpointid ][ CP_POS_X ], gCheckpoints[ checkpointid ][ CP_POS_Y ], gCheckpoints[ checkpointid ][ CP_POS_Z ], gCheckpoints[ checkpointid ][ CP_SIZE ] );
    
	if ( !gCheckpoints[ checkpointid ][ CP_WEAPONS ] )
	{

		SetPlayerTeam( playerid, TEAM_INTERIOR );
		
		pData[ playerid ][ P_NO_WEAPON_AREA ] = 1;
		
		#if	MODE_PROTECTED_WEAPONS == 0
		
		new
			lTempWeaponData[ 2 ];
		
		for ( new i = 0; i < MAX_WEAPON_SLOT; i++ )
		{
			GetPlayerWeaponData( playerid, i, lTempWeaponData[ 0 ], lTempWeaponData[ 1 ] );
			
			if ( lTempWeaponData[ 0 ] && lTempWeaponData[ 1 ] && ( lTempWeaponData[ 1 ] < 65535 || !i || i == 1 || i == 10 || i == 12 ) )
		    {
				pData[ playerid ][ P_TEMP_WEAPONS ][ i ]	=	lTempWeaponData[ 0 ];
				pData[ playerid ][ P_TEMP_AMMO ][ i ]		=	lTempWeaponData[ 1 ];
			}
			
			lTempWeaponData[ 0 ] = 0;
			lTempWeaponData[ 1 ] = 0;
			
			SetPlayerAmmo( playerid, i, 0 );
		}
		
		ResetPlayerWeapons( playerid );
		
		#endif
	}
	else
		SetPlayerTeam( playerid, playerid );
}

stock SetPlayerRandomSpawn( playerid )
{
	#define OFFSET_STRIPPER 0
	#define OFFSET_POLICE	1
	#define OFFSET_MEDIC    14
	#define OFFSET_FIREMAN  22
	#define	OFFSET_CIVILIAN	25

	enum e_RANDOM_SPAWNS
	{
		Float:RANDOM_SPAWN_X,
		Float:RANDOM_SPAWN_Y,
		Float:RANDOM_SPAWN_Z,
		Float:RANDOM_SPAWN_A,
		RANDOM_SPAWN_INTERIOR
	};

	static const
		pSpawns[ ][ e_RANDOM_SPAWNS ] = {
	    {1208.2711,-33.2142,1000.9531,315.0714,3},	// Spawn - Stripper	(LV)
		{2295.0415,2451.5464,10.8203,89.0655,0},    // Spawn - Police 	(LV)
		{2294.6040,2468.9285,10.8203,90.8953,0},
		{2286.0598,2427.5940,10.8203,149.8661,0},
		{231.0483,161.4586,1003.0234,233.0988,3},
		{246.9417,164.7775,1003.0234,149.1481,3},
		{213.2755,163.4328,1003.0234,206.1519,3},
		{197.8837,168.1885,1003.0234,268.8191,3},
		{269.6069,176.8701,1005.3715,67.9705,3},
		{297.5797,186.0465,1007.1719,178.5549,3},
		{262.4999,190.0030,1008.1719,297.0194,3},
		{2341.1389,2455.0972,14.9688,92.3127,0},
		{2281.7095,2426.2266,3.4692,357.8210,0},
		{2268.0894,2447.0925,3.5313,193.4319,0},
		{1606.8721,1819.4994,10.8280,0.3462,0},		// Spawn - Medic	(LV)
		{1584.9095,1799.6050,10.8280,6.6925,0},
		{1581.0449,1769.0640,10.8203,87.1078,0},
		{1581.6655,1761.6107,10.8280,134.8145,0},
		{1581.8123,1777.5729,10.8280,45.2565,0},
		{1631.4338,1794.3911,10.8203,326.6888,0},
		{1604.5007,1720.9878,10.8203,177.9336,0},
		{1593.2970,1722.1927,10.8203,176.1098,0},
		{1734.5189,2107.8079,12.2891,51.2150,0},	// Spawn - Fireman	(LV)
		{1748.1394,2065.3582,10.8203,269.1852,0},
		{1774.9980,2075.9319,10.8203,137.3502,0},
		{2577.8779,1972.4156,10.8203,317.8635,0},   // Spawn - Civilian	(LV)
		{2615.7769,2017.8888,14.1161,182.3087,0},
		{2367.7322,2122.5745,10.8209,41.5126,0},
		{2216.5132,2460.9226,10.8203,247.9833,0},
		{2214.7400,2523.0300,10.8203,179.2060,0},
		{2244.5078,2521.6494,10.8203,180.6782,0},
		{2274.0713,2554.3535,10.8252,275.0790,0},
		{2386.1064,2465.6763,10.8203,88.1180,0},
		{2254.0007,2397.7883,10.8203,0.3858,0},
		{2375.5303,2309.9895,8.1406,359.5600,0},
		{2445.2883,2376.2554,12.1635,90.5498,0},
		{2518.4126,2447.8909,11.0313,268.1938,0},
		{2520.1628,2297.4150,10.8203,273.2206,0},
		{2534.1780,2259.4719,10.8203,91.3519,0},
		{2490.0181,2397.4844,10.8203,272.8332,0},
		{2501.8943,2125.4211,10.8203,331.3618,0},
		{2440.7119,2158.0991,10.8203,181.0481,0},
		{2334.2920,2163.1619,10.8487,233.1796,0},
		{2420.9590,2059.7786,10.8125,178.0299,0},
		{2636.2859,2347.0620,10.6719,189.9837,0},
		{2860.4919,2425.5583,11.0690,180.3352,0},
		{2785.2432,2444.8469,11.0625,138.1644,0},
		{2822.6577,2135.0352,14.6615,174.2129,0},
		{2855.4690,1292.8123,11.3906,230.3576,0},
		{2806.3787,1254.6965,11.3125,0.9955,0},
		{2630.8098,1717.1105,11.0234,84.9371,0},
		{2630.5859,1824.1240,11.0234,90.6243,0},
		{2597.6101,1895.4417,11.0312,179.5940,0},
		{2412.1411,1996.7469,10.8203,274.8322,0},
		{2166.3579,2010.9558,10.8203,53.6476,0},
		{2260.8037,2036.1832,10.8203,92.1344,0},
		{2365.2429,1981.6089,10.8125,130.0798,0},
		{2021.1766,1913.4680,12.3135,281.7769,0},
		{2312.5847,2160.6587,10.8203,129.3867,0},
		{2602.4929,2210.4753,14.1161,358.6106,0},
		{2574.3264,2382.7058,17.8145,164.0770,0},
		{2586.8696,2313.0674,17.8222,265.9113,0},
		{2445.8601,2376.0947,12.1635,100.1473,0},
		{2464.7188,2546.0286,22.0781,11.0318,0},
		{2494.6345,2764.3513,10.8203,70.6827,0},
		{2167.9028,2808.3481,15.8516,109.0852,0},
		{1998.9938,2725.4814,10.8203,5.0576,0},
		{1967.4832,2764.8647,10.8203,180.9842,0},
		{1807.0913,2774.5479,14.2735,163.5764,0},
		{1724.9543,2799.0471,14.2735,103.6899,0},
		{1626.7462,2751.4436,10.8203,178.4174,0},
		{1570.0924,2713.8940,10.8203,0.2305,0},
		{1602.1322,2844.2751,10.8203,175.6702,0},
		{1457.6132,2773.6250,10.8203,271.4428,0},
		{1457.3605,2641.5591,11.3926,122.1264,0},
		{1430.6111,2617.6753,11.3926,176.9603,0},
		{1881.1653,2647.5256,10.8203,171.1578,0},
		{1618.9598,2608.4185,10.8203,185.4744,0},
		{1564.3478,2566.7036,10.8203,359.6001,0},
		{1515.7629,2609.5220,11.0549,177.2384,0},
		{1349.5146,2569.6555,10.8203,3.5719,0},
		{1320.0276,1253.6912,14.2731,5.4793,0},
		{1492.1433,700.1144,10.8203,350.1037,0},
		{1019.3434,1181.7448,10.8203,332.1364,0},
		{1163.7324,1367.5988,10.8125,22.0233,0},
		{1076.2146,1806.5125,10.8203,45.2157,0},
		{946.8815,1733.8002,8.8516,269.5771,0},
		{922.6499,1923.8794,11.2408,114.3823,0},
		{922.5867,2021.8718,11.2301,106.9798,0},
		{987.4793,2274.9309,11.4609,307.5706,0},
		{1136.7711,2284.9666,10.8203,48.7268,0},
		{987.2609,2345.8391,11.4688,308.8089,0},
		{1022.8469,2366.5178,10.8203,90.8182,0},
		{1136.8528,2072.9814,11.0625,139.8002,0},
		{367.5206,-67.0627,1001.5078,168.3720,10},
		{371.0161,-58.0332,1001.5212,163.9853,10},
		{1413.1840,2080.5415,10.9746,105.2389,0},
		{1418.5743,2031.2112,14.7396,185.3032,0},
		{1481.4432,2198.7378,11.0234,304.3298,0},
		{1601.8604,2218.4690,11.0625,224.6605,0},
		{1529.1097,2357.6594,10.8203,277.1359,0},
		{1445.5994,2360.0820,10.8203,261.4203,0},
		{1366.8798,2525.6194,10.8203,252.2024,0},
		{1313.8385,2607.1514,10.8203,189.9668,0},
		{2325.8823,-1013.2347,1050.2109,89.5907,9},
		{2321.2080,-1004.9431,1054.7188,0.7716,9},
		{2329.4036,-1012.3550,1054.7188,58.1847,9},
		{2326.8652,-1019.3565,1050.2109,126.6112,9},
		{1431.2281,2660.7188,11.3926,324.2330,0},
		{1608.0023,2748.8513,10.8203,174.1419,0},
		{2014.1615,2316.2676,10.8203,188.2945,0},
		{1937.1332,2180.7773,10.8125,45.9298,0},
		{1917.4487,2131.6924,10.8203,339.4210,0},
		{2162.8660,2014.3800,10.8125,52.3273,0},
		{2304.3101,1516.8859,10.8203,261.1006,0},
		{2138.3115,1489.1532,10.8203,6.9977,0},
		{2083.8821,1654.0415,10.8125,141.4223,0},
		{2241.6531,1633.5273,1008.3594,130.6612,1},
		{2271.4438,1612.3309,1006.1797,4.8450,1},
		{2255.3396,1593.0006,1006.1797,280.8943,1},
		{2234.5908,1593.5117,1006.1839,190.0502,1},
		{2208.0190,1609.3539,1006.1865,118.2961,1},
		{2174.8818,1609.6324,1006.1474,240.9556,1},
		{2153.1348,1625.5502,1008.3594,215.0936,1},
		{2179.8560,1630.5339,1008.3594,246.1140,1},
		{2224.5852,1667.7716,1008.3594,315.6746,1},
		{2022.7483,1514.0011,10.8203,328.8952,0},
		{2022.1515,1342.4635,10.8130,269.2837,0},
		{1936.3739,1345.1782,9.8533,270.7993,0},
		{2096.2881,1276.3656,10.8203,177.9783,0},
		{2235.2576,1290.9464,10.8203,124.2882,0},
		{2146.0208,1134.6913,13.5043,62.7541,0},
		{2030.2075,999.7216,10.8131,323.0244,0},
		{2003.6809,1013.4965,994.4688,50.5196,10},
		{1951.7550,997.6650,992.8594,39.2395,10},
		{1941.7075,995.3929,992.4609,315.2654,10},
		{1927.5110,1031.1006,994.4688,230.3513,10},
		{1941.6832,1049.3741,992.4745,249.4648,10},
		{1981.6357,1026.2520,994.4688,221.8912,10},
		{2419.1633,1131.2460,10.8203,240.9675,0},
		{2419.1633,1131.2460,10.8203,240.9675,0},
		{371.1117,169.4952,1008.3828,43.6262,3},
		{2508.6870,1292.2231,10.8125,109.9921,0},
		{2511.8875,1246.0981,10.8203,42.4873,0},
		{2087.4797,1449.8265,10.8203,110.5767,0},
		{1686.9507,1449.5842,10.7688,276.4518,0},
		{1628.5875,1017.4887,10.8203,268.9178,0},
		{1666.2279,1034.0123,10.9043,177.4236,0},
		{1704.4568,1024.7406,10.8203,92.8227,0},
		{1713.1708,915.2463,10.8203,2.5357,0},
		{1561.1823,1006.5410,10.8125,272.9501,0},
		{1848.7124,739.3742,11.4609,220.8529,0},
		{1848.6520,693.4667,11.4531,296.3435,0},
		{2011.8123,653.5253,11.4609,41.7111,0},
		{2088.1978,691.9083,11.4609,147.2122,0},
		{2226.3628,732.1501,11.4609,140.4870,0},
		{2315.1467,693.3939,11.4609,31.6523,0},
		{2617.5413,717.0925,14.7396,2.5372,0} // 
	};

	new
		r,
	    isStripper;

	if ( ( sHour >= 20 || sHour <= 4 ) && IsPlayerStripper( playerid ) )
	{
	    isStripper	= 1;
	    r			= OFFSET_STRIPPER;
	    
	    if ( !pData[ playerid ][ P_TEMP_WEAPONS ][ 1 ] )
			GivePlayerWeapon( playerid, 10, 1 );
	}
	
	else
	{
		switch ( GetPlayerSkin( playerid ) )
		{
			case 265 .. 267, 280 .. 286, 288:
			{
				// Police
				
				if ( !pData[ playerid ][ P_TEMP_WEAPONS ][ 1 ] )
					GivePlayerWeapon( playerid, 3, 1 );
					
				r = minrand( OFFSET_POLICE, OFFSET_MEDIC );
			}
		    case 274 .. 276:
			{
			    // Medic
			    
//			    if ( !pData[ playerid ][ P_TEMP_WEAPONS ][ 1 ] )
//					GivePlayerWeapon( playerid, 4, 1 );

				if ( pData[ playerid ][ P_ARMOR ] < 1.0 )
					SetPlayerArmour( playerid, 50.0 );
			        
				r = minrand( OFFSET_MEDIC, OFFSET_FIREMAN );
			}
		    case 277 .. 279:
			{
			    // Fireman
			    
				if ( !pData[ playerid ][ P_TEMP_WEAPONS ][ 9 ] )
			        GivePlayerWeapon( playerid, 42, 0xFF );
			        
				r = minrand( OFFSET_FIREMAN, OFFSET_CIVILIAN );
			}
		    default:
			{
				// Civilian
				
			    if ( !pData[ playerid ][ P_TEMP_WEAPONS ][ 1 ] )
			        GivePlayerWeapon( playerid, 5, 1 );

				r = minrand( OFFSET_CIVILIAN, sizeof( pSpawns ) );
			}
		}
	}

    SetPlayerFacingAngle( playerid, pSpawns[ r ][ RANDOM_SPAWN_A ] );
	SetPlayerInterior	( playerid, pSpawns[ r ][ RANDOM_SPAWN_INTERIOR ] );
	SetPlayerPos		( playerid, pSpawns[ r ][ RANDOM_SPAWN_X ], pSpawns[ r ][ RANDOM_SPAWN_Y ], pSpawns[ r ][ RANDOM_SPAWN_Z ] );
	
	if ( isStripper )
	    SetPlayerSpecialAction( playerid, SPECIAL_ACTION_DANCE4 );

	return 1;
}

#if RANDOM_PICKUPS == true

stock GenerateRandomPickup( pickupid )
{
	static const
		Float:pPickups[ ][ 3 ] = {
		{2437.8604,1988.5696,10.8203},
		{2571.1519,1974.9261,11.1641},
		{2558.6392,1788.0098,11.0234},
		{2546.5266,1852.1418,28.8935},
		{2862.1843,2429.7729,11.0690},
		{2816.0967,2203.6150,11.0234},
		{2598.9106,2084.5854,10.8130},
		{2586.4353,2179.0161,12.6400},
		{2644.7522,2259.0076,10.7886},
		{2563.3479,2303.3535,17.8222},
		{2545.9104,2349.5059,10.8133},
		{2366.9063,2358.4951,10.8203},
		{2262.2429,2564.9360,10.8203},
		{2501.6235,2773.1101,10.8203},
		{2383.8672,2758.0190,13.1060},
		{2175.9509,2710.7012,10.8203},
		{1949.1349,2762.2837,10.8265},
		{1766.4034,2736.1172,10.8359},
		{1486.9122,2772.7661,10.8203},
		{1439.8540,2615.4277,11.3926},
		{1362.6022,2571.8665,15.1141},
		{1849.6176,2582.9077,10.8203},
		{2033.2667,2257.8237,10.8203},
		{1912.1382,2288.3198,10.8203},
		{1972.9200,2363.7847,23.8516},
		{1890.2573,2446.1943,11.1782},
		{1522.7343,2376.6497,10.8203},
		{1444.7299,2360.7417,10.8203},
		{1405.4734,2169.4221,16.8045},
		{1617.3038,1159.1689,14.2188},
		{1379.1497,989.1495,13.1138},
		{1349.2360,1085.9698,10.8203},
		{1084.2582,1073.6989,10.8359},
		{1117.8186,1408.9008,6.6328},
		{1109.5709,1696.5413,10.8203},
		{989.8010,1880.1495,11.3232},
		{1024.0314,2031.0432,11.2474},
		{982.4949,2160.6301,10.8203},
		{774.1158,1880.3998,8.0957},
		{968.2064,1702.5868,8.8581},
		{1301.4205,1568.8733,10.8203},
		{1622.4720,1815.7813,10.8203},
		{1499.5039,2029.3578,14.7396},
		{1785.4751,2070.1699,10.8706},
		{1764.0997,1686.9297,9.2811},
		{1676.7413,1166.1119,10.8203},
		{1725.5493,968.4559,10.8203},
		{1625.1100,685.9510,10.8203},
		{1680.3375,745.4524,10.8203},
		{1483.9822,689.4680,10.8841},
		{1481.1765,750.9378,29.0853},
		{2136.3694,1088.2932,10.8274},
		{2165.7761,1262.9464,10.8203},
		{2806.9346,892.1949,11.3764},
		{2213.5178,940.8750,10.8203},
		{2604.1526,815.4988,10.8281},
		{2575.2195,715.9464,14.7396},
		{2540.7114,1123.5858,14.2705},
		{2498.4138,1131.9657,14.2705},
		{2510.2927,1549.4790,10.8203},
		{1969.5043,1639.1663,12.2422},
		{2001.6171,1534.1042,27.5888},
		{1935.2338,1557.2640,10.8203},
		{1974.7568,1561.0592,10.3397},
		{2044.1951,1821.0612,11.5655},
		{2103.9448,1979.1014,10.8203},
		{2082.5208,2176.6394,10.8203},
		{2160.4792,2113.1504,18.0782},
		{2178.6035,1968.4901,10.8203},
		{2304.1729,1785.1412,16.4524},
		{2435.2104,1663.0289,15.6398},
		{2260.9387,1398.2898,42.8203},
		{2323.9622,1261.1873,67.4688},
		{1921.8706,963.9921,10.8203},
		{1951.5463,669.3956,10.8203},
		{2099.0942,1683.2894,13.0060},
		{2153.9978,1751.7538,11.0469},
		{1914.0679,2185.9292,11.1250},
		{1908.6382,2106.1858,10.8203},
		{1485.9313,2180.0435,11.0234}//
	};
	
	static const
		rPickupMDL[ ] = {
			321, 322, 323, 324, 336,
			342, 343, 344, 346, 347,
			348, 349, 350, 351, 352,
			353, 355, 356, 357, 358,
			366, 372, 1240, 1242
		};

	new r = random( sizeof( pPickups ) );

	randPickups[ pickupid ] = CreatePickup( rPickupMDL[ random( sizeof( rPickupMDL ) ) ], DEFAULT_PICKUP_TYPE, pPickups[ r ][ 0 ], pPickups[ r ][ 1 ], pPickups[ r ][ 2 ] );
}
#endif

//******************************************************************************
//	Commands
//******************************************************************************

#if VERSION_LITE == false

dcmd_territory( playerid, params[ ] )
{
	new
		zoneid = pData[ playerid ][ P_GANG_ZONE ];
	
	if ( zoneid == INVALID_GANG_ZONE )
	    return SendError( playerid, "You must be in a gang zone to use this command." );

	new
		szInfoMsg[ 128 ];
    
	if ( params[ 0 ] == '\0' || !strcmp( params, "about", true, 5 ) )
	{
		new
			iZoneOwner = gZones[ zoneid ][ G_ZONE_OWNER ];
			
		if ( iZoneOwner == INVALID_GANG_ID )
			szInfoMsg = "None";
			
		else
			strcpy( szInfoMsg, gData[ iZoneOwner ][ G_NAME ] );
		    
		SendClientMessage( playerid, COLOR_GREEN, "Territory Information:" );
		
		format	(
					szInfoMsg, sizeof( szInfoMsg ), "* Owner -> %s (%d) .. Zone ID -> %d",
					szInfoMsg,
					iZoneOwner,
					zoneid
				);

		SendClientMessage( playerid, COLOR_YELLOW, szInfoMsg );
		
		return 1;
	}
	
	else if ( IsPlayerAdmin( playerid ) )
	{
		if ( !strcmp( params, "setowner", true, 8 ) )
	    {
			if ( params[ 9 ] == '\0' || !IsNumeric( params[ 9 ] ) )
	            return SendError( playerid, "/territory setowner [gang]" );

			new
				newOwner = strval( params[ 9 ] );
				
			// If timerid for EndGangWar in this zoneid
			// is valid then kill the timer and set it to 0 (invalid).
			if ( gZones[ zoneid ][ G_ZONE_TIMER ] )
			{
				KillTimer( gZones[ zoneid ][ G_ZONE_TIMER ] );
				
				gZones[ zoneid ][ G_ZONE_TIMER ] = 0;
			}
			
			// If there is no-one in the winning gang then reset gangzone to defaults.
			if ( !IsValidGang( newOwner ) )
			{
				loopPlayers( pID )
				{
					if ( pData[ pID ][ P_GANG_ZONE ] == zoneid )
					{
						TextDrawHideForPlayer( pID, gZones[ zoneid ][ G_ZONE_TEXT ] );
						TextDrawShowForPlayer( pID, TEXT_NoZoneOwner );
					}
				}
				
				gZones[ zoneid ][ G_ZONE_OWNER ] = INVALID_GANG_ID;
				gZones[ zoneid ][ G_ZONE_COLOR ] = COLOR_ZONE_DEFAULT;
				gZones[ zoneid ][ G_ZONE_TEXT ]	 = TEXT_NoZoneOwner;
			}
			
			else if ( gZones[ zoneid ][ G_ZONE_OWNER ] != newOwner )
			{
				// Set the zone status to the new winners.
				
				loopPlayers( pID )
				{
					if ( pData[ pID ][ P_GANG_ZONE ] == zoneid )
					{
						TextDrawHideForPlayer( pID, gZones[ zoneid ][ G_ZONE_TEXT ] );
						TextDrawShowForPlayer( pID, gData[ newOwner ][ G_ZONE_TEXT ] );
					}
				}
				
				gZones[ zoneid ][ G_ZONE_OWNER ]	= newOwner;
				gZones[ zoneid ][ G_ZONE_COLOR ]	= ( gData[ newOwner ][ G_COLOR ] & 0xFFFFFF00 ) | 0x80;
				gZones[ zoneid ][ G_ZONE_TEXT ]		= gData[ newOwner ][ G_ZONE_TEXT ];
			}
			
 			// Loop through all players and check if they're in the gang zone, if they
			// are then hide the current zone text.
			
			// Stop the flashing of zones now that the war has ended.
			if ( gZones[ zoneid ][ G_ZONE_WAR ] )
				GangZoneStopFlashForAll( zoneid );

			// Show the new gang zone colour for all..
			GangZoneHideForAll( zoneid );
		 	GangZoneShowForAll( zoneid, gZones[ zoneid ][ G_ZONE_COLOR ] );

		 	// Officially set the war to off.
			gZones[ zoneid ][ G_ZONE_WAR ] = 0;
			
			if ( newOwner == INVALID_GANG_ID )
				szInfoMsg = "Unoccupied";

			else
				strcpy( szInfoMsg, gData[ newOwner ][ G_NAME ] );
				
			format	(
						szInfoMsg, sizeof( szInfoMsg ), "* Territory owner set to %s (%d).",
						szInfoMsg,
						newOwner
					);

			SendClientMessage( playerid, COLOR_GREEN, szInfoMsg );
			
			return 1;
		}
		
		return SendUsage( playerid, "/territory [about/setowner] [gangid]" );
	}
	
	return SendUsage( playerid, "/territory [about]" );
}
#endif

#if ADMIN_SPAWN_COMMAND == true
dcmd_as( playerid, params[ ] )
{
	new
		spawn = 1,
	    iVehicleID = GetPlayerVehicleID( playerid );
	
	if ( IsNumeric( params ) )
	    spawn = strval( params );

	pData[ playerid ][ P_ADMIN_SPAWN ] = 1;
	
	switch( spawn )
	{
	    case 2:		SetSpawnInfo( playerid, playerid, 217, 2170.1453, 1677.9929, 20.3906, 90.0000, 24, 999999, 28, 999999, 31, 999999 );
	    case 3:		SetSpawnInfo( playerid, playerid, 141, 2170.1453, 1677.9929, 20.3906, 90.0000, 24, 999999, 28, 999999, 31, 999999 );
	    case 4: 	SetSpawnInfo( playerid, playerid, GetPlayerSkin( playerid ), 2170.1453, 1677.9929, 20.3906, 90.0000, 24, 999999, 28, 999999, 31, 999999 );
	    case 5: 	SetSpawnInfo( playerid, playerid, GetPlayerSkin( playerid ), 2170.1453, 1677.9929, 20.3906, 90.0000, 24, 999999, 28, 999999, 31, 999999 );
	    case 6:     SetSpawnInfo( playerid, playerid, 93, 2170.1453, 1677.9929, 20.3906, 90.0000, 24, 999999, 28, 999999, 31, 999999 );
	    default: 	SetSpawnInfo( playerid, playerid, 217, 2170.1453, 1677.9929, 20.3906, 90.0000, 24, 999999, 28, 999999, 31, 999999 );
	}

	if ( spawn != 5 )
		SetPlayerColor( playerid, 0xFFFFFFFF );

	if ( iVehicleID )
	{
	    RemovePlayerFromVehicle( playerid );
		SetVehicleToRespawn( iVehicleID );
	}
	
	SpawnPlayer( playerid );
	
	return 1;
}

#endif

dcmd_mods( playerid, params[] )
{
	#pragma unused params
	
	new
		szString[ 128 ] = "* ",
		szName	[ MAX_PLAYER_NAME ],
		iCnt, iModCnt;

	SendClientMessage( playerid, COLOR_RED, "Moderators:" );
	
	loopPlayers( i )
	{
	    if ( pData[ i ][ P_LEVEL ] == _:P_LEVEL_MOD )
	    {
	        iCnt	++;
	        iModCnt	++;
	        
			GetPlayerName( i, szName, MAX_PLAYER_NAME );
			format( szString, sizeof( szString ), "%s%s (%d), ", szString, szName, i );
			
			if ( iCnt >= 4 )
			{
			    SendClientMessage( playerid, COLOR_ORANGE, szString );
			    
			    szString= "* ";
			    iCnt	= 0;
			}
	    }
	}
	
	if ( iCnt )
	    SendClientMessage( playerid, COLOR_ORANGE, szString );

	if ( iModCnt != 1 )
		format( szString, sizeof( szString ), "There are %d moderators online.", iModCnt );
	else
	    szString = "There is 1 moderator online.";
	
	SendClientMessage( playerid, COLOR_WHITE, szString );
	
	return 1;
}

dcmd_admins( playerid, params[] )
{
	#pragma unused params
	
	new
		szString[ 128 ] = "* ",
		szName	[ MAX_PLAYER_NAME ],
		iCnt,	iAdminCnt;

	SendClientMessage( playerid, COLOR_RED, "Administrators:" );

	loopPlayers( i )
	{
	    if ( pData[ i ][ P_LEVEL ] >= _:P_LEVEL_ADMIN || IsPlayerAdmin( i ) )
	    {
	        iCnt		++;
	        iAdminCnt	++;

			GetPlayerName( i, szName, MAX_PLAYER_NAME );
			format( szString, sizeof( szString ), "%s%s (%d), ", szString, szName, i );

			if ( iCnt >= 4 )
			{
			    SendClientMessage( playerid, COLOR_ORANGE, szString );
			    
				szString= "* ";
			    iCnt	= 0;
			}
	    }
	}

	if ( iCnt )
	    SendClientMessage( playerid, COLOR_ORANGE, szString );

	if ( iAdminCnt != 1 )
		format( szString, sizeof( szString ), "There are %d administrators online.", iAdminCnt );
	else
	    szString = "There is 1 administrator online.";
	    
	SendClientMessage( playerid, COLOR_WHITE, szString );

	return 1;
}

stock dcmd_do( playerid, params[ ] )
{
	new
		szPrimaryCmd[128], szSecondaryCmd[128], iPlayerID = INVALID_PLAYER_ID, iAmount;

	if ( sscanf( params, "ssui", szPrimaryCmd, szSecondaryCmd, iPlayerID, iAmount ) || !szPrimaryCmd[0] || !szSecondaryCmd[0] || iPlayerID == INVALID_PLAYER_ID )
		return SendUsage( playerid, "/do [gbank/bank/bounty] [set/add/take] [name/id] [amount]" );

	if ( !strcmp( szPrimaryCmd, "bank", true ) )
	{
	    if ( !strcmp( szSecondaryCmd, "set", true, 3 ) )
	        pData[ iPlayerID ][ P_BANK ] = iAmount;
		else if ( !strcmp ( szSecondaryCmd, "add", true, 3 ) )
		    pData[ iPlayerID ][ P_BANK ] += iAmount;
    	else if ( !strcmp ( szSecondaryCmd, "take", true, 4 ) )
		    pData[ iPlayerID ][ P_BANK ] -= iAmount;
		else
		    return SendUsage( playerid, "/do bank [set/add/take] [name/id] [amount]" );

		GetPlayerName( iPlayerID, szPrimaryCmd, MAX_PLAYER_NAME );
		format( szPrimaryCmd, sizeof( szPrimaryCmd ), "* You have changed %s's (%d) personal bank to $%d.", szPrimaryCmd, iPlayerID, pData[ iPlayerID ][ P_BANK ] );
		SendClientMessage( playerid, COLOR_ORANGE, szPrimaryCmd );

		return 1;
	}

	else if ( !strcmp( szPrimaryCmd, "gbank", true, 5 ) )
	{
	    if ( pData[ iPlayerID ][ P_GANG_ID ] == INVALID_GANG_ID )
	        return SendError( playerid, "The player must be in a gang to edit funds from their gang!" );

	    if ( !strcmp( szSecondaryCmd, "set", true, 3 ) )
	        gData[ pData[ iPlayerID ][ P_GANG_ID ] ][ G_BANK ] = iAmount;
		else if ( !strcmp ( szSecondaryCmd, "add", true, 3 ) )
		    gData[ pData[ iPlayerID ][ P_GANG_ID ] ][ G_BANK ] += iAmount;
		else if ( !strcmp ( szSecondaryCmd, "take", true, 4 ) )
			gData[ pData[ iPlayerID ][ P_GANG_ID ] ][ G_BANK ] -= iAmount;
		else
		    return SendUsage( playerid, "/do gbank [set/add/take] [name/id] [amount]" );

		GetPlayerName( iPlayerID, szPrimaryCmd, MAX_PLAYER_NAME );
		format( szPrimaryCmd, sizeof( szPrimaryCmd ), "* You have changed %s's (%d) gang bank to $%d.", szPrimaryCmd, iPlayerID, gData[ pData[ iPlayerID ][ P_GANG_ID ] ][ G_BANK ] );
		SendClientMessage( playerid, COLOR_ORANGE, szPrimaryCmd );

		return 1;
	}

	else if ( !strcmp( szPrimaryCmd, "bounty", true, 6 ) )
	{
	    if ( !strcmp( szSecondaryCmd, "set", true, 3 ) )
	        pData[ iPlayerID ][ P_BOUNTY ] = iAmount;
		else if ( !strcmp ( szSecondaryCmd, "add", true, 3 ) )
		    pData[ iPlayerID ][ P_BOUNTY ] += iAmount;
    	else if ( !strcmp ( szSecondaryCmd, "take", true, 4 ) )
			pData[ iPlayerID ][ P_BOUNTY ] -= iAmount;
		else
		    return SendUsage( playerid, "/do bounty [set/add/take] [name/id] [amount]" );

		GetPlayerName( iPlayerID, szPrimaryCmd, MAX_PLAYER_NAME );
		format( szSecondaryCmd, sizeof( szSecondaryCmd ), "* You have changed %s's (%d) bounty to $%d.", szPrimaryCmd, iPlayerID, pData[ iPlayerID ][ P_BOUNTY ] );
		SendClientMessage( playerid, COLOR_ORANGE, szSecondaryCmd );

		if ( ( sHighBountyPlayer == INVALID_PLAYER_ID || pData[ iPlayerID ][ P_BOUNTY ] > pData[ sHighBountyPlayer ][ P_BOUNTY ] ) && pData[ iPlayerID ][ P_BOUNTY ] && iPlayerID != sHighBountyPlayer )
		{
		    new
				OldBountyID = sHighBountyPlayer;

            sHighBountyPlayer = iPlayerID;

			format( szSecondaryCmd, sizeof( szSecondaryCmd ), "* %s (%d) has the highest bounty ($%d). Look for the ORANGE blip.", szPrimaryCmd, sHighBountyPlayer, pData[ sHighBountyPlayer ][ P_BOUNTY ] );
			SendClientMessageToAll( COLOR_ORANGE, szSecondaryCmd );

			if ( sHighBountyPlayer != sRhinoOwner )
				SetPlayerColor( sHighBountyPlayer, COLOR_ORANGE );

			if ( OldBountyID != INVALID_PLAYER_ID && OldBountyID != sRhinoOwner )
			{

				if ( !IsPlayerInAnyGang( OldBountyID ) )
					SetPlayerColor( OldBountyID, setAlpha( pColors[ OldBountyID ], 0x40 ) );

				else
				{
				    // Set the old bountyid's colour to his normal colour...

					SetPlayerColor( OldBountyID, setAlpha( gData[ pData[ OldBountyID ][ P_GANG_ID ] ][ G_COLOR ], 0x40 ) );

					for ( new memberid = 0; memberid < gData[ pData[ OldBountyID ][ P_GANG_ID ] ][ G_TOTALS ]; memberid++ )
					{
						if ( IsPlayerConnected( gData[ pData[ OldBountyID ][ P_GANG_ID ] ][ G_MEMBERS ][ memberid ] ) && sRhinoOwner != gData[ pData[ OldBountyID ][ P_GANG_ID ] ][ G_MEMBERS ][ memberid ] && sHighBountyPlayer != gData[ pData[ OldBountyID ][ P_GANG_ID ] ][ G_MEMBERS ][ memberid ] )
						{
							// If the players i and playerid are in the same gang then set the marker to the gang colour
							// with an alpha of 0xAA.

							SetPlayerMarkerForPlayer( gData[ pData[ OldBountyID ][ P_GANG_ID ] ][ G_MEMBERS ][ memberid ], OldBountyID, setAlpha( gData[ pData[ OldBountyID ][ P_GANG_ID ] ][ G_COLOR ], 0xAA ) );
							SetPlayerMarkerForPlayer( OldBountyID, gData[ pData[ OldBountyID ][ P_GANG_ID ] ][ G_MEMBERS ][ memberid ], setAlpha( gData[ pData[ OldBountyID ][ P_GANG_ID ] ][ G_COLOR ], 0xAA ) );
						}
					}
				}
			}
		}

		return 1;
	}

	else
		return SendUsage( playerid, "/do [gbank/bank/bounty] [set/add/take] [name/id] [amount]" );
}

dcmd_commands(playerid, params[])
{
	if (!params[0])
	{
		SendClientMessage(playerid, COLOR_YELLOW, "" #SZ_GAMEMODE_L_NAME  " (" #SZ_GAMEMODE_S_NAME ")  Commands:");
		SendClientMessage(playerid, COLOR_YELLOW, "(Player:0+) /pm /nick /login /email /register /password /nothing /commands");
		SendClientMessage(playerid, COLOR_YELLOW, "(Player:0+) /me /buy /tips /sell /help /gang /bank /strip /stats");
		SendClientMessage(playerid, COLOR_YELLOW, "(Player:0+) /gbank /gangs /hitman /bounty /player /report /balance");
		SendClientMessage(playerid, COLOR_YELLOW, "(Player:0+) /credits /gbalance /bounties /givecash /withdraw /objective");
		SendClientMessage(playerid, COLOR_YELLOW, "(Player:0+) /gwithdraw /buyweapon /territory /weaponlist /properties");
		
		if ( IsPlayerAdmin( playerid ) || pData[ playerid ][ P_LEVEL ] >= _:P_LEVEL_MOD )
		{
			SendClientMessage(playerid, COLOR_YELLOW, "(Moderator:1+) /mods /kick /mute /admins /unmute /mutelist");
			
			if (pData[playerid][P_LEVEL] >= _:P_LEVEL_ADMIN)
			{
				SendClientMessage(playerid, COLOR_YELLOW, "(Admin:2+) /as /do /ban /unban /muteall /unmuteall");
				
				if (pData[playerid][P_LEVEL] >= _:P_LEVEL_SERVER)
					SendClientMessage(playerid, COLOR_YELLOW, "(Server:3+) /drop /setname /setlevel");
			}
		}
	}
	else	dcmd_commands(playerid, ""); // Done like this as I may expand on the command.
}

dcmd_drop( playerid, params[ ] )
{
	new
		dropid;

	if ( !( pData[ playerid ][ P_LEVEL ] >= _:P_LEVEL_SERVER || IsPlayerAdmin( playerid ) ) )
	    return SendError( playerid, "You must be at SERVER level or an RCON admin to use this command." );
	    
	if ( !pData[ playerid ][ P_DROP_WARNED ] )
	{
	    pData[ playerid ][ P_DROP_WARNED ] = 1;
	    
		SendClientMessage( playerid, COLOR_RED, "WARNING: Dropping an account is irreversible. Type /drop [playerid] again to confirm." );

	    return 1;
	}
	
	if ( params[0] == '\0' || !IsNumeric( params ) )
	    return SendUsage( playerid, "/drop [playerid]" );
	    
	dropid = strval( params );

	if ( !IsPlayerConnected( dropid ) || !pData[ dropid ][ P_REGISTERED ] || !pData[ dropid ][ P_LOGGED_IN ] )
	    return SendError( playerid, "The account you wish the drop must be registered and logged in to use this command." );
	    
	if ( pData[ dropid ][ P_ACCOUNT_BAN ] )
	    return SendError( playerid, "You can't drop a banned account." );
	    
	new
		DB:Database = db_open( SZ_SQLITE_DB ),
		pName[ MAX_PLAYER_NAME ],
		tString[ 128 ];
			
	printf( "> %d tried to drop %d's account.", playerid, dropid );
        
	if ( Database )
	{
		GetPlayerName( dropid, pName, MAX_PLAYER_NAME );

	    if ( DeleteAccount( Database, pName ) )
	    {
			pData[ dropid ][ P_REGISTERED ]		= 0;
			pData[ playerid ][ P_DROP_WARNED ]	= 0;
	        
	        GetPlayerName( playerid, tString, MAX_PLAYER_NAME );
	        format( tString, sizeof( tString ), "(AdminMsg) %s (ID:%d) has dropped %s (ID:%d)'s account.", tString, playerid, pName, dropid );
	        SendClientMessageToAdmins( COLOR_ORANGE, tString );
		}
		else
			SendError( playerid, "Account deletion failed." );
		
		db_close( Database );
			
		return 1;
	}
	else return !print( "[ERROR] NO DATABASE!" );
}

dcmd_password( playerid, params[ ] )
{
	if ( params[ 0 ] == '\0' )
	    return SendUsage( playerid, "/password [old_password] [new_password]" );
	    
	if ( !pData[ playerid ][ P_REGISTERED ] && !pData[ playerid ][ P_LOGGED_IN ] )
	    return SendError( playerid, "You must be registered and logged in to use this command." );

	new tString	[ 128 ],
	    pName	[ MAX_PLAYER_NAME ],
		idx;

	tString = strtok( params, idx );

	if ( !strlen( params[ idx + 1 ] ) )
	    return SendUsage( playerid, "/password [old_password] [new_password]" );

	GetPlayerName( playerid, pName, MAX_PLAYER_NAME );
	
	printf( "%s [ID:%d] typed password command.", pName, playerid );

	new
		DB:Database = db_open( SZ_SQLITE_DB );

	if ( Database )
	{
		if ( SetUserPassword( Database, pName, tString, params[ idx + 1 ] ) )
		{
		    format( tString, sizeof( tString ), "You have successfully changed your password from %s to %s.", tString, params[ idx + 1 ] );
		    SendClientMessage( playerid, COLOR_GREEN, tString );
		}
		else
		{
		    format( tString, sizeof( tString ), "ERROR: There was an error changing your password to %s.", params[ idx + 1 ] );
		    SendClientMessage( playerid, COLOR_RED, tString );
		    SendClientMessage( playerid, COLOR_RED, "Please make sure your old password is correct." );
		}

	    db_close( Database );

		return 1;
	}
	else
	    return !print( "ERROR: NO DATABASE!" );

}

dcmd_email( playerid, params[ ] )
{
	if ( params[ 0 ] == '\0' )
	    return SendUsage( playerid, "/email [new_email]" );

	if ( !pData[ playerid ][ P_LOGGED_IN ] )
		return SendError( playerid, "You must be registered and logged in to use this command." );
	new
	    idx;
	    

	while ( params[ idx ] != 0 )
	{

		if
		(
			isalnum( params[ idx ] ) ||
			params[ idx ] == '_' || params[ idx ] == '[' || params[ idx ] == ']' ||
			params[ idx ] == '-' || params[ idx ] == '+' || params[ idx ] == '.' || params[ idx ] == '@'
		)	idx++;
		
		else
			return SendError( playerid, "Email can only have the characters: 0-9, A-Z, a-z, [, ], _, -, +, . and @." );
	}
	
	new
		DB:Database = db_open( SZ_SQLITE_DB ),
	    szName  [ MAX_PLAYER_NAME ],
	    szString[ 128 ];

	GetPlayerName	( playerid, szName, MAX_PLAYER_NAME );
	printf			( "%s [ID:%d] typed change email command (params: %s).", szName, playerid, params );
	
	if ( Database )
	{
	    if ( SetUserEmail( Database, szName, params ) )
	    {
	        format				( szString, sizeof( szString ),	"You have successfully changed your email to %s.",		params );
	        SendClientMessage	( playerid, COLOR_GREEN,szString );
	    }
	    else
	    {
	        format				( szString, sizeof( szString ),	"ERROR: There was an error changing your email to %s.",	params );
	        SendClientMessage	( playerid, COLOR_RED,	szString );
	    }
	    
	    db_close( Database );
	    
	    return 1;
	}
	else
	    return print( "ERROR: NO DATABASE!" );
}

dcmd_nick( playerid, params[ ] )
{
	if ( params[ 0 ] == '\0' )
	    return SendUsage( playerid, "/nick [login/register/password/drop/setname/setlevel]" );
	    
	if ( !strcmp( params, "drop", true, 4 ) )
	    return dcmd_drop( playerid, params[ 5 ] );
	    
	if ( !strcmp( params, "login", true, 5 ) )
	    return dcmd_login( playerid, params[ 6 ] );
	    
	if ( !strcmp( params, "email", true, 5 ) )
	    return dcmd_email( playerid, params[ 6 ] );
	    
	if ( !strcmp( params, "setname", true, 7 ) )
	    return dcmd_setname( playerid, params[ 8 ] );
	    
	if ( !strcmp( params, "password", true, 8 ) )
	    return dcmd_password( playerid, params[ 9 ] );
	    
	if ( !strcmp( params, "setlevel", true, 8 ) )
	    return dcmd_setlevel( playerid, params[ 9 ] );

	return 0;
}

dcmd_me( playerid, params[ ] )
{
	if( params[ 0 ] == '\0' )
		return SendUsage( playerid, "/me [action]" );
	else
	{
	    new
			mString[ 128 ];

	    GetPlayerName( playerid, mString, MAX_PLAYER_NAME );
	    format( mString, sizeof( mString ), "* %s %s", mString, params );
		SendClientMessageToAll( 0xFF44DDFF, mString );

		format( mString, sizeof( mString ), "[me] %d %s", playerid, mString );
		add_log( mString );

		return 1;
	}
}

dcmd_setlevel( playerid, params[ ] )
{
	if ( !IsPlayerAdmin( playerid ) && pData[ playerid ][ P_LEVEL ] < _:P_LEVEL_SERVER )
	    return SendError( playerid, "You must be at server level or higher to use this command." );
	    
	if ( params[ 0 ] == '\0' )
	    return SendUsage( playerid, "/setlevel [id] [level]" );

	new tName[ MAX_PLAYER_NAME ],
	    tString[ 128 ],
	    idx;

    printf( "[ID:%d] typed setlevel command.", playerid );
    
	tName = strtok( params, idx );
	 
	if ( IsNumeric( tName ) )
	{
		new levelid = strval( tName );

		if ( !IsPlayerConnected( levelid ) )
			return SendError( playerid, "That player is not connected!" );

		GetPlayerName( levelid, tName, MAX_PLAYER_NAME );

		if ( !strlen( params[ idx + 1 ] ) || !IsNumeric( params[ idx + 1 ] ) )
		    return SendUsage( playerid, "/setlevel [id] [level]" );

		new
		    level       = strval( params[ idx + 1 ] );

		// If the level entered is greater-than or equal to the commanders current level AND
		// the player is NOT admin.

		if ( ( !IsPlayerAdmin( playerid ) && level >= pData[ playerid ][ P_LEVEL ] ) )
		    return SendError( playerid, "You cannot set this players level higher than your own." );

		if ( pData[ playerid ][ P_LEVEL ] <= pData[ levelid ][ P_LEVEL ] && !IsPlayerAdmin( playerid ) )
			return SendError( playerid, "You cannot modify a player level who has a level that is the same or higher level as you." );
		
		new
			DB:Database	= db_open( SZ_SQLITE_DB );
			
		if ( Database )
		{
		    new
				aName[ MAX_PLAYER_NAME ];
		    
		    if ( SetUserLevel( Database, tName, level ) )
		    {
		        GetPlayerName( playerid, aName, MAX_PLAYER_NAME );
		        
		        format( tString, sizeof( tString ), "* %s (ID: %d) has set your level to %d.", aName, playerid, level );
				SendClientMessage( levelid, COLOR_YELLOW, tString );
		        
				format( tString, sizeof( tString ), "(AdminMsg) %s (ID: %d) has had their level set to %d by %s (ID: %d).", tName, levelid, level, aName, playerid );
				SendClientMessageToAdmins( COLOR_ORANGE, tString );
				
				pData[ levelid ][ P_LEVEL ] = level;
		    }
		    else
				SendError( playerid, "There was an error setting the players level (are they registered?)." );
		        
			db_close( Database );
			
			return 1;
		}
		else return printf( "[ERROR] NO DATABASE!" );
	}
	else return SendUsage( playerid, "/setlevel [id] [level]" );
}

dcmd_setname( playerid, params[ ] )
{
	if ( !IsPlayerAdmin( playerid ) && pData[ playerid ][ P_LEVEL ] < _:P_LEVEL_SERVER )
		return SendError( playerid, "You must be at admin level or higher to use this." );

	if ( params[ 0 ] == '\0' )
	    return SendUsage( playerid, "/setname [id] [new_name]" );

	new
		tName[ MAX_PLAYER_NAME ],
		tString[ 128 ],
		DB:Database,
		idx;

	printf( "[ID:%d] typed setname command.", playerid );

	tName = strtok( params, idx );

	if ( IsNumeric( tName ) )
	{
		new
			nameid	= strval( tName ),
			namelen	= strlen( params[ idx + 1 ] );

		if ( !IsPlayerConnected( nameid ) )
			return SendError( playerid, "That player is not connected!" );

		GetPlayerName( nameid, tName, MAX_PLAYER_NAME );

		if ( !namelen )
			return SendUsage( playerid, "/setname [id] [new_name]" );

		if ( namelen < 3 || namelen > 16 )
			return SendError( playerid, "The new name must be less than 16 characters and greater than 2." );

		namelen += ( idx + 1 );
		
		for ( new i = idx + 1; i < namelen; i++ )
		{
		    if ( isalnum( params[ i ] ) || params[ i ] == '_' || params[ i ] == '[' || params[ i ] == ']' )
		        continue;
			else
				return SendError( playerid, "Name can only have the characters: 0-9, A-Z, a-z, [, ] and _" );
		}

		Database = db_open( SZ_SQLITE_DB );

		if ( Database )
		{
			if ( SetUserName( Database, tName, params[ idx + 1 ] ) )
			{
				new
					aName[ MAX_PLAYER_NAME ];

				GetPlayerName( playerid, aName, MAX_PLAYER_NAME );
				SetPlayerName( nameid, params[ idx + 1 ] );
				
				format( tString, sizeof( tString ), "(Announcement) %s (ID:%d) has set %s's (ID:%d) name to %s.", aName, playerid, tName, nameid, params[ idx + 1 ] );
				SendClientMessageToAdmins( COLOR_ORANGE, tString );

				format( tString, sizeof( tString ), "* Admin %s (ID:%d) has set your username to %s.", tName, playerid, params[ idx + 1 ] );
				SendClientMessage( nameid, COLOR_ORANGE, tString );
			}
			else SendError( playerid, "This player is not registered or the new name is already registered!" );
			
			db_close( Database );
			
			return 1;
		}
		
		return printf( "[ERROR] NO DATABASE!" );
	}
	else
		return SendUsage( playerid, "/setname [id] [new_name]" );
/*
	else
	{
		if ( !strlen( params[ idx + 1 ] ) )
	    	return SendUsage( playerid, "/setname [id/name] [new_name]" );

		Database = db_open( SZ_SQLITE_DB );

		if ( Database )
		{
			if ( SetUserName( Database, tName, params[ idx + 1 ] ) )
			{
				new
					aName[ MAX_PLAYER_NAME ];

			    GetPlayerName( playerid, aName, MAX_PLAYER_NAME );
				format( tString, sizeof( tString ), "(AdminMsg) %s (ID: %d) has set %s's name to %s.", tName, params[ idx + 1 ] );
				SendClientMessageToAdmins( COLOR_ORANGE, tString );
			}
			else
				SendError( playerid, "This player is not registered!" );
				
			db_close( Database );
			
			return 1;
		}
		else return !printf( "[ERROR] NO DATABASE!" );
	}
	*/
}

dcmd_login( playerid, params[ ] )
{
	if ( params[ 0 ] == '\0' )
		return SendUsage( playerid, "/login [password]" );

	if ( !pData[ playerid ][ P_FULLY_CONNECTED ] )
	    return SendError( playerid, "You have not fully connected yet. Please login at class selection." );
	    
	new
		DB:Database,
		pName[ MAX_PLAYER_NAME ],
		tmpString[ 128 ];

	GetPlayerName( playerid, pName, MAX_PLAYER_NAME );
	
	printf( "%s [ID:%d] typed login command.", pName, playerid );

	if ( pData[ playerid ][ P_LOGGED_IN ] )
		return SendError( playerid, "You are already logged in." );
		
	if ( !pData[ playerid ][ P_REGISTERED ] )
		return SendError( playerid, "You must register this account before logging in." );

	Database
		= db_open( SZ_SQLITE_DB );

	if ( Database )
	{
		if ( LoginUser( Database, playerid, pName, params ) )
		{
			format( tmpString, sizeof( tmpString ), "You have logged into your account (Level: %d, UserID: %d).", pData[ playerid ][ P_LEVEL ], pData[ playerid ][ P_USERID ] );
			SendClientMessage( playerid, COLOR_GREEN, tmpString );

			format( tmpString, sizeof( tmpString ), "Player %s (ID:%d) has logged in (Level: %d, UserID: %d).", pName, playerid, pData[ playerid ][ P_LEVEL ], pData[ playerid ][ P_USERID ] );
			SendClientMessageToAdmins( COLOR_ORANGE, tmpString );

			if ( pData[ playerid ][ P_SKIN ] != -1 )
			{
				SetSpawnInfo( playerid, playerid, pData[ playerid ][ P_SKIN ], 1958.3783, 1343.1572, 15.3746, 270.1425, 0, 0, 0, 0, 0, 0 );
				SpawnPlayer	( playerid );
			}
			else
			{
			    pData[ playerid ][ P_SEND_TO_CLASS_SELECT ] = 1;
			    
				SetSpawnInfo( playerid, playerid, 280, 1958.3783, 1343.1572, 15.3746, 270.1425, 0, 0, 0, 0, 0, 0 );
				SpawnPlayer	( playerid );
			}

			format	( tmpString, sizeof( tmpString ), "[login] %s %d %d %d", pName, playerid, pData[ playerid ][ P_USERID ], pData[ playerid ][ P_LEVEL ] );
			add_log	( tmpString );
		}
		
		else if ( pData[ playerid ][ P_LOGIN_ATTEMPTS ] > 5 )
			KickPlayer( Database, playerid, 1000, "Failed to login after 5 attempts." );
			
		else
			SendError( playerid, "Invalid password or non-registered name." );

		db_close( Database );

		return 1;
	}
	else return print( "[ERROR] NO DATABASE!" );
}

dcmd_register( playerid, params[ ] )
{
	if ( params[ 0 ] == '\0' )
	{
	    SendUsage( playerid, "/register [email] [password]" );
	    SendClientMessage( playerid, COLOR_YELLOW, "Make sure you enter a valid email for password retrieval." );
	    return 1;
	}

	new DB:Database,
	    idx,
	    pName		[ MAX_PLAYER_NAME ],
	    pEmail      [ 128 ],
	    tmpString	[ 128 ];

 	GetPlayerName( playerid, pName, MAX_PLAYER_NAME );
 	
 	printf( "%s [ID:%d] typed register command.", pName, playerid );
    
	while ( params[ idx ] == ' ' )
		idx++;
    
	while ( params[ idx ] != ' ' && params[ idx ] != '\0' )
    {
		if
		(
			isalnum( params[ idx ] ) ||
			params[ idx ] == '_' || params[ idx ] == '[' || params[ idx ] == ']' ||
			params[ idx ] == '-' || params[ idx ] == '+' || params[ idx ] == '.' || params[ idx ] == '@'
		)
		{
			pEmail[ idx ] = params[ idx ];
			idx++;
		}
		
		else
			return SendError( playerid, "Email can only have the characters: 0-9, A-Z, a-z, [, ], _, -, +, . and @." );
	}

	if ( !strlen( params[ idx + 1 ] ) )
	{
		SendUsage( playerid, "/register [email] [password]" );
		SendClientMessage( playerid, COLOR_YELLOW, "Make sure you enter a valid email for password retrieval." );
		
		return 1;
	}

	Database = db_open( SZ_SQLITE_DB );
	
	if ( Database )
	{
	    new
			pIP[ 16 ];
	    
	    GetPlayerIp( playerid, pIP, 16 );
	    
	    if ( IsIPRegistered( Database, pIP ) >= 3 )
			SendError( playerid, "You cannot register from the same IP more than 3 times." );
			
		else if ( RegisterUser( Database, playerid, pName, params[ idx + 1 ], pEmail ) )
		{
		    AC_GivePlayerMoney( playerid, 5000 );
		    
			format( tmpString, sizeof( tmpString ), "You have sucessfully registered the username %s. You gained $5000 for registering.", pName );
			SendClientMessage( playerid, COLOR_GREEN, tmpString );
			format( tmpString, sizeof( tmpString ), "UserID: %d, Level: %d, Email: %s, Password: %s", pData[ playerid ][ P_USERID ], pData[ playerid ][ P_LEVEL ], pEmail, params[ idx+ 1 ] );
			SendClientMessage( playerid, COLOR_YELLOW, tmpString );
			format( tmpString, sizeof( tmpString ), "(AdminMsg) %s (ID:%d) has registered their name [UserID: %d, Level: %d].", pName, playerid, pData[ playerid ][ P_USERID ], pData[ playerid ][ P_LEVEL ] );
			SendClientMessageToAdmins( COLOR_GREEN, tmpString );
			format( tmpString, sizeof( tmpString ), "[register] %s %d %d", pName, playerid, pData[ playerid ][ P_USERID ] );
			add_log( tmpString );
		}
		else
		{
			format( tmpString, sizeof( tmpString ), "ERROR: The username %s is already registered.", pName );
			SendClientMessage( playerid, COLOR_RED, tmpString );
		}
		
		db_close( Database );
		
		return 1;
	}
	else
		return print( "[ERROR] NO DATABASE!" );
}

dcmd_report( playerid, params[ ] )
{
	new
		tString[ 128 ],
		idx,
		reportid,
		DB:Database;

	tString = strtok( params, idx );

	if ( tString[ 0 ] == '\0' || !IsNumeric( tString ) || !strlen( params[ idx + 1 ] ) )
		return SendUsage( playerid, "/report [id] [reason]" );

	reportid = strval( tString );
	
	if ( !IsPlayerConnected( reportid ) )
		return SendError( playerid, "Player is not connected." );
		
	Database = db_open( SZ_SQLITE_DB );

	if ( Database )
	{
		if ( ReportPlayer( Database, reportid, playerid, params[ idx + 1 ] ) )
			SendClientMessage( playerid, COLOR_ORANGE, "You report has been sent to online moderators/admins." );
		else
			SendError( playerid, "There was an error sending your report. Please try again." );

		db_close( Database );
	}
	else print( "[ERROR] NO DATABASE!" );
	
	return 1;
}

dcmd_unban( playerid, params[ ] )
{
	new
		tString[ 128 ],
		DB:Database;

	if ( params[ 0 ] == '\0' )
	    return SendUsage( playerid, "/unban [name]" );

	Database = db_open( SZ_SQLITE_DB );
	
	if ( Database )
	{
	    GetPlayerName( playerid, tString, MAX_PLAYER_NAME );
	    
	    if ( UnbanPlayer( Database, params, tString ) )
	    {
	        format( tString, sizeof( tString ), "(AdminMsg) %s has unbanned %s.", tString, params );
	        SendClientMessageToAdmins( COLOR_ORANGE, tString );
	    }
	    else
			SendError( playerid, "Player is not registered." );
	        
		db_close( Database );
		
		return 1;
	}
	else return print( "[ERROR] NO DATABASE!" );
}

dcmd_ban( playerid, params[ ] )
{
	new
		tString[ 128 ],
		idx,
		banid,
		DB:Database;

	tString = strtok( params, idx );

	if ( tString[ 0 ] == '\0' || !IsNumeric( tString ) || !strlen( params[ idx + 1 ] ) )
		return SendUsage( playerid, "/ban [id] [reason]" );

	banid = strval( tString );
	
	if ( !IsPlayerConnected( banid ) )
	
		return SendError( playerid, "Player is not connected." );
	if ( pData[ playerid ][ P_LEVEL ] <= pData[ banid ][ P_LEVEL ] && !IsPlayerAdmin( playerid ) )
		return SendError( playerid, "You cannot ban a player who has a level that is the same or higher level than your own." );
		
	Database = db_open( SZ_SQLITE_DB );

	if ( Database )
	{
		if ( !BanPlayer( Database, banid, playerid, params[ idx + 1 ] ) )
			SendError( playerid, "There was an error banning. Please try again." );

		db_close( Database );

		return 1;
	}
	else return print( "[ERROR] NO DATABASE!" );
}

dcmd_kick( playerid, params[ ] )
{
	new
		tString[ 128 ],
		idx,
		kickid,
		DB:Database;

	tString = strtok( params, idx );

	if ( tString[ 0 ] == '\0' || !IsNumeric( tString ) || !strlen( params[ idx + 1 ] ) )
		return SendUsage( playerid, "/kick [id] [reason]" );

	kickid = strval( tString );
	
	if ( !IsPlayerConnected( kickid ) )
	    return SendError( playerid, "Player is not connected." );
	    
	Database = db_open( SZ_SQLITE_DB );

	if ( Database )
	{
		if ( !KickPlayer( Database, kickid, playerid, params[ idx + 1 ] ) )
			SendError( playerid, "There was an error kicking. Please try again." );

		db_close( Database );

		return 1;
	}
	else return print( "[ERROR] NO DATABASE!" );
}

dcmd_strip( playerid, params[ ] )
{
	#pragma unused params
	return SetPlayerSpecialAction( playerid, SPECIAL_ACTION_DANCE4 );
}

dcmd_player( playerid, params[ ] )
{
	new otherid = playerid, pString[ MAX_CLIENT_MSG ], pName[ MAX_PLAYER_NAME ];
	
	if ( strlen( params ) && IsNumeric( params ) )
	    otherid = strval( params );
	if ( !IsPlayerConnected( otherid ) )
		return SendError( playerid, "Player must be connected!" );

	GetPlayerName( otherid, pName, MAX_PLAYER_NAME );
	format( pString, sizeof( pString ), "(Stats): %s (ID:%d):", pName, otherid );
	SendClientMessage( playerid, COLOR_GREEN, pString );
	format( pString, sizeof( pString ), "(Money): Money -> $%d .. Bounty -> $%d", GetPlayerMoney( otherid ), pData[ otherid ][ P_BOUNTY ] );
	SendClientMessage( playerid, COLOR_YELLOW, pString );
	format( pString, sizeof( pString ), "(Kills/Deaths): Kills -> %d .. Deaths -> %d", pData[ otherid ][ P_KILLS ], pData[ otherid ][ P_DEATHS ] );

	if ( !pData[ otherid ][ P_DEATHS ] )
		format( pString, sizeof( pString ), "%s .. Kill Ratio -> N/A", pString );
	else
		format( pString, sizeof( pString ), "%s .. Kill Ratio -> %.2f", pString, floatdiv( pData[ otherid ][ P_KILLS ], pData[ otherid ][ P_DEATHS ] ) );
	
	SendClientMessage( playerid, COLOR_YELLOW, pString );
	
	format( pString, sizeof( pString ), "(Account): Online -> %d hours, %d minutes and %d seconds .. Registered -> %s .. Level -> %d",
		pData[ otherid ][ P_ONLINE_TICKS ] / 3600, ( pData[ otherid ][ P_ONLINE_TICKS ] / 60 ) % 60, ( pData[ otherid ][ P_ONLINE_TICKS ] ) % 60,
		( pData[ otherid ][ P_REGISTERED ] ? ( "Yes" ) : ( "No" ) ), pData[ otherid ][ P_LEVEL ]
	);
	
	SendClientMessage( playerid, COLOR_YELLOW, pString );
		
	if ( IsPlayerInAnyGang( otherid ) )
	{
		format( pString, sizeof( pString ), "(Gang): Name -> %s (%d) .. Position -> %d (%s)", gData[ pData[ otherid ][ P_GANG_ID ] ][ G_NAME ], pData[ otherid ][ P_GANG_ID ], pData[ otherid ][ P_GANG_POS ], pData[ otherid ][ P_GANG_POS ] ? ("Member") : ("Leader") );
		SendClientMessage( playerid, COLOR_CYAN, pString );
	}
	    
	return 1;

}

dcmd_stats( playerid, params[ ] )
	return dcmd_player( playerid, params );

dcmd_help( playerid, params[ ] )
{
	if ( params[ 0 ] == '\0' || !strcmp( params, "general", true, 7 ) )
	{
		SendClientMessage( playerid, COLOR_GREEN,	"" SZ_GAMEMODE_L_NAME " (" SZ_GAMEMODE_S_NAME ") - General Help" );
		SendClientMessage( playerid, COLOR_YELLOW,	"  " SZ_GAMEMODE_S_NAME " is a custom gamemode based off the ideas of Sintax and jax. It features gangs, properties," );
		SendClientMessage( playerid, COLOR_YELLOW,	"  deathmatch, banking and other various features." );
		SendClientMessage( playerid, COLOR_YELLOW,	"  To view other basic topics to get started then type the following commands:" );
		SendClientMessage( playerid, COLOR_YELLOW,	"  /help [topic], /commands [topic], /objective, /tips, /credits" );
		SendClientMessage( playerid, COLOR_GREEN,	"  Help Topics:" );
		SendClientMessage( playerid, COLOR_YELLOW,	"  general, gangs, accounts, weapons, bank, properties, bounties, territories" );
		
		if ( !random( 256 ) )
		{
			new
				iTalkCnt,
				iConversationID = INVALID_PLAYER_ID;

			loopPlayers( i )
			{
				if ( i != playerid )
				{
					iConversationID = i;
					iTalkCnt        = 1;
					
					break;
				}
			}

			if ( iTalkCnt )
			{
				SendPlayerMessageToAll( playerid, "You punk-ass bitch, punk-ass busta fool!" );
				SendPlayerMessageToAll( iConversationID, "I dunno what you just said, but I bought you some malt liqour to calm you down." );
				SendPlayerMessageToAll( playerid, "You a busta fool. Luckily, your not dead 'coz I'm also a pimp! Including you, I'll pimp anything! You hear me playa?" );
				SendPlayerMessageToAll( iConversationID, "Yes, I hear you, you'll pimp anything. But you know, it's kinda like my dream to sleep with housewives." );
				SendPlayerMessageToAll( playerid, "ARE YOU - DISSIN' - MY HOS, BITCH?" );
				SendPlayerMessageToAll( iConversationID, "Uh, no, no. Your hos are bitches, your hos are bitches. Look please, don't shoot me, homie." );
			}
		}
		
		return 1;
	}
	
	if ( !strcmp( params, "bank", true, 4 ) )
	{
	    SendClientMessage( playerid, COLOR_GREEN,   "Bank Help:" );
	    SendClientMessage( playerid, COLOR_YELLOW,  " Banks in " SZ_GAMEMODE_S_NAME " serve as an important feature for protecting your money," );
	    SendClientMessage( playerid, COLOR_YELLOW,  " this is because when you are killed you lose your money, if your money is banked" );
	    SendClientMessage( playerid, COLOR_YELLOW,  " then it will stay in the bank protected until you withdraw it. If you have an account then you can bank" );
		SendClientMessage( playerid, COLOR_YELLOW,  " your cash to an account for another play, read the \"accounts\" help topic for more information on accounts." );
		SendClientMessage( playerid, COLOR_YELLOW,  " You can share your banked using a gang bank, read the \"gangs\" topic for more information about gangs." );
		SendClientMessage( playerid, COLOR_GREEN,	"Bank Commands:" );
		SendClientMessage( playerid, COLOR_YELLOW,  " /bank, /withdraw, /balance, /gbank, /gwithdraw, /gbalance" );
		SendClientMessage( playerid, COLOR_RED,		"The bank system also has menu's that you can use instead of commands. You must be inside the 24/7" );
		SendClientMessage( playerid, COLOR_RED,		"convenience store checkpoint to use bank commands." );
		
		return 1;
	}
	
	if ( !strcmp( params, "gangs", true, 5 ) )
	{
	    SendClientMessage( playerid, COLOR_GREEN,   "Gangs Help:" );
	    SendClientMessage( playerid, COLOR_YELLOW,  " " SZ_GAMEMODE_S_NAME " has a gangs system that allows player to gang up with each other and work" );
		SendClientMessage( playerid, COLOR_YELLOW,  " together to kill other players and build up cash. You can use gangs to take over" );
		SendClientMessage( playerid, COLOR_YELLOW,  " territories, please read the \"territories\" topic in help for more information about territories." );
		SendClientMessage( playerid, COLOR_GREEN,	"Gangs Commands:" );
		SendClientMessage( playerid, COLOR_YELLOW,  " /gangs, /gang create, /gang join, /gang quit, /gang info, /gang kick," );
		SendClientMessage( playerid, COLOR_YELLOW,  " /gang invite, /gang setleader, /gbank, /gwithdraw, /gbalance" );
		
		return 1;
	}
	
	if ( !strcmp( params, "weapons", true, 7 ) )
	{
        SendClientMessage( playerid, COLOR_GREEN,   "Weapons Help:" );
        SendClientMessage( playerid, COLOR_YELLOW,  " Weapons are a vital tool for survival in " SZ_GAMEMODE_S_NAME ", all new players will" );
        SendClientMessage( playerid, COLOR_YELLOW,  " start with the standard \"Desert Eagle\". Once a player gains enough money they can" );
        SendClientMessage( playerid, COLOR_YELLOW,  " head off to Ammunation and purchase standard weapons OR they can purchase spawn weapons" );
        SendClientMessage( playerid, COLOR_YELLOW,  " which they will be given after death." );
		SendClientMessage( playerid, COLOR_GREEN,	"Weapons Commands:" );
		SendClientMessage( playerid, COLOR_YELLOW,  " /buyweapon, /weaponlist" );
		SendClientMessage( playerid, COLOR_RED,		"The weapon system also has menu's that you can use instead of commands. You must be inside the secondary" );
		SendClientMessage( playerid, COLOR_RED,		"Ammunation checkpoint to use these commands." );

		return 1;
	}
	
	if ( !strcmp( params, "bounties", true, 8 ) )
	{
		SendClientMessage( playerid, COLOR_GREEN,   "Bounties Help:" );
        SendClientMessage( playerid, COLOR_YELLOW,  " Got a player you have a grudge on for something? Want to start some competition?" );
		SendClientMessage( playerid, COLOR_YELLOW,  " Place a bounty on a player and get someone or a GROUP of people to hunt the player down" );
		SendClientMessage( playerid, COLOR_YELLOW,  " for some hot cash. The player who is marked ORANGE on the radar has the highest bounty" );
		SendClientMessage( playerid, COLOR_YELLOW,  " so hunt him down if you're looking for some cash!" );
		SendClientMessage( playerid, COLOR_GREEN,	"Weapons Commands:" );
		SendClientMessage( playerid, COLOR_YELLOW,  " /bounty, /hitman, /bounties" );
		
		return 1;
	}
	
	if ( !strcmp( params, "accounts", true, 8 ) )
	{
        SendClientMessage( playerid, COLOR_GREEN,   "Accounts Help:" );
        SendClientMessage( playerid, COLOR_YELLOW,  " Accounts can be used to protect your nickname and save various stats for the player" );
        SendClientMessage( playerid, COLOR_YELLOW,  " such as bank, kills, deaths, online time, bounty, last skin and admin level." );
		SendClientMessage( playerid, COLOR_GREEN,	"Accounts Commands:" );
		SendClientMessage( playerid, COLOR_YELLOW,  " /register, /stats, /login, /password, /email, /drop, /setlevel, /setname" );
		SendClientMessage( playerid, COLOR_RED,		" Please note that some of these account commands are only available for administrators." );

		return 1;
	}
	
	if ( !strcmp( params, "properties", true, 10 ) )
	{
		SendClientMessage( playerid, COLOR_GREEN,   "Properties Help:" );
		SendClientMessage( playerid, COLOR_YELLOW,  " The properties feature in " SZ_GAMEMODE_S_NAME " allows players to gain an income by purchasing" );
		SendClientMessage( playerid, COLOR_YELLOW,  " properties found across the map. A property purchased by you is protected until you" );
		SendClientMessage( playerid, COLOR_YELLOW,  " receive your first payment, after your first payment another player is able to purchase" );
		SendClientMessage( playerid, COLOR_YELLOW,  " the property (you will be refunded the properties current value!)." );
		SendClientMessage( playerid, COLOR_GREEN,	"Properties Commands:" );
		SendClientMessage( playerid, COLOR_YELLOW,  " /buy, /sell, /properties [1-4]" );
		
		return 1;
	}
	
	if ( !strcmp( params, "territories", true, 11 ) )
	{
		SendClientMessage( playerid, COLOR_GREEN,   "Territories Help:" );
		SendClientMessage( playerid, COLOR_YELLOW,  " Gang territories are placed in certain areas of Las Venturas and are noticeable by coloured patches on the in-game radar." );
		SendClientMessage( playerid, COLOR_YELLOW,  " already own the use these gang territories to generate some extra income for your gang. You will get money" );
		SendClientMessage( playerid, COLOR_YELLOW,  " upon taking a territory OR territory you can get money for defending the territory from an attack. In order to start an" );
		SendClientMessage( playerid, COLOR_YELLOW,  " attack you will need two players (from your gang) in the territory for a period of time, the final score is calculated" );
		SendClientMessage( playerid, COLOR_YELLOW,  " based upon gang members, kills, deaths in the territory and a couple of extra points can be gained from other tasks." );
		
		return 1;
	}

	return 0;
}


dcmd_tips( playerid, params[ ] )
{
	#pragma unused params
	
	SendClientMessage( playerid, COLOR_GREEN,	"" SZ_GAMEMODE_L_NAME " (" SZ_GAMEMODE_S_NAME ") - Tips:" );
	SendClientMessage( playerid, COLOR_YELLOW,	" 1.) The best place to hang around for newbies to " SZ_GAMEMODE_S_NAME " would" );
	SendClientMessage( playerid, COLOR_YELLOW,	"     have to be the pirate ships as it gives you $25 if you stand on them." );
	SendClientMessage( playerid, COLOR_YELLOW,	" 2.) Joining a good gang will ensure you have friends to back you" );
	SendClientMessage( playerid, COLOR_YELLOW,	"     up, you can also share money using gang bank." );
	SendClientMessage( playerid, COLOR_YELLOW,	" 3.) Using the bank is important, if you die you will lose all" );
	SendClientMessage( playerid, COLOR_YELLOW,	"     of the money currently on you - put uneeded money in bank for later." );
	SendClientMessage( playerid, COLOR_ORANGE,	" There's several other ways to play the gamemode, devise your own strategy's" );
	SendClientMessage( playerid, COLOR_ORANGE,	" and suprise people." );
	
	return 1;
}

dcmd_objective( playerid, params[ ] )
{
	#pragma unused params
	
	SendClientMessage( playerid, COLOR_GREEN,	"" SZ_GAMEMODE_L_NAME " (" SZ_GAMEMODE_S_NAME ") - Objective:" );
	SendClientMessage( playerid, COLOR_YELLOW,	" There's no end game objective in " SZ_GAMEMODE_S_NAME ", everybody can win through" );
	SendClientMessage( playerid, COLOR_YELLOW,	" their own challenges. Some challenges you might like to strive for" );
	SendClientMessage( playerid, COLOR_YELLOW,	" could be, being the richest on the server, getting the most kills," );
	SendClientMessage( playerid, COLOR_YELLOW,	" owning the most properties, owning all of the gang territories, achieve" );
	SendClientMessage( playerid, COLOR_YELLOW,	" special kills (e.g. snipering) and/or anything else you can think of." );

	return 1;
}

dcmd_credits( playerid, params[ ] )
{
	#pragma unused params

	SendClientMessage( playerid, COLOR_GREEN, "" SZ_GAMEMODE_L_NAME " (" SZ_GAMEMODE_S_NAME " - Credits:" );
	SendClientMessage( playerid, COLOR_GREEN, "Scripters:" );
	SendClientMessage( playerid, COLOR_YELLOW," adamcs, Brandon, jax, kenny01, LnX, Mike, Sintax, Simon" );
	SendClientMessage( playerid, COLOR_GREEN, "Special thanks:" );
	SendClientMessage( playerid, COLOR_YELLOW," Cam, Ez, Damian, DracoBlue, IDmad, jacob, jinx, littlewhitey, Lop_Dog, Peter," );
	SendClientMessage( playerid, COLOR_YELLOW," Sneaky, Y_Less and also thanks to the following groups, littlewhitey administrators," );
	SendClientMessage( playerid, COLOR_YELLOW," SA:MP developers, SA:MP betateam, scripters, script testers, " );
	SendClientMessage( playerid, COLOR_YELLOW," [CP], [eVo], [KFC], [MOB], [R], [S], [SiN] [SWK], [W]." );
	SendClientMessage( playerid, COLOR_ORANGE,"Thank YOU for playing this gamemode." );
    
    return 1;
}

dcmd_gangs( playerid, params[ ] )
{
	#pragma unused params
	
	#if TEXT_DRAWS_INSTEAD_OF_CLIENT_MESSAGES == true
	print("Debug: 1");
	lclear(playerid);
	print("Debug: 2");
	lshowmessage(playerid, lgangs[0]);
	print("Debug: 3");
	lshowmessage(playerid, lgangs[1]);
	print("Debug: 4");
	lvisiblemessage[playerid] = 2;
    print("Debug: 5");
    #else

	new
		szGangString[ MAX_CLIENT_MSG ] = "* ",
		iCnt, iGangCnt;

	SendClientMessage( playerid, COLOR_GREEN, "Gangs:" );
	
	for ( new i = 0; i < MAX_GANGS; i++ )
	{
	    if ( gData[ i ][ G_TOTALS ] )
	    {
	        iCnt	++;
	        iGangCnt++;
	        
	        format( szGangString, sizeof( szGangString ), "%s%s (%d) - Members %d, ", szGangString, gData[ i ][ G_NAME ], i, gData[ i ][ G_TOTALS ] );
	        
		    if ( iCnt >= 3 )
		    {
		        SendClientMessage( playerid, COLOR_YELLOW, szGangString );
		        
				szGangString= "* ";
		        iCnt		= 0;
		    }
	    }
	}

	if ( !iGangCnt )
		SendClientMessage( playerid, COLOR_WHITE, "There are no gangs online." );
	    
	else
	{
		if ( iCnt )
			SendClientMessage( playerid, COLOR_YELLOW, szGangString );

		if ( iGangCnt != 1 )
		    format( szGangString, sizeof( szGangString ), "There is %d gangs online.", gTotals );
		else
			szGangString = "There is 1 gang online.";

		SendClientMessage( playerid, COLOR_WHITE, szGangString );
	}

	#endif
	return 1;
}

dcmd_gang( playerid, params[ ] )
{
	new gString[ MAX_CLIENT_MSG ], gangid = pData[ playerid ][ P_GANG_ID ];

	if ( params[ 0 ] == '\0' )
	    return SendUsage( playerid, "/gang [CREATE/JOIN/QUIT/INFO/KICK/INVITE/SETLEADER] [PLAYERID/GANG_NAME/GANGID]" );
	else if ( !strcmp( params, "create", true, 6 ) )
	{
	    if ( IsPlayerInAnyGang( playerid ) )
	        return SendError( playerid, "You are already in a gang." );
		else if ( !strlen( params[ 7 ] ) )
		    return SendUsage( playerid, "/gang create [GANG_NAME]" );
		else
		{
		    strcpy( gString, params, 0, 7 );
		    
		    if ( CreateGang( playerid, gString ) != INVALID_GANG_ID )
		    {
#if TEXT_DRAWS_INSTEAD_OF_CLIENT_MESSAGES == true
				print("Debug: 1 3237");
				lredraw(2);
#endif
				return 1;
			}
			else
			    return SendError( playerid, "Gang could not be created." );
		}
	}

	else if ( !strcmp( params, "quit", true, 4 ) || !strcmp( params, "leave", true, 5 ) )
	{
     	if ( !IsPlayerInAnyGang( playerid ) )
		 	return SendError( playerid, "You are not in a gang." );
		else
		{
		    RemovePlayerFromGang( playerid, GANG_LEAVE_QUIT );
#if TEXT_DRAWS_INSTEAD_OF_CLIENT_MESSAGES == true
		    lredraw(2);
#endif
			return 1;
		}
	}

	else if ( !strcmp ( params, "kick", true, 4 ) )
	{
	    if ( pData[ playerid ][ P_GANG_POS ] )
	        return SendError( playerid, "You must be gang leader to use this command." );
		else if ( !strlen( params[ 5 ] ) || !IsNumeric( params[ 5 ] ) )
		    return SendUsage( playerid, "/gang kick [PLAYERID]" );

		new kick = strval( params[ 5 ] );

		if ( !IsPlayerConnected( kick ) )
		    return SendError( playerid, "Player is not connected." );
		else if ( pData[ kick ][ P_GANG_ID ] != pData[ playerid ][ P_GANG_ID ] )
		    return SendError( playerid, "You can only kick players in your gang." );
		else
		{
		    RemovePlayerFromGang( kick, GANG_LEAVE_KICK, playerid );
#if TEXT_DRAWS_INSTEAD_OF_CLIENT_MESSAGES == true
		    lredraw(2);
#endif
		    return 1;
		}
	}

	else if ( !strcmp( params, "invite", true, 6 ) )
	{
//	    if ( pData[ playerid ][ P_GANG_POS ] )
//       return SendError( playerid, "You must be gang leader to use this command." );

		if ( !IsPlayerInAnyGang( playerid ) )
		    return SendError( playerid, "You must be in a gang to use this command." );
	    else if ( !strlen( params[ 7 ] ) || !IsNumeric( params[ 7 ] ) )
			return SendUsage( playerid, "/gang invite [PLAYERID]" );

		new invite = strval( params[ 7 ] );

		if ( !IsPlayerConnected( invite ) )
			return SendError( playerid, "Player is not connected." );
		else if ( invite == playerid )
		    return SendError( playerid, "Inviting yourself?" );

		else
		{
			GetPlayerName( playerid, gString, MAX_PLAYER_NAME );
		    format( gString, sizeof( gString ), "* %s (ID: %d) invited you to join %s (ID: %d). Type /gang join to join.", gString, playerid, gData[ gangid ][ G_NAME ], gangid );
			SendClientMessage( invite, COLOR_ORANGE, gString );

			GetPlayerName( invite, gString, MAX_PLAYER_NAME );
			format( gString, sizeof( gString ), "* Sent a gang invite to %s (ID: %d).", gString, invite );
			SendClientMessage( playerid, COLOR_GREEN, gString );

			pData[ invite ][ P_GANG_INVITE ] = pData[ playerid ][ P_GANG_ID ];
#if TEXT_DRAWS_INSTEAD_OF_CLIENT_MESSAGES == true
            lredraw(2);
#endif
			return 1;
		}
	}

	else if ( !strcmp( params, "info", true, 4 ) )
	{
	    new gID = INVALID_GANG_ID;

	    if ( !strlen( params[ 5 ] ) )
	    {
	        if ( !IsPlayerInAnyGang( playerid ) )
	            return SendUsage( playerid, "/gang info [GANGID]" );
			else
			    gID = pData[ playerid ][ P_GANG_ID ];
	    }

	    else if ( strlen( params[ 5 ] ) )
	    {
	        if ( !IsNumeric( params[ 5 ] ) )
	            return SendUsage( playerid, "/gang info [GANGID]" );
			else
			    gID = strval( params[ 5 ] );
	    }

	    if ( !IsValidGang( gID ) )
	    {
	        return SendError( playerid, "Enter a valid gang id." );
	    }

		new pName[ MAX_PLAYER_NAME ], counter;

		format( gString, sizeof( gString ), "* Gang Information for %s (ID:%d):", gData[ gID ][ G_NAME ], gID );
		SendClientMessage( playerid, COLOR_GREEN, gString );
		GetPlayerName( gData[ gID ][ G_LEADER ], gString, MAX_PLAYER_NAME );
		format( gString, sizeof( gString ), "* Leader - %s (ID:%d) | Members - %d", gString, gData[ gID ][ G_LEADER ], gData[ gID ][ G_TOTALS ] );
		SendClientMessage( playerid, COLOR_YELLOW, gString );
		format( gString, sizeof( gString ), "* Kills - %d | Deaths - %d", gData[ gID ][ G_KILLS ], gData[ gID ][ G_DEATHS ] );

		if ( !gData[ gID ][ G_DEATHS ] || !gData[ gID ][ G_KILLS ] )
		{
		    format( gString, sizeof( gString ), "%s | Kill Ratio - N/A", gString );
		}

		else
		{
		    format( gString, sizeof( gString ), "%s | Kill Ratio - %.2f", gString, floatdiv( gData[ gID ][ G_KILLS ], gData[ gID ][ G_DEATHS ] ) );
		}

		SendClientMessage( playerid, COLOR_YELLOW, gString );
		gString = "* ";

		for ( new memberid = 0; memberid < gData[ gID ][ G_TOTALS ]; memberid++ )
		{
			if ( IsPlayerConnected( gData[ gID ][ G_MEMBERS ][ memberid ] ) )
			{
			    GetPlayerName( gData[ gID ][ G_MEMBERS ][ memberid ], pName, MAX_PLAYER_NAME );

			    if ( counter > 3 )
				{
					SendClientMessage( playerid, COLOR_YELLOW, gString );
					gString = "* ";
					format( gString, sizeof( gString ), "%s%s (%d), ", gString, pName, gData[ gID ][ G_MEMBERS ][ memberid ] );
					counter = 1;
				}
			    else
				{
					format( gString, sizeof( gString ), "%s%s (%d), ", gString, pName, gData[ gID ][ G_MEMBERS ][ memberid ] );
					counter++;
				}
			}
		}

		if ( strlen( gString[ 2 ] ) )
			SendClientMessage( playerid, COLOR_YELLOW, gString );

		return 1;
	}

	else if ( !strcmp( params, "join", true, 4 ) )
	{
	    if ( pData[ playerid ][ P_GANG_INVITE ] == INVALID_GANG_ID )
	        return SendError( playerid, "You have not been invited to a gang." );
		else if ( gData[ pData[ playerid ][ P_GANG_INVITE ] ][ G_TOTALS ] >= MAX_GANG_MEMBERS )
		    return SendError( playerid, "This gang is full." );
	    else
	    {
	        if ( IsPlayerInAnyGang( playerid ) )
				RemovePlayerFromGang( playerid, GANG_LEAVE_QUIT );
				
			SetPlayerGang( playerid, pData[ playerid ][ P_GANG_INVITE ] );
			pData[ playerid ][ P_GANG_INVITE ] = INVALID_GANG_ID;
#if TEXT_DRAWS_INSTEAD_OF_CLIENT_MESSAGES == true
            lredraw(2);
#endif
			return 1;
	    }
	}
/*	else if ( !strcmp( params, "alliance", true, 8 ) )
	{
	    if ( !IsPlayerInAnyGang( playerid ) )
	        return SendError( playerid, "You must be in a gang to use this command." );
		else if ( pData[ playerid ][ P_GANG_POS ] )
		    return SendError( playerid, "You must be a gang leader to use this command." );
		else if ( !strlen( params[ 9 ] ) || !IsNumeric( params[ 10 ] ) )
		    return SendUsage( playerid, "/gang alliance [gangid]" );

		new allyid = strval( params[ 9 ] );
		
		if ( !IsValidGang( allyid ) )
		    return SendError( playerid, "Who are you trying to ally with!?" );
		else
		{
		    gData[ pData[ playerid ][ P_GANG_ID ] ][ G_ALLY ] = allyid;
		    
		    format( gString, sizeof( gString ), "* Your gang has allied with %s (ID:%d).", gData[ allyid ][ G_NAME ], allyid );
		    SendClientMessageToGang( pData[ playerid ][ P_GANG_ID ], COLOR_ORANGE, gString );
		    format( gString, sizeof( gString ), "* %s (ID:%d) has made you their ally.", gData[ pData[ playerid ][ P_GANG_ID ] ][ G_NAME ], pData[ playerid ][ P_GANG_ID ] );
		    SendClientMessageToGang( allyid, COLOR_ORANGE, gString );
		    
		    return 1;
		}
	}
*/
	else if ( !strcmp( params, "setleader", true, 9 ) )
	{
	    if ( !IsPlayerInAnyGang( playerid ) )
	        return SendError( playerid, "You must be in a gang to use this command." );
		else if ( pData[ playerid ][ P_GANG_POS ] )
		    return SendError( playerid, "You must be the gang leader to use this command." );
		else if ( !strlen( params[ 10 ] ) || !IsNumeric( params[ 10 ] ) )
			return SendUsage( playerid, "/gang setleader [PLAYERID]" );

		new otherid = strval( params[ 10 ] );
		
		if ( !IsPlayerConnected( otherid ) )
			return SendError( playerid, "Player is not connected." );
		else if ( !IsPlayerInGang( otherid, pData[ playerid ][ P_GANG_ID ] ) )
		    return SendError( playerid, "This player is not in your gang!" );
		else
		{
		    new
				pName[ MAX_PLAYER_NAME ];
		    
		    gData[ gangid ][ G_MEMBERS ][ pData[ otherid ][ P_GANG_POS ] ]	= playerid;
			pData[ playerid ][ P_GANG_POS ]									= pData[ otherid ][ P_GANG_POS ];

            gData[ gangid ][ G_MEMBERS ][ 0 ]	= otherid;
		    pData[ otherid ][ P_GANG_POS ]		= 0;
		    
		    gData[ pData[ playerid ][ P_GANG_ID ] ][ G_LEADER ]	= otherid;
		    gData[ pData[ playerid ][ P_GANG_ID ] ][ G_COLOR ]	= pColors[ otherid ];
		    
			GetPlayerName( playerid, pName, MAX_PLAYER_NAME );
		    GetPlayerName( otherid, gString, MAX_PLAYER_NAME );

		    format( gString, sizeof( gString ), "* %s (ID:%d) has set %s (ID:%d) as gang leader.", pName, playerid, gString, otherid );
		    
			if ( playerid != sRhinoOwner && playerid != sHighBountyPlayer )
				SetPlayerColor( playerid, setAlpha( pColors[ playerid ], 0x40 ) );

			for ( new memberid = 0; memberid < gData[ gangid ][ G_TOTALS ]; memberid++ )
			{
			    if ( IsPlayerConnected( gData[ gangid ][ G_MEMBERS ][ memberid ] ) )
			    {
					if ( sRhinoOwner == gData[ gangid ][ G_MEMBERS ][ memberid ] || sHighBountyPlayer == gData[ gangid ][ G_MEMBERS ][ memberid ] )
					{
						// We don't need to set "memberid"'s colour ...

						for ( new omemberid = 0; omemberid < gData[ gangid ][ G_TOTALS ]; omemberid++ )
						{
							if ( !IsPlayerConnected( gData[ gangid ][ G_MEMBERS ][ omemberid ] ) )
								continue;

							// We need to set "omemberid"'s colour
							if( sRhinoOwner != gData[ gangid ][ G_MEMBERS ][ omemberid ] && sHighBountyPlayer != gData[ gangid ][ G_MEMBERS ][ omemberid ] )
					  			SetPlayerMarkerForPlayer( gData[ gangid ][ G_MEMBERS ][ memberid ], gData[ gangid ][ G_MEMBERS ][ omemberid ], setAlpha( gData[ gangid ][ G_COLOR ], 0xAA ) );
						}
	     			}

	     			else
	     			{
	     				// We need to set memberid's colour.
						SetPlayerColor( gData[ gangid ][ G_MEMBERS ][ memberid ], setAlpha( gData[ gangid ][ G_COLOR ], 0x40 ) );

						for ( new omemberid = 0; omemberid < gData[ gangid ][ G_TOTALS ]; omemberid++ )
						{
	 						if ( !IsPlayerConnected( gData[ gangid ][ G_MEMBERS ][ omemberid ] ) )
								continue;

							// We don't need to set "j"'s colour.
							if ( sRhinoOwner == gData[ gangid ][ G_MEMBERS ][ omemberid ] || sHighBountyPlayer == gData[ gangid ][ G_MEMBERS ][ omemberid ] )
								SetPlayerMarkerForPlayer( gData[ gangid ][ G_MEMBERS ][ omemberid ], gData[ gangid ][ G_MEMBERS ][ memberid ], setAlpha( gData[ gangid ][ G_COLOR ], 0xAA ) );

							// We need to set "j"'s and "i"'s colour.
		        			else
							{
								SetPlayerMarkerForPlayer( gData[ gangid ][ G_MEMBERS ][ memberid ], gData[ gangid ][ G_MEMBERS ][ omemberid ], setAlpha( gData[ gangid ][ G_COLOR ], 0xAA ) );
								SetPlayerMarkerForPlayer( gData[ gangid ][ G_MEMBERS ][ omemberid ], gData[ gangid ][ G_MEMBERS ][ memberid ], setAlpha( gData[ gangid ][ G_COLOR ], 0xAA ) );
							}
						}

						SendClientMessage( gData[ gangid ][ G_MEMBERS ][ memberid ], COLOR_GREEN, gString );
					}

				}
			}

			#if VERSION_LITE == false
			for ( new gZ = 0; gZ < sizeof( gZones ); gZ++ )
			{
			    if ( gZones[ gZ ][ G_ZONE_OWNER ] == gangid )
			    {
					gZones[ gZ ][ G_ZONE_COLOR ] = ( gData[ gangid ][ G_COLOR ] & 0xFFFFFF00 ) | 0x80;

					GangZoneShowForAll( gZones[ gZ ][ G_ZONE_ID ], gZones[ gZ ][ G_ZONE_COLOR ] );

					if ( gZones[ gZ ][ G_ZONE_WAR ] )
					{
						GangZoneFlashForAll( gZones[ gZ ][ G_ZONE_ID ], 0xFF000080 );
					}
				}
			}
			#endif
			
		    return 1;
		}
	}

	return 0;
}

dcmd_hitman( playerid, params[ ] )
{
	new
		pMoney = GetPlayerMoney( playerid ),
		idx,
		tString[ MAX_CLIENT_MSG ];

	tString = strtok( params, idx );

	if ( tString[ 0 ] == '\0' || !strlen( params[ idx + 1 ] ) || !IsNumeric( tString ) || !IsNumeric( params[ idx + 1 ] ) )
	    return SendUsage( playerid, "/hitman [PLAYERID] [AMOUNT]" );

	new
		BountyID	= strval( tString ),
		tMoney		= strval( params[ idx + 1 ] );

	if ( !IsPlayerConnected( BountyID ) )
		return SendError( playerid, "Player is not connected." );

	else if ( pMoney < 1 || ( pMoney - tMoney ) < 0 || tMoney < 1 )
	    return SendError( playerid, "Invalid bounty amount." );
	else if ( tMoney > 99999999 || tMoney + pData[ BountyID ][ P_BOUNTY ] > 99999999 )
	    return SendError( playerid, "Total bounty on player exceeds $99999999." );

	else
	{
	    new
			pName[ MAX_PLAYER_NAME ],
			bName[ MAX_PLAYER_NAME ];

		pData[ BountyID ][ P_BOUNTY ] += tMoney;

	    AC_GivePlayerMoney( playerid, -tMoney );

	    GetPlayerName( playerid, pName, MAX_PLAYER_NAME );
	    GetPlayerName( BountyID, bName, MAX_PLAYER_NAME );
	    
	    format( tString, sizeof( tString ), "* %s put a $%d bounty on %s's head (Total: $%d).", pName, tMoney, bName, pData[ BountyID ][ P_BOUNTY ] );
	    SendClientMessageToAll( COLOR_ORANGE, tString );
	    
	    format( tString, sizeof( tString ), "* %s (ID:%d) has put a $%d bounty on your head.", pName, playerid, tMoney );
	    SendClientMessage( BountyID, COLOR_RED, tString );
	    
		format( tString, MAX_CLIENT_MSG, "[hitman] %s %d %s %d %d %d",
					pName, playerid, bName, BountyID, tMoney, pData[ BountyID ][ P_BOUNTY ]
		);

		add_log( tString );
		
		if ( sHighBountyPlayer == INVALID_PLAYER_ID || pData[ BountyID ][ P_BOUNTY ] > pData[ sHighBountyPlayer ][ P_BOUNTY ] )
		{
		    new
				OldBountyID = sHighBountyPlayer;
				
            sHighBountyPlayer = BountyID;
            
			format( tString, sizeof( tString ), "* %s (%d) has the highest bounty ($%d). Look for the ORANGE blip.", bName, sHighBountyPlayer, pData[ sHighBountyPlayer ][ P_BOUNTY ] );
			SendClientMessageToAll( COLOR_ORANGE, tString );
			
			if ( sHighBountyPlayer != sRhinoOwner )
				SetPlayerColor( sHighBountyPlayer, COLOR_ORANGE );

			if ( OldBountyID != INVALID_PLAYER_ID && OldBountyID != sRhinoOwner )
			{

				if ( !IsPlayerInAnyGang( OldBountyID ) )
					SetPlayerColor( OldBountyID, setAlpha( pColors[ OldBountyID ], 0x40 ) );
		
				else
				{
				    // Set the old bountyid's colour to his normal colour...
				    
					SetPlayerColor( OldBountyID, setAlpha( gData[ pData[ OldBountyID ][ P_GANG_ID ] ][ G_COLOR ], 0x40 ) );
					
					for ( new memberid = 0; memberid < gData[ pData[ OldBountyID ][ P_GANG_ID ] ][ G_TOTALS ]; memberid++ )
					{
						if ( IsPlayerConnected( gData[ pData[ OldBountyID ][ P_GANG_ID ] ][ G_MEMBERS ][ memberid ] ) && sRhinoOwner != gData[ pData[ OldBountyID ][ P_GANG_ID ] ][ G_MEMBERS ][ memberid ] && sHighBountyPlayer != gData[ pData[ OldBountyID ][ P_GANG_ID ] ][ G_MEMBERS ][ memberid ] )
						{
							// If the players i and playerid are in the same gang then set the marker to the gang colour
							// with an alpha of 0xAA.

							SetPlayerMarkerForPlayer( gData[ pData[ OldBountyID ][ P_GANG_ID ] ][ G_MEMBERS ][ memberid ], OldBountyID, setAlpha( gData[ pData[ OldBountyID ][ P_GANG_ID ] ][ G_COLOR ], 0xAA ) );
							SetPlayerMarkerForPlayer( OldBountyID, gData[ pData[ OldBountyID ][ P_GANG_ID ] ][ G_MEMBERS ][ memberid ], setAlpha( gData[ pData[ OldBountyID ][ P_GANG_ID ] ][ G_COLOR ], 0xAA ) );
						}
					}
				}
			}
		}

	    return 1;
	}
}

dcmd_bounty( playerid, params[ ] )
{
	new
		pID = INVALID_PLAYER_ID;
	    
	if ( pData[ playerid ][ P_LEVEL ] >= 2 && !strcmp( params, "set", true, 3 )  )
	{
	
		/*
		new
			iNewAmount;
	    
		if( params[ 3 ] == '\0' || !IsNumeric( params ) )
			return SendUsage( playerid, "/bounty [playerid] [amount]" );

		pID = strval( params );

		if ( !IsPlayerConnected( pID ) )
			return SendError( playerid, "Player is not connected." );
		*/
		
		return SendClientMessage( playerid, COLOR_RED, "You found an unfinished feature kthx." );
	}
	    
	else
	{
	    if( params[ 0 ] == '\0' || !IsNumeric( params ) )
			return SendUsage( playerid, "/bounty [playerid]" );
	    	
		pID = strval( params );
		
		if ( !IsPlayerConnected( pID ) )
		    return SendError( playerid, "Player is not connected." );
		    
	    new
			tString[ 65 ];

	    GetPlayerName( pID, tString, MAX_PLAYER_NAME );
	    format( tString, 64, "* %s has a total bounty of $%d", tString, pData[ pID ][ P_BOUNTY ] );
	    SendClientMessage( playerid, COLOR_YELLOW, tString );

	    return 1;
	}
}

dcmd_bounties( playerid, params[ ] )
{
	#pragma unused params

	new bString[ MAX_CLIENT_MSG ], pName[ MAX_PLAYER_NAME ], counter; bString = "* ";

	SendClientMessage( playerid, COLOR_GREEN, "Bounties:" );

	loopPlayers( i )
	{
	    if ( pData[ i ][ P_BOUNTY ] )
		{
		    GetPlayerName( i, pName, MAX_PLAYER_NAME );

		    if ( counter > 2 )
			{
				SendClientMessage( playerid, COLOR_YELLOW, bString );
				bString = "* ";
				format( bString, sizeof( bString ), "%s%s(%d)($%d), ", bString, pName, i,pData[ i ][ P_BOUNTY ] );
				counter = 1;
			}

		    else
			{
				format( bString, sizeof( bString ), "%s%s(%d)($%d), ", bString, pName, i, pData[ i ][ P_BOUNTY ] );
				counter++;
			}
		}
	}

	if ( strlen( bString[ 2 ] ) )
		SendClientMessage( playerid, COLOR_YELLOW, bString );

	return 1;
}

dcmd_bank( playerid, params[ ] )
{
	new
		gString[ MAX_CLIENT_MSG ],
		amount,
		pMoney = GetPlayerMoney( playerid );

	if ( !IsPlayerInCheckpoint( playerid ) || ( pData[ playerid ][ P_CHECKPOINT_AREA ] != _:CP_S_BANK && pData[ playerid ][ P_CHECKPOINT_AREA ] != _:CP_L_BANK ) )
	    return SendError( playerid, "You must be in a bank to use this command." );

	else if ( params[ 0 ] == '\0' || !IsNumeric( params ) )
	    return SendUsage( playerid, "/bank [amount]" );

	amount = strval( params );

	if ( pMoney < 1 || ( pMoney - amount ) < 0 || amount < 1 )
		return SendError( playerid, "Invalid transaction amount." );

	if ( amount > pMoney )
		amount	= pMoney;

	if ( pData[ playerid ][ P_BANK ] < PERSONAL_BANK_LIMIT )
	{
	    if ( ( amount + pData[ playerid ][ P_BANK ] ) > PERSONAL_BANK_LIMIT )
	        amount = ( PERSONAL_BANK_LIMIT - pData[ playerid ][ P_BANK ] );
	}
	else
	    return SendError( playerid, "You cannot deposit anymore because your bank is at the maximum limit of $" #PERSONAL_BANK_LIMIT "." );
	    
	pData[ playerid ][ P_BANK ] += amount;
	AC_GivePlayerMoney( playerid, -amount );

	format( gString, sizeof( gString ), "* You deposited $%d, your current balance is $%d.", amount, pData[ playerid ][ P_BANK ] );
	SendClientMessage( playerid, COLOR_YELLOW, gString );
	
	return 1;
}

dcmd_gbank( playerid, params[ ] )
{
	new gString[ MAX_CLIENT_MSG ], amount, pMoney = GetPlayerMoney( playerid );

	if ( !IsPlayerInAnyGang( playerid ) )
	    return SendError( playerid, "You must be in a gang to use this command." );

	if ( !IsPlayerInCheckpoint( playerid ) || ( pData[ playerid ][ P_CHECKPOINT_AREA ] != _:CP_S_BANK && pData[ playerid ][ P_CHECKPOINT_AREA ] != _:CP_L_BANK ) )
	    return SendError( playerid, "You must be in a bank to use this command." );

	else if ( params[ 0 ] == '\0' || !IsNumeric( params ) )
	    return SendUsage( playerid, "/gbank [amount]" );

	amount = strval( params );

	if ( pMoney < 1 || ( pMoney - amount ) < 0 || amount < 1 )
	    return SendError( playerid, "Invalid transaction amount." );

	if ( amount > pMoney )
	    amount = pMoney;
	    
	if ( gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK ] < GANG_BANK_LIMIT )
	{
	    if ( ( amount + gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK ] ) > GANG_BANK_LIMIT )
	        amount = ( GANG_BANK_LIMIT - gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK ] );
	}
	else
	    return SendError( playerid, "You cannot deposit anymore because your bank is at the maximum limit of $" #GANG_BANK_LIMIT "." );

	gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK ] += amount;
	AC_GivePlayerMoney( playerid, -amount );

	format( gString, sizeof( gString ), "* You deposited $%d, your gangs current balance is $%d.", amount, gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK ] );
	SendClientMessage( playerid, COLOR_YELLOW, gString );

	return 1;
}

dcmd_withdraw( playerid, params[ ] )
{
	new amount, gString[ MAX_CLIENT_MSG ];

	if ( !IsPlayerInCheckpoint( playerid ) || ( pData[ playerid ][ P_CHECKPOINT_AREA ] != _:CP_S_BANK && pData[ playerid ][ P_CHECKPOINT_AREA ] != _:CP_L_BANK ) )
		return SendError( playerid, "You must be in a bank to use this command." );

	else if ( params[ 0 ] == '\0' || !IsNumeric( params ) )
	    return SendUsage( playerid, "/withdraw [amount]" );

	amount = strval( params );

	if ( pData[ playerid ][ P_BANK ] < 1 || ( pData[ playerid ][ P_BANK ] - amount ) < 0 || amount < 1 )
	    return SendError( playerid, "Invalid transaction amount." );

	if ( amount > pData[ playerid ][ P_BANK ] )
	    amount = pData[ playerid ][ P_BANK ];

	pData[ playerid ][ P_BANK ] -= amount;
	AC_GivePlayerMoney( playerid, amount );

	format( gString, sizeof( gString ), "* You withdrew $%d, your current balance is $%d.", amount, pData[ playerid ][ P_BANK ] );
	SendClientMessage( playerid, COLOR_YELLOW, gString );

	GetPlayerName( playerid, gString, MAX_PLAYER_NAME );
	format( gString, sizeof( gString ), "* %s has withdrawn $%d.", gString, amount );
	SendClientMessageToAdmins( 0xFF9900AA, gString );

	GetPlayerName( playerid, gString, MAX_PLAYER_NAME );
	format( gString, sizeof( gString ), "[withdraw] %s %d %d", gString, playerid, amount );
	add_log( gString );

	return 1;
}

dcmd_gwithdraw( playerid, params[ ] )
{
	new amount, gString[ MAX_CLIENT_MSG ];

	if ( !IsPlayerInAnyGang( playerid ) )
		return SendError( playerid, "You must be in a gang to use this command." );

	if ( !IsPlayerInCheckpoint( playerid ) || ( pData[ playerid ][ P_CHECKPOINT_AREA ] != _:CP_S_BANK && pData[ playerid ][ P_CHECKPOINT_AREA ] != _:CP_L_BANK ) )
		return SendError( playerid, "You must be in a bank to use this command." );

	else if ( params[ 0 ] == '\0' || !IsNumeric( params ) )
	    return SendUsage( playerid, "/gwithdraw [amount]" );

	amount = strval( params );

	if ( gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK ] < 1 || ( gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK ] - amount ) < 0 || amount < 1 )
	    return SendError( playerid, "Invalid transaction amount." );

	if ( amount > gData[ playerid ][ G_BANK ] )
	    amount = gData[ playerid ][ G_BANK ];

	gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK ] -= amount;
	AC_GivePlayerMoney( playerid, amount );

	format( gString, sizeof( gString ), "* You withdrew $%d, your gangs current balance is $%d.", amount, gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK ] );
	SendClientMessage( playerid, COLOR_YELLOW, gString );

	GetPlayerName( playerid, gString, MAX_PLAYER_NAME );
	format( gString, sizeof( gString ), "* %s has gang withdrawn $%d.", gString, amount );
	SendClientMessageToAdmins( 0xFF9900AA, gString );

	GetPlayerName( playerid, gString, MAX_PLAYER_NAME );
	format( gString, sizeof( gString ), "[withdraw] %s %d %d", gString, playerid, amount );
	add_log( gString );

	return 1;
}

dcmd_balance( playerid, params[ ] )
{
	#pragma unused params

	new
		gString[ MAX_CLIENT_MSG ];

	if ( !IsPlayerInCheckpoint( playerid ) || ( pData[ playerid ][ P_CHECKPOINT_AREA ] != _:CP_S_BANK && pData[ playerid ][ P_CHECKPOINT_AREA ] != _:CP_L_BANK ) )
		return SendError( playerid, "You must be in a bank to use this command." );

	format( gString, sizeof( gString ), "* Your current bank balance is $%d.", pData[ playerid ][ P_BANK ] );
	SendClientMessage( playerid, COLOR_YELLOW, gString );

	return 1;
}

dcmd_gbalance( playerid, params[ ] )
{
	#pragma unused params

	new gString[ MAX_CLIENT_MSG ];

	if ( !IsPlayerInAnyGang( playerid ) )
		return SendError( playerid, "You must be in a gang to use this command." );

	if ( !IsPlayerInCheckpoint( playerid ) || ( pData[ playerid ][ P_CHECKPOINT_AREA ] != _:CP_S_BANK && pData[ playerid ][ P_CHECKPOINT_AREA ] != _:CP_L_BANK ) )
		return SendError( playerid, "You must be in a bank to use this command." );

	format( gString, sizeof( gString ), "* Your gangs current bank balance is $%d.", gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK ] );
	SendClientMessage( playerid, COLOR_YELLOW, gString );

	return 1;
}


dcmd_givecash( playerid, params[ ] )
{
	new pMoney = GetPlayerMoney( playerid ), idx, tString[ MAX_CLIENT_MSG ], rName[ MAX_PLAYER_NAME ], pName[ MAX_PLAYER_NAME ], ReceiveID, tMoney;

	tString = strtok( params, idx );

	if ( tString[ 0 ] == '\0' || !strlen( params[ idx + 1 ] ) || !IsNumeric( tString ) || !IsNumeric( params[ idx + 1 ] ) )
	    return SendUsage( playerid, "/givecash [PLAYERID] [AMOUNT]" );

	ReceiveID	= strval( tString );
	tMoney		= strval( params[ idx + 1 ] );

	if ( !IsPlayerConnected( ReceiveID ) )
	    return SendError( playerid, "This player is not connected." );
	    
	else if ( tMoney > 500000 )
	    return SendError( playerid, "You may not give more than $500000 at a time." );
	    
	else if ( pMoney < 0 || ( pMoney - tMoney ) < 0 || tMoney < 1 )
	    return SendError( playerid, "Invalid transaction amount." );

	else if ( ReceiveID == playerid )
		return SendError( playerid, "You can't send money to yourself!" );

	else
	{
	    AC_GivePlayerMoney( ReceiveID, tMoney );
	    AC_GivePlayerMoney( playerid, -tMoney );

	    GetPlayerName( playerid, pName, MAX_PLAYER_NAME );
	    format( tString, sizeof( tString ), "* %s (%d) has sent you $%d.", pName, playerid, tMoney );
	    SendClientMessage( ReceiveID, COLOR_YELLOW, tString );

	    GetPlayerName( ReceiveID, rName, MAX_PLAYER_NAME );
	    format( tString, sizeof( tString ), "* You have sent $%d to %s (%d).", tMoney, rName, ReceiveID );
		SendClientMessage( playerid, COLOR_YELLOW, tString );

		format( tString, sizeof( tString ), "* %s (%d) has sent %s (%d) $%d.", pName, playerid, rName, ReceiveID, tMoney );
		SendClientMessageToAdmins( 0xFF9900AA, tString );
		
		format( tString, sizeof( tString ), "[givecash] %s %d %d %s %d", pName, playerid, tMoney, rName, ReceiveID );
		add_log( tString );
		
		return 1;
	}
}

dcmd_buy( playerid, params[ ] )
{
	#pragma unused params

	new pString[ MAX_CLIENT_MSG ], pMoney = GetPlayerMoney( playerid ), tPropertyID;

	if ( !IsPlayerInCheckpoint( playerid ) || pData[ playerid ][ P_CHECKPOINT_AREA ] < _:CP_ZIP )
	    return SendError( playerid, "You must be in a property checkpoint to use this command." );

    tPropertyID = pData[ playerid ][ P_CHECKPOINT_AREA ] - _:CP_ZIP;

    if ( !gPropertyData[ tPropertyID ][ PROPERTY_CAN_BE_BOUGHT ] )
		return SendError( playerid, "This property is not for sale right now. Please come back later." );

	else if ( pMoney < gPropertyData[ tPropertyID ][ PROPERTY_PRICE ] )
	    return SendError( playerid, "You do not have enough money to purchase this property." );

	else if ( gPropertyData[ tPropertyID ][ PROPERTY_OWNER ] == playerid )
	    return SendError( playerid, "You already own this property." );

	else
	{
	    if ( gPropertyData[ tPropertyID ][ PROPERTY_OWNER ] != INVALID_PLAYER_ID )
	    {
	        GetPlayerName( playerid, pString, MAX_PLAYER_NAME );
	        format( pString, sizeof( pString ), "* Your property, the %s has been bought out by %s (ID:%d).", gPropertyData[ tPropertyID ][ PROPERTY_NAME ], pString, playerid );
			SendClientMessage( gPropertyData[ tPropertyID ][ PROPERTY_OWNER ], COLOR_ORANGE, pString );
			AC_GivePlayerMoney( gPropertyData[ tPropertyID ][ PROPERTY_OWNER ], gPropertyData[ tPropertyID ][ PROPERTY_PRICE ] );
	    }

	    gPropertyData[ tPropertyID ][ PROPERTY_OWNER ]			= playerid;
	    gPropertyData[ tPropertyID ][ PROPERTY_CAN_BE_BOUGHT ]  = 0;
		gPropertyData[ tPropertyID ][ PROPERTY_TICKS ]			= gPropertyData[ tPropertyID ][ PROPERTY_TIME ];

	    AC_GivePlayerMoney( playerid, -gPropertyData[ tPropertyID ][ PROPERTY_PRICE ] );
	    format( pString, sizeof( pString ), "* You have purchased %s!", gPropertyData[ tPropertyID ][ PROPERTY_NAME ] );
	    SendClientMessage( playerid, COLOR_GREEN, pString );
	}
	//LnX
#if TEXT_DRAWS_INSTEAD_OF_CLIENT_MESSAGES == true
    lredraw(1);
#endif
    
	return 1;

}
#if TEXT_DRAWS_INSTEAD_OF_CLIENT_MESSAGES == true
dcmd_clear( playerid, params[ ] )
{
    #pragma unused params
    
    lclear(playerid);
    lvisiblemessage[playerid] = 0;
    return 1;
}
#endif

dcmd_sell( playerid, params[ ] )
{
	#pragma unused params

	new pString[ MAX_CLIENT_MSG ], tPropertyID;

	if ( !IsPlayerInCheckpoint( playerid ) || pData[ playerid ][ P_CHECKPOINT_AREA ] < _:CP_ZIP )
	    return SendError( playerid, "You must be in a property checkpoint to use this command." );

	tPropertyID = pData[ playerid ][ P_CHECKPOINT_AREA ] - _:CP_ZIP;

	if ( gPropertyData[ tPropertyID ][ PROPERTY_OWNER ] != playerid )
	    return SendError( playerid, "You can not sell a property you don't own." );

	else
	{
	    gPropertyData[ tPropertyID ][ PROPERTY_OWNER ]			= INVALID_PLAYER_ID;
	    gPropertyData[ tPropertyID ][ PROPERTY_CAN_BE_BOUGHT ]	= 1;

		AC_GivePlayerMoney( playerid, gPropertyData[ tPropertyID ][ PROPERTY_PRICE ] );

	    format( pString, sizeof( pString ), "* You have sold %s and gained $%d!", gPropertyData[ tPropertyID ][ PROPERTY_NAME ], gPropertyData[ tPropertyID ][ PROPERTY_PRICE ] );
	    SendClientMessage( playerid, COLOR_GREEN, pString );
	}

	return 1;
}

dcmd_wdisable( playerid, params[ ] )
{
    #pragma unused params
    
    #if _SRV_03_ASSUMPTION_ != true
    #pragma unused playerid
	SendClientMessage	( playerid, COLOR_WHITE, "- Bad weapons unsynced." );
	SetDisabledWeapons	(
							1, 4, 6, 7, 8, 9,
							14, 15, 35, 36, 37,
							38, 39, 41, 43, 44, 45
						);
	#else
		#pragma unused playerid
	#endif

	return 1;
}

dcmd_wenable( playerid,params[ ] )
{
	#pragma unused params
	
	#if _SRV_03_ASSUMPTION_ != true
	
	SendClientMessage	( playerid, COLOR_WHITE, "- Bad weapons resynced." );
	SetDisabledWeapons	( );
	#else
		#pragma unused playerid
	#endif
	return 1;
}

dcmd_buyweapon( playerid, params[ ] )
{
	new
		wString[ 65 ],
		idx,
		weaponid,
		pMoney = GetPlayerMoney( playerid ),
		weaponslot,
		wprice;

	wString = strtok( params, idx );

	if ( !strlen( params[ idx + 1 ] ) || wString[ 0 ] == '\0' || !IsNumeric( params[ idx + 1 ] ) || !IsNumeric( wString ) )
		return SendUsage( playerid, "/buyweapon [weapon_number] [weapon_amount]" );

	weaponid	= strval( wString );
	idx			= strval( params[ idx + 1 ] );	// Ammo
	weaponslot  = GetWeaponSlot( weaponid );
	wprice      = floatround( floatmul( floatmul( sWeapons[ weaponid ][ WEAPON_PRICE ], SPAWN_PRICE_RATIO ), idx ), floatround_round );
	
	if ( !IsPlayerInCheckpoint( playerid ) || pData[ playerid ][ P_CHECKPOINT_AREA ] != _:CP_M_AMMUNATION )
	    return SendError( playerid, "You need to be in Ammunation to purchase weapons." );
	    
	if ( ( sWeapons[ weaponid ][ WEAPON_AMMO ] * idx ) > 9999 || ( pData[ playerid ][ P_SPAWN_AMMO ][ weaponslot ] + ( sWeapons[ weaponid ][ WEAPON_AMMO ] * idx) > 9999 ) )
	    return SendError( playerid, "The shop refuses to sell you anymore spawnweapons to you (AmmoLimit: 9999)." );

	if ( pMoney < wprice )
	    return SendError( playerid, "You don't have enough money to purchase this many weapons." );

	if ( weaponid < 0 || weaponid > sizeof( sWeapons ) - 1 || !sWeapons[ weaponid ][ WEAPON_SPAWN_WEAPON ] || weaponslot == WEAPON_NOSLOT )
	    return SendError( playerid, "Invalid weapon id." );

	if ( idx < 1 )
		return SendError( playerid, "Invalid weapon amount." );

	format( wString, sizeof( wString ), "You purchased %d %s's for when you spawn ($%d).", idx, sWeapons[ weaponid ][ WEAPON_NAME ], wprice );
	SendClientMessage( playerid, COLOR_GREEN, wString );

	AC_GivePlayerMoney( playerid, -wprice );
	
	#if MODE_PROTECTED_WEAPONS != 2
	GivePlayerWeapon( playerid, weaponid, sWeapons[ weaponid ][ WEAPON_AMMO ] * idx );
	#endif
	
	pData[ playerid ][ P_TEMP_WEAPONS ][ weaponslot ]	= weaponid;
	pData[ playerid ][ P_TEMP_AMMO ][ weaponslot ]		+= ( sWeapons[ weaponid ][ WEAPON_AMMO ] * idx );
	
	pData[ playerid ][ P_SPAWN_WEAPONS ][ weaponslot ]	=  weaponid;
	pData[ playerid ][ P_SPAWN_AMMO ][ weaponslot ]		+= ( sWeapons[ weaponid ][ WEAPON_AMMO ] * idx );

	return 1;
}

dcmd_mute( playerid, params[ ] )
{
	new
		mString[ MAX_CLIENT_MSG ],
		MuteID,
		idx;

	mString = strtok( params, idx );

	if( mString[ 0 ] == '\0' || !IsNumeric( mString ) || !strlen( params[ idx + 1 ] ) )
	    return SendUsage( playerid, "/mute [playerid] [reason]" );

	MuteID = strval( mString );

	if ( !IsPlayerConnected( MuteID ) )
		return SendError( playerid, "Player is not connected." );
		
	else if ( pData[ playerid ][ P_LEVEL ] <= pData[ MuteID ][ P_LEVEL ] && !IsPlayerAdmin( playerid ) )
			return SendError( playerid, "You cannot mute a player whose level is higher or the same level as your own." );

	else if( pData[ MuteID ][ P_MUTE ] )
		return SendError( playerid, "Player is already muted." );

	GetPlayerName( MuteID, mString, MAX_PLAYER_NAME );
	format( mString, sizeof ( mString ), "%s (ID: %d) has been muted for: %s", mString, MuteID, params[ idx + 1 ] );
	SendClientMessageToAll( COLOR_ORANGE, mString );

	pData[ MuteID ][ P_MUTE ]	= 1;

	return 1;
}

dcmd_unmute( playerid, params[ ] )
{
	new
		uString[ MAX_CLIENT_MSG ],
		MuteID;

	if( params[ 0 ] == '\0' || !IsNumeric( params ) )
	    return SendUsage( playerid, "/unmute [playerid]" );

	MuteID = strval( params );

	if ( !IsPlayerConnected( MuteID ) )
	    return SendError( playerid, "Player is not connected." );

	else if( !pData[ MuteID ][ P_MUTE ] )
	    return SendError( playerid, "Player is not muted." );

	GetPlayerName( MuteID, uString, MAX_PLAYER_NAME );
	format( uString, sizeof( uString ), "%s (ID: %d) has been unmuted.", uString, MuteID );
	SendClientMessageToAll( COLOR_ORANGE, uString );

	pData[ MuteID ][ P_MUTE ]	= 0;

	return 1;
}

dcmd_muteall( playerid, params[ ] )
{
	#pragma unused params
	#pragma unused playerid

	sMute   = 1;
	SendClientMessageToAll( COLOR_ORANGE, "All players have been muted" );
	
	return 1;
}

dcmd_unmuteall( playerid, params[ ] )
{
	#pragma unused params
	#pragma unused playerid

	sMute   = 0;
	SendClientMessageToAll( COLOR_ORANGE, "All players have been unmuted" );
	
	return 1;
}

dcmd_mutelist( playerid, params[ ] )
{
	#pragma unused params
	
	new str[ 65 ];
   	SendClientMessage( playerid, COLOR_ORANGE, "The following player(s) is/are muted:" );
   	
	loopPlayers( i )
	{
	    if ( pData[ i ][ P_MUTE ] )
		{
	    	GetPlayerName( i, str, MAX_PLAYER_NAME );
			format( str, sizeof( str ), "%s (%d)", str, i );
	    	SendClientMessage(playerid, COLOR_GREEN, str);
	    }
	}
	
	return 1;
}

dcmd_weaponlist( playerid, params[ ] )
{
	#pragma unused params

	new wString[ MAX_CLIENT_MSG ];

	if ( !IsPlayerInCheckpoint( playerid ) || pData[ playerid ][ P_CHECKPOINT_AREA ] != _:CP_M_AMMUNATION )
		return SendError( playerid, "You need to be in Ammunation to see the weapon list." );

	if ( params[ 0 ] == '\0' || params[ 1 ] != '\0' )
	    return SendUsage( playerid, "/weaponlist [1-2]" );

	switch ( params[ 0 ] )
	{
	    case '2':
	    {
	        SendClientMessage( playerid, COLOR_GREEN, "Weapon List 2:" );
	        
			for ( new i = 7; i < 14; i++ )
			{
			    if ( sWeapon[ i ] )
			    {
					format( wString, sizeof( wString ), "* %d - %s - $%d - Ammo: %d", sWeapon[ i ], sWeapons[ sWeapon[ i ] ][ WEAPON_NAME ], floatround( floatmul( sWeapons[ sWeapon[ i ] ][ WEAPON_PRICE ], SPAWN_PRICE_RATIO ), floatround_round ), sWeapons[ sWeapon[ i ] ][ WEAPON_AMMO ] );
					SendClientMessage( playerid, COLOR_YELLOW, wString );
				}
			}
	    }
	    
	    case '1':
	    {
			SendClientMessage( playerid, COLOR_GREEN, "Weapon List 1:" );
	        
			for ( new i = 0; i < 7; i++ )
			{
				if ( sWeapon[ i ] )
				{
					format( wString, sizeof( wString ), "* %d - %s - $%d - Ammo: %d", sWeapon[ i ], sWeapons[ sWeapon[ i ] ][ WEAPON_NAME ], floatround( floatmul( sWeapons[ sWeapon[ i ] ][ WEAPON_PRICE ], SPAWN_PRICE_RATIO ), floatround_round ), sWeapons[ sWeapon[ i ] ][ WEAPON_AMMO ] );
					SendClientMessage( playerid, COLOR_YELLOW, wString );
				}
			}
		}
		
		default: return SendUsage( playerid, "/weaponlist [1-2]" );
	}

	return 1;
}

dcmd_properties( playerid, params[ ] )
{
    

#if TEXT_DRAWS_INSTEAD_OF_CLIENT_MESSAGES == true
    #pragma unused params
    
	lclear(playerid);
	lshowmessage(playerid, lprops[0]);
	lshowmessage(playerid, lprops[1]);
	lshowmessage(playerid, lprops[2]);
    lvisiblemessage[playerid] = 1;
    
    return 1;
#else
    new pString[ MAX_CLIENT_MSG ];
    
	if ( params[ 0 ] == '1' && params[ 1 ] == '\0' )
	{
	    SendClientMessage( playerid, COLOR_GREEN, "Properties 1:" );

	    for ( new i = 0; i < 7; i++ )
	    {
	        if ( gPropertyData[ i ][ PROPERTY_OWNER ] != INVALID_PLAYER_ID )
	        {
	            GetPlayerName( gPropertyData[ i ][ PROPERTY_OWNER ], pString, MAX_PLAYER_NAME );
	        	format( pString, sizeof( pString ),"* %s is owned by %s", gPropertyData[ i ][ PROPERTY_NAME ], pString );
	        	SendClientMessage( playerid, COLOR_YELLOW, pString );
	        }
	        else
	        {
				format( pString, sizeof( pString ),"* %s has no owner.", gPropertyData[ i ][ PROPERTY_NAME ] );
				SendClientMessage( playerid, COLOR_ORANGE, pString );
	        }
	    }
	    return 1;
	}

	else if ( params[ 0 ] == '2' && params[ 1 ] == '\0' )
	{
	    SendClientMessage( playerid, COLOR_GREEN, "Properties 2:" );

	    for ( new i = 7; i < 14; i++ )
	    {
	        if ( gPropertyData[ i ][ PROPERTY_OWNER ] != INVALID_PLAYER_ID )
	        {
	            GetPlayerName( gPropertyData[ i ][ PROPERTY_OWNER ], pString, MAX_PLAYER_NAME );
	        	format( pString, sizeof( pString ),"* %s is owned by %s", gPropertyData[ i ][ PROPERTY_NAME ], pString );
	        	SendClientMessage( playerid, COLOR_YELLOW, pString );
	        }
	        else
	        {
				format( pString, sizeof( pString ),"* %s has no owner.", gPropertyData[ i ][ PROPERTY_NAME ] );
				SendClientMessage( playerid, COLOR_ORANGE, pString );
	        }
	    }
	    return 1;
	}
	else if ( params[ 0 ] == '3' && params[ 1 ] == '\0' )
	{
	    SendClientMessage( playerid, COLOR_GREEN, "Properties 3:" );
	    
		for ( new i = 14; i < 21; i++ )
	    {
	        if ( gPropertyData[ i ][ PROPERTY_OWNER ] != INVALID_PLAYER_ID )
	        {
	            GetPlayerName( gPropertyData[ i ][ PROPERTY_OWNER ], pString, MAX_PLAYER_NAME );
	        	format( pString, sizeof( pString ),"* %s is owned by %s", gPropertyData[ i ][ PROPERTY_NAME ], pString );
	        	SendClientMessage( playerid, COLOR_YELLOW, pString );
	        }
	        else
	        {
				format( pString, sizeof( pString ),"* %s has no owner.", gPropertyData[ i ][ PROPERTY_NAME ] );
				SendClientMessage( playerid, COLOR_ORANGE, pString );
	        }
	    }
	    return 1;
	}
	else if ( params[ 0 ] == '4' && params[ 1 ] == '\0' )
	{
	    SendClientMessage( playerid, COLOR_GREEN, "Properties 4:" );

		for ( new i = 21; i < sizeof( gPropertyData ); i++ )
	    {
	        if ( gPropertyData[ i ][ PROPERTY_OWNER ] != INVALID_PLAYER_ID )
	        {
	            GetPlayerName( gPropertyData[ i ][ PROPERTY_OWNER ], pString, MAX_PLAYER_NAME );
	        	format( pString, sizeof( pString ),"* %s is owned by %s", gPropertyData[ i ][ PROPERTY_NAME ], pString );
	        	SendClientMessage( playerid, COLOR_YELLOW, pString );
	        }
	        else
	        {
				format( pString, sizeof( pString ),"* %s has no owner.", gPropertyData[ i ][ PROPERTY_NAME ] );
				SendClientMessage( playerid, COLOR_ORANGE, pString );
	        }
	    }
	    return 1;
	}
	else
	    return SendUsage( playerid, "/properties [1-4]" );
#endif
}

//==============================================================================

stock Text:CreateBankText( playerid )
{
	new
				bString[ 64 ],
		Text:	tmpTextDraw;
		
	format( bString, sizeof( bString ), "~g~Personal: ~w~$%09d", pData[ playerid ][ P_BANK ] );
	
	if ( pData[ playerid ][ P_BANK_TEXT ] == INVALID_TEXT_DRAW )
	{
		tmpTextDraw = TextDrawCreate( 240.0, 327.5, bString );

	 	TextDrawFont( tmpTextDraw, 1 );
	 	TextDrawSetOutline( tmpTextDraw, 1 );
	  	TextDrawSetProportional( tmpTextDraw, 1 );
	   	TextDrawAlignment( tmpTextDraw, 3 );
	   	TextDrawHideForAll( tmpTextDraw );
	   	
	   	return
		   	tmpTextDraw;
   	}
	else
	{
	    TextDrawSetString( pData[ playerid ][ P_BANK_TEXT ], bString );
	    
	    return
			pData[ playerid ][ P_BANK_TEXT ];
	}
}

stock Text:CreateGangBankText( gangid )
{
	new
				bString	[ 64 ],
		Text:	tmpTextDraw;
		
	format( bString, sizeof( bString ), "~g~Gang:~w~ $%09d", gData[ gangid ][ G_BANK ] );
	
	if ( gData[ gangid ][ G_BANK_TEXT ] == INVALID_TEXT_DRAW )
	{
		tmpTextDraw = TextDrawCreate( 240.0, 337.5, bString );

	 	TextDrawFont( tmpTextDraw, 1 );
	 	TextDrawSetOutline( tmpTextDraw, 1 );
	  	TextDrawSetProportional( tmpTextDraw, 1 );
	   	TextDrawAlignment( tmpTextDraw, 3 );
	   	TextDrawHideForAll( tmpTextDraw );
	   	
	   	return
			tmpTextDraw;
	}
	else
	{
	    TextDrawSetString( gData[ gangid ][ G_BANK_TEXT ], bString );
	    
	    return
			gData[ gangid ][ G_BANK_TEXT ];
	}

   	
}

stock Text:CreateTerritoryText( name[ ] )
{
	new
		tString[ 128 ];

	tString = "~r~";

	for ( new i = 0; name[ i ] != '\0'; i++ )
	{
		if ( isprint( name[ i ] ) && name[ i ] != '~' )
			tString[ ( i + 3 ) ] = name[ i ];
			
		else
			tString[ ( i + 3 ) ] = ' ';
	}

	strcat( tString, "'s ~s~Territory" );

	new
		Text:tmpTextDraw = TextDrawCreate( 615.0, 400.0, tString );

 	TextDrawFont			( tmpTextDraw, 1 );
 	TextDrawSetOutline		( tmpTextDraw, 1 );
  	TextDrawSetProportional	( tmpTextDraw, 1 );
   	TextDrawAlignment		( tmpTextDraw, 3 );
   	TextDrawHideForAll		( tmpTextDraw );

	return
		tmpTextDraw;
}

stock add_log( text[ ] )
{
	new
		File:fp = fopen( "echo.txt", io_append ),
		tmp[ 1024 ];
		
	if ( fp )
	{
		format( tmp, 1024, "%s\n", text );
		fwrite( fp, tmp );
		fclose( fp );
	}
}

stock SendMessageToLevelAndHigher( level, color, msg[ ] )
{
	loopPlayers( i )
	{
	    if ( IsPlayerAdmin( i ) || pData[ i ][ P_LEVEL ] >= level )
			SendClientMessage( i, color, msg );
	}
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Territory Functions

stock AddGangZone( Float:minx, Float:miny, Float:maxx, Float:maxy )
{
	for ( new i = 0; i < MAX_SCRIPT_ZONES; i++ )
	{
	    if( gZones[ i ][ G_ZONE_ID ] == INVALID_GANG_ZONE )
	    {
	        gZones[ i ][ G_ZONE_TEXT ]  = TEXT_NoZoneOwner;
	        gZones[ i ][ G_ZONE_ID ]    = GangZoneCreate( minx, miny, maxx, maxy );
			gZones[ i ][ G_ZONE_OWNER ] = 255;
			gZones[ i ][ G_ZONE_COLOR ] = COLOR_ZONE_DEFAULT;
			gZones[ i ][ G_ZONE_WAR ]   = 0;
			gZones[ i ][ G_ZONE_TIMER ] = 0;
			gZones[ i ][ G_ZONE_MINX ]  = minx;
			gZones[ i ][ G_ZONE_MINY ]  = miny;
			gZones[ i ][ G_ZONE_MAXX ]  = maxx;
			gZones[ i ][ G_ZONE_MAXY ]  = maxy;

			return i;
		}
	}
	return INVALID_GANG_ZONE;
}

stock DestroyGangZone( zoneid )
{
	gZones[ i ][ G_ZONE_TEXT ]  = INVALID_TEXT_DRAW;
	gZones[ i ][ G_ZONE_ID ]    = INVALID_GANG_ZONE;
	gZones[ i ][ G_ZONE_OWNER ] = 255;
	gZones[ i ][ G_ZONE_COLOR ] = COLOR_ZONE_DEFAULT;
	gZones[ i ][ G_ZONE_WAR ]   = 0;
	gZones[ i ][ G_ZONE_TIMER ] = 0;
	gZones[ i ][ G_ZONE_MINX ]  = 0.0;
	gZones[ i ][ G_ZONE_MINY ]  = 0.0;
	gZones[ i ][ G_ZONE_MAXX ]  = 0.0;
	gZones[ i ][ G_ZONE_MAXY ]  = 0.0;
	
	return 1;
}

stock SetGangZoneColor( zoneid, color )
{
	GangZoneHideForAll( zoneid );
	GangZoneShowForAll( zoneid, color );
	
	gZones[ zoneid ][ G_ZONE_COLOR ] = color;
	
	return 1;
}

stock GangZoneShowForAllEx( zone, color )
{
	loopPlayers( i )
	{
		GangZoneHideForPlayer( i, zone );
		GangZoneShowForPlayer( i, zone, color );
	}
}

stock GangZoneHideForAllEx( zone )
{
	loopPlayers( i )
		GangZoneHideForPlayer( i, zone );
}

#if VERSION_LITE == false
stock StartGangWar( zoneid, tick = 300, time = 60000 )
{
	GangZoneFlashForAll( zoneid, 0xFF000080 );

	for ( new gID = 0; gID < MAX_GANGS; gID++ )
	{
		if ( gData[ gID ][ G_TOTALS ] )
		{
			zTicks[ gID ][ zoneid ][ 0 ]	= tick;
			zDeaths[ gID ][ zoneid ][ 0 ]	= zDeaths[ gID ][ zoneid ][ 1 ] = 0;
		}
	}

	gZones[ zoneid ][ G_ZONE_WAR ]	= 1;
	gZones[ zoneid ][ G_ZONE_TIMER ]= SetTimerEx( "EndGangWar", TURF_WAR_TIME, 0, "i", zoneid );

	return 1;
}


public EndGangWar( zoneid )
{
	// If timerid for EndGangWar in this zoneid
	// is valid then kill the timer and set it to 0 (invalid).
	if ( gZones[ zoneid ][ G_ZONE_TIMER ] )
	{
		KillTimer( gZones[ zoneid ][ G_ZONE_TIMER ] );
		gZones[ zoneid ][ G_ZONE_TIMER ] = 0;
	}

	// Create a variable for winning gangid and a temporary score of the winner / current checking team.
	new newOwner = gZones[ zoneid ][ G_ZONE_OWNER ], tmpScore[ 2 ];

	for ( new gID = 0; gID < MAX_GANGS; gID++ )
	{
	    // If the gang is not valid then continue.
	    if ( !IsValidGang( gID ) )
			continue;
	    
	    // Current checking team score is equal to:
	    //  ( Kills in Zone - Deaths in Zone ) + Players in Zone
	    tmpScore[ 1 ] = ( zDeaths[ gID ][ zoneid ][ 0 ] - zDeaths[ gID ][ zoneid ][ 1 ] ) + zTicks[ gID ][ zoneid ][ 1 ];

		// If tmpScore for current checking team is greater than the current winner,
		// then set the winner to the this gangid and assign the current score to the winners score.
		if ( tmpScore[ 1 ] > tmpScore[ 0 ] )
	    {
	        newOwner		= gID;
			tmpScore[ 0 ]	= tmpScore[ 1 ];
		}

		// Ticks in zone for gang is equal to 0.
		zTicks[ gID ][ zoneid ][ 0 ]	= 0;

		// Kills and Deaths in zone is equal to 0.
        zDeaths[ gID ][ zoneid ][ 0 ]	= zDeaths[ gID ][ zoneid ][ 1 ] = 0;
	}

	// If there is no-one in the winning gang then reset gangzone to defaults.
	if ( !gData[ newOwner ][ G_TOTALS ] )
	{
		gZones[ zoneid ][ G_ZONE_OWNER ] = INVALID_GANG_ID;
		gZones[ zoneid ][ G_ZONE_COLOR ] = COLOR_ZONE_DEFAULT;
		gZones[ zoneid ][ G_ZONE_TEXT ]	 = TEXT_NoZoneOwner;
	}

	// Else if the current owner is not the winner OR the winner is an INVALID_GANG_ID.
	else if ( gZones[ zoneid ][ G_ZONE_OWNER ] != newOwner )
	{
		#define WAR_WINNER_MONEY	1000
	    
		new gString[ MAX_CLIENT_MSG ],
			gPrize = ( tmpScore[ 0 ] > 30 ? WAR_WINNER_MONEY * 30 : WAR_WINNER_MONEY * tmpScore[ 0 ] );
			
		format( gString, sizeof( gString ), "* $%d was deposited into your gangs bank account for taking the turf.", gPrize );
		gData[ newOwner ][ G_BANK ] += gPrize;
		
 		// Loop through all players and check if they're in the gang zone, if they
	    // are then hide the current zone text.
		loopPlayers( pID )
		{
		    if ( pData[ pID ][ P_GANG_ZONE ] == zoneid )
			{
				TextDrawHideForPlayer( pID, gZones[ zoneid ][ G_ZONE_TEXT ] );
				TextDrawShowForPlayer( pID, gData[ newOwner ][ G_ZONE_TEXT ] );
			}
			if ( IsPlayerInGang( pID, newOwner ) )
			    SendClientMessage( pID, COLOR_GREEN, gString );
		}

		// Create a new variable for the old owner.
		new
			oldOwner = gZones[ zoneid ][ G_ZONE_OWNER ];

		// Set the zone status to the new winners.
		gZones[ zoneid ][ G_ZONE_OWNER ]	= newOwner;
		gZones[ zoneid ][ G_ZONE_COLOR ]	= ( gData[ newOwner ][ G_COLOR ] & 0xFFFFFF00 ) | 0x80;
		gZones[ zoneid ][ G_ZONE_TEXT ]		= gData[ newOwner ][ G_ZONE_TEXT ];

		// Show oldOwners that their turf was lost.
		TextDrawShowForGang( oldOwner, TEXT_TurfLost );

		// Show newOwners that they claimed the turf.
		TextDrawShowForGang( newOwner, TEXT_TurfIsYours );

		// Hide text draw for old owners after 10 seconds.
		SetTimerEx( "TextDrawHideForGang", 10000, 0, "ii", oldOwner, _:TEXT_TurfLost );

		// Hide text draw for new owners after 10 seconds.
		SetTimerEx( "TextDrawHideForGang", 10000, 0, "ii", newOwner, _:TEXT_TurfIsYours );
		
		#undef WAR_WINNER_MONEY
	}
	// Else if new owner is equal to old owner.
	else if ( gZones[ zoneid ][ G_ZONE_OWNER ] == newOwner )
	{
	    #define	WAR_WINNER_MONEY 500
	    
		new gString[ MAX_CLIENT_MSG ],
			gPrize = ( tmpScore[ 0 ] > 30 ? WAR_WINNER_MONEY * 30 : WAR_WINNER_MONEY * tmpScore[ 0 ] );

		format( gString, sizeof( gString ), "* $%d was deposited into your gangs bank account for defending the turf.", gPrize );
		gData[ newOwner ][ G_BANK ] += gPrize;
		
	    // Show the new gang that they defended the turf sucessfully.
		TextDrawShowForGang( newOwner, TEXT_TurfDefended );
		
		// Tell the gang that they got some money in their bank.
		SendClientMessageToGang( newOwner, COLOR_GREEN, gString );

		// Hide the text draw for gang after 10 seconds.
		SetTimerEx( "TextDrawHideForGang", 10000, 0, "ii", newOwner, _:TEXT_TurfDefended );
		
		#undef	WAR_WINNER_MONEY
	}
	
	// Stop the flashing of zones now that the war has ended.
	GangZoneStopFlashForAll( zoneid );

	// Show the new gang zone colour for all..
	GangZoneHideForAll( zoneid );
 	GangZoneShowForAll( zoneid, gZones[ zoneid ][ G_ZONE_COLOR ] );

 	// Officially set the war to off.
	gZones[ zoneid ][ G_ZONE_WAR ] = 0;
}
#endif

stock IsPlayerStripper( playerid )
{
	new
		pSkin		=	GetPlayerSkin( playerid );
	
	switch ( pSkin ) {
	    case 87, 244, 246, 256, 257:    return 1;
	}
	    
	return 0;
}

stock IsPlayerLawEnforcer( playerid )
{
	new
	    iPlayerSkin = GetPlayerSkin( playerid );

	switch ( iPlayerSkin ) {
	    case 163 .. 166, 274 .. 288:	return 1;
	}
	
	return 0;
}

stock GivePlayerSpawnWeapon( playerid, weaponid, ammo )
{
	new
		slot = GetWeaponSlot( weaponid );
	
	if ( slot == -1 )
	    return 0;
	    
	else
	{
		pData[ playerid ][ P_SPAWN_WEAPONS ][ slot ]	=  weaponid;
		pData[ playerid ][ P_SPAWN_AMMO ][ slot ]		+= ammo;
		
		return 1;
	}
}

stock SendClientMessageToAdmins( color, msg[ ] )
{
	for ( new i = 0, k = GetMaxPlayers( ); i < k; i++ )
	{
		if ( IsPlayerConnected( i ) && ( IsPlayerAdmin( i ) || pData[ i ][ P_LEVEL ] >= _:P_LEVEL_ADMIN  ) )
			SendClientMessage( i, color, msg );
	}
}

stock IsPlayerInAnyStripClub( playerid )
{
	if ( pData[ playerid ][ P_CHECKPOINT_AREA ] == _:CP_SOUTH_STRIP_CLUB || pData[ playerid ][ P_CHECKPOINT_AREA ] == _:CP_NORTH_STRIP_CLUB )
	    return 1;
	    
	return 0;
}

#if TEXT_DRAWS_INSTEAD_OF_CLIENT_MESSAGES == true

//LnX's Bit for funky displaying of text
//lorenxo<dot>lnx<dot>googlemail<dot>com
//This displays the output from commands (e.g. /properties) in a more graphical way
//and dynamically updates them if they change

stock lkillmessage(Text:text)
{
	if (text != INVALID_TEXT_DRAW) // textid's include 0. INVALID_TEXT_DRAW (0xFF) is the correct id for invalid text's.
	{
		TextDrawDestroy(text);
	}
}

stock Text:lshowmessage(playerid, Text:text)
{
	TextDrawLetterSize(text,0.2,0.8);
//	TextDrawTextSize(text, 100, 100);
//	TextDrawAlignment(text, 3);
	TextDrawSetShadow(text, 0);
//	TextDrawUseBox(text, true);
	TextDrawSetOutline(text, 1);
	TextDrawSetProportional(text,true);
	TextDrawShowForPlayer(playerid, text);
}

stock lredrawall()
{
	lredraw(1);
	lredraw(2);
}

stock lredraw(type)
{
	if (type == 1)
	{
	    for (new i = 0; i < 3; i++)
		{
			TextDrawHideForAll(lprops [i]);
			lkillmessage(lprops [i]);
		}
  		lmakeallprops();
		for (new j = 0; j < MAX_PLAYERS; j++)
		{
   	 		if (lvisiblemessage[j] == 1)
   	 		{
   	     		lshowmessage(j, lprops[0]);
   	     		lshowmessage(j, lprops[1]);
   	     		lshowmessage(j, lprops[2]);
			}
		}
	}
	else if (type == 2)
	{
	    for (new i = 0; i < 2; i++)
		{
			TextDrawHideForAll(lgangs [i]);
			lkillmessage(lgangs [i]);
		}
  		lmakeallgangs();
		for (new j = 0; j < MAX_PLAYERS; j++)
		{
   	 		if (lvisiblemessage[j] == 2)
   	 		{
   	     		lshowmessage(j, lgangs[0]);
   	     		lshowmessage(j, lgangs[1]);
			}
		}
	}
	/*
	else if (type == 3)
	{
		lkillmessage(lweaps);
		lmakeweapons();
	}
	*/
}

stock lclear(playerid)
{
 	print("clearing...");
	if (lvisiblemessage[playerid] == 1)
	{
	    for (new i = 0; i < 3; i++)
		{
	    	TextDrawHideForPlayer(playerid, lprops[i]);
		}
 	}
 	else if (lvisiblemessage[playerid] == 2)
	{
	    print("...gangs");
	    for (new i = 0; i < 2; i++)
		{
	    	TextDrawHideForPlayer(playerid, lgangs[i]);
		}
		print("cleared :D");
 	}
 	/*
 	else if (lvisiblemessage[playerid] == 3)
	{
	    TextDrawHideForPlayer(playerid, lweaps);
 	}
 	else if (lvisiblemessage[playerid] == 4)
	{
	    TextDrawHideForPlayer(playerid, lrules);
 	}
 	*/

 	lvisiblemessage[playerid] = 0;

}

//Properties 1
stock Text:lmakeprops1()
{
    new Text:out;
	new loutput[256] = "Properties : ~n~";
	new lplayersname[MAX_PLAYER_NAME];
	new lplayerid[3];
	
	for(new i = 0; i < 5; i++)
	{
		if(gPropertyData [i] [PROPERTY_OWNER] != INVALID_PLAYER_ID)
		{
			GetPlayerName(gPropertyData [i] [PROPERTY_OWNER], lplayersname, sizeof(lplayersname));
            strcat(loutput, gPropertyData [i] [PROPERTY_NAME], sizeof(loutput));
            strcat(loutput, " - ", sizeof(loutput));
            strcat(loutput, lplayersname, sizeof(loutput));
            strcat(loutput, "(", sizeof(loutput));
            valstr(lplayerid, gPropertyData [i] [PROPERTY_OWNER], false);
            strcat(loutput, lplayerid, sizeof(loutput));
			strcat(loutput,")~n~", sizeof(loutput));
		}
		else
		{
            strcat(loutput, gPropertyData [i] [PROPERTY_NAME], sizeof(loutput));
            strcat(loutput, " - none", sizeof(loutput));
   			strcat(loutput,"~n~", sizeof(loutput));
		}


	}
 	out = TextDrawCreate(5.0, 120.0, loutput);
 	return(out);
}

stock Text:lmakeprops2()
{
    new Text:out;
	new loutput[256];
	new lplayersname[MAX_PLAYER_NAME];
	new lplayerid[3];

	for(new i = 5; i < 11; i++)
	{
		if(gPropertyData [i] [PROPERTY_OWNER] != INVALID_PLAYER_ID)
		{
			GetPlayerName(gPropertyData [i] [PROPERTY_OWNER], lplayersname, sizeof(lplayersname));
            strcat(loutput, gPropertyData [i] [PROPERTY_NAME], sizeof(loutput));
            strcat(loutput, " - ", sizeof(loutput));
            strcat(loutput, lplayersname, sizeof(loutput));
            strcat(loutput, "(", sizeof(loutput));
            valstr(lplayerid, gPropertyData [i] [PROPERTY_OWNER], false);
            strcat(loutput, lplayerid, sizeof(loutput));
			strcat(loutput,")~n~", sizeof(loutput));
		}
		else
		{
            strcat(loutput, gPropertyData [i] [PROPERTY_NAME], sizeof(loutput));
            strcat(loutput, " - none", sizeof(loutput));
   			strcat(loutput,"~n~", sizeof(loutput));
		}


	}
 	out = TextDrawCreate(5.0, 163.0, loutput);
 	return(out);
}

stock Text:lmakeprops3()
{
    new Text:out;
	new loutput[256];
	new lplayersname[MAX_PLAYER_NAME];
	new lplayerid[3];

	for(new i = 11; i < 15; i++)
	{
		if(gPropertyData [i] [PROPERTY_OWNER] != INVALID_PLAYER_ID)
		{
			GetPlayerName(gPropertyData [i] [PROPERTY_OWNER], lplayersname, sizeof(lplayersname));
            strcat(loutput, gPropertyData [i] [PROPERTY_NAME], sizeof(loutput));
            strcat(loutput, " - ", sizeof(loutput));
            strcat(loutput, lplayersname, sizeof(loutput));
            strcat(loutput, "(", sizeof(loutput));
            valstr(lplayerid, gPropertyData [i] [PROPERTY_OWNER], false);
            strcat(loutput, lplayerid, sizeof(loutput));
			strcat(loutput,")~n~", sizeof(loutput));
		}
		else
		{
            strcat(loutput, gPropertyData [i] [PROPERTY_NAME], sizeof(loutput));
            strcat(loutput, " - none", sizeof(loutput));
   			strcat(loutput,"~n~", sizeof(loutput));
		}
	}
	strcat(loutput, "~n~Type /clear to hide", sizeof(loutput));
 	out = TextDrawCreate(5.0, 206.0, loutput);
 	return(out);
}

stock lmakeallprops()
{
	lprops [0] = lmakeprops1();
	lprops [1] = lmakeprops2();
	lprops [2] = lmakeprops3();
}

//Gangs 2
stock Text:lmakegangs1()
{
	new Text:out;
	new lgangid[4];
	new loutput[256] = "Gangs :~n~";
    for ( new i = 0; i < 8; i++ )
	{
	    if ( gData[ i ][ G_TOTALS ] )
	    {
	        strcat(loutput, "(", sizeof(loutput));
	        valstr(lgangid, i, false);
	        strcat(loutput, lgangid, sizeof(loutput));
	        strcat(loutput,")", sizeof(loutput));
	        strcat(loutput, gData[ i ][ G_NAME ], sizeof(loutput));
            strcat(loutput, " - ", sizeof(loutput));
            valstr(lgangid, gData[ i ][ G_TOTALS ], false);
            strcat(loutput, lgangid, sizeof(loutput));
            strcat(loutput, " members~n~", sizeof(loutput));
//			format( loutput, sizeof(loutput), "%s (%d) - Members %d~n~", gData[ i ][ G_NAME ], i, gData[ i ][ G_TOTALS ] );
		}
	}
	print(loutput);
	out = TextDrawCreate(5.0, 120.0, loutput);
 	return(out);
}

stock Text:lmakegangs2()
{
	new Text:out;
	new loutput[256];
	new lgangid[4];
    for ( new i = 8; i < MAX_GANGS; i++ )
	{
	    if ( gData[ i ][ G_TOTALS ] )
	    {
	        strcat(loutput, "(", sizeof(loutput));
	        valstr(lgangid, i, false);
	        strcat(loutput, lgangid, sizeof(loutput));
	        strcat(loutput,")", sizeof(loutput));
	        strcat(loutput, gData[ i ][ G_NAME ], sizeof(loutput));
            strcat(loutput, " - ", sizeof(loutput));
            valstr(lgangid, gData[ i ][ G_TOTALS ], false);
            strcat(loutput, lgangid, sizeof(loutput));
            strcat(loutput, " members~n~", sizeof(loutput));
//			format( loutput, sizeof(loutput), "%s (%d) - Members %d~n~", gData[ i ][ G_NAME ], i, gData[ i ][ G_TOTALS ] );
		}
	}
	strcat(loutput, "~n~Type /clear to hide", sizeof(loutput));
	print(loutput);
	out = TextDrawCreate(5.0, 183.0, loutput);
 	return(out);
}

stock lmakeallgangs()
{
    print("Debug: Making the Gangs 4578");
	lgangs [0] = lmakegangs1();
	lgangs [1] = lmakegangs2();
	print("Debug: Made the Gangs 4581");
}
/*
//Weapons 3
public Text:lmakeweapons()
{
    new loutput[256] = "Weapons : ";
    new temp[6];
	for(new i = 0; i < MAX_WEAPONS; i++)
	{
		strcat(loutput, "~n~", sizeof(loutput));
		valstr(temp, (i+1),true);
		strcat(loutput, temp, sizeof(loutput));
		strcat(loutput, ". ", sizeof(loutput));
		strcat(loutput, weaponNames[i], sizeof(loutput));
        strcat(loutput, " - $", sizeof(loutput));
        valstr(temp, weaponCost[i],true);
        strcat(loutput, temp , sizeof(loutput));
	}
	strcat(loutput, "~n~~n~Type /clear to hide", sizeof(loutput));
 	lweaps = TextDrawCreate(5.0, 110.0, loutput);
}
*/
//Rules 4 - Don't work, too long

//End of LnX ;'(

#endif



/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	End Of GameMode: lva.pwn, littlewhitey Scripting Team
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/
