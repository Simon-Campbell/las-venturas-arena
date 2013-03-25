/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Include:

	19/10/2007, 10:35 pm
	register.inc, littlewhitey Scripting Team
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/

/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Global
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/

#include <a_samp>

#if defined __register__included
	#endinput
#endif

#define __register__included

#define MAX_PASSWORD_LENGTH 16

/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Functions
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/

stock LoginUser( DB:Database, PlayerID, Name[ ], Password[ ], UseIP = 0 )
{
	new
		Query[ 256 ],
		DBResult:Result;
	
	if ( !UseIP )
	{
		Query	= encrypt( Password );
		format( Query, sizeof( Query ), "SELECT * FROM lva_users WHERE name=lower('%s') AND password='%s'", Name, Query );
		
	}
	else
		format( Query, sizeof( Query ), "SELECT * FROM lva_users WHERE name=lower('%s') AND lastip='%s'", Name, Password );

	Result	= db_query( Database, Query );

	if ( db_num_fields( Result ) )
	{
		db_get_field_assoc( Result, "userid", Query, sizeof( Query ) );
	    pData[ PlayerID ][ P_USERID ]   = strval( Query );
			    
	    db_get_field_assoc( Result, "level", Query, sizeof( Query ) );
	    pData[ PlayerID ][ P_LEVEL ]    = strval( Query );
	    
	    db_get_field_assoc( Result, "kills", Query, sizeof( Query ) );
	   	pData[ PlayerID ][ P_KILLS ]	= strval( Query );
		
		db_get_field_assoc( Result, "lastskin", Query, sizeof( Query ) );
		pData[ PlayerID ][ P_SKIN ] = strval( Query );
	    
	    db_get_field_assoc( Result, "deaths", Query, sizeof( Query ) );
	    pData[ PlayerID ][ P_DEATHS ]   = strval( Query );
	    
        db_get_field_assoc( Result, "bank", Query, sizeof( Query ) );
		pData[ PlayerID ][ P_BANK ]		= strval( Query );

        db_get_field_assoc( Result, "playtime", Query, sizeof( Query ) );
		pData[ PlayerID ][ P_ONLINE_TICKS ] += strval( Query );
		
		db_get_field_assoc( Result, "bounty", Query, sizeof( Query ) );
		pData[ PlayerID ][ P_BOUNTY ] = strval( Query );

		if ( !pData[ PlayerID ][ P_RETURNING_SPAWN ] )
		{
			for ( new g = 0; g < MAX_WEAPON_SLOT; g++ )
		    {

		        format( Query, sizeof( Query ), "weapon_%d", g );
				db_get_field_assoc( Result, Query, Query, sizeof( Query ) );
				
		        pData[ PlayerID ][ P_SPAWN_WEAPONS ][ g ]	= strval( Query );

				format( Query, sizeof( Query ), "ammo_%d", g );
				db_get_field_assoc( Result, Query, Query, sizeof( Query ) );
		        
		        pData[ PlayerID ][ P_SPAWN_AMMO ][ g ]		= strval( Query );
			}
		}

		db_free_result( Result );
		
		GetPlayerIp( PlayerID, Query, 16 );
		printf( "%s [PlayerID: %d, UserID: %d, Level: %d, IP: %s] has logged in.", Name, PlayerID, pData[ PlayerID ][ P_USERID ], pData[ PlayerID ][ P_LEVEL ], Query );
		
		format( Query, sizeof( Query ), "UPDATE lva_users SET lastip='%s' WHERE name=lower('%s')", Query, Name );
		Result = db_query( Database, Query );
		db_free_result( Result );
		
		pData[ PlayerID ][ P_REGISTERED ]	= 1;
		pData[ PlayerID ][ P_LOGGED_IN ]	= 1;
		
		return 1;
	}
	else
	{
		db_free_result( Result );
	    
		GetPlayerIp( PlayerID, Query, 16 );
		printf( "%s [PlayerID: %d, IP: %s] failed to log in.", Name, PlayerID, Query );
	    
		return 0;
	}
}

stock SaveUser( DB:Database, PlayerID, Name[ ] )
{
	new
		Query[ 512 ], DBResult:Result;

	format( Query, sizeof( Query ), "SELECT * FROM `lva_users` WHERE `name`=lower('%s')", Name );
	Result = db_query( Database, Query );

	if ( db_num_fields( Result ) )
	{
		// Save stuff here.
		
	    db_free_result( Result );
	    
	    #define SAVE_WEAPON false
	    
		#if SAVE_WEAPON == true
		
		GetPlayerIp( PlayerID, Query, 16 );

	    format( Query, sizeof( Query ),
			"UPDATE `lva_users` SET `kills`=%d,`deaths`=%d,`bank`=%d,`weapon_0`=%d,`weapon_1`=%d,`weapon_2`=%d,\
			`weapon_3`=%d,`weapon_4`=%d,`weapon_5`=%d,`weapon_6`=%d,`weapon_7`=%d,`weapon_8`=%d,`weapon_9`=%d,`weapon_10`=%d,\
			`weapon_11`=%d,`weapon_12`=%d WHERE `name`=lower('%s')",
			pData[ PlayerID ][ P_KILLS ], pData[ PlayerID ][ P_DEATHS ], pData[ PlayerID ][ P_BANK ],
			pData[ PlayerID ][ P_SPAWN_WEAPONS ][ 0 ],pData[ PlayerID ][ P_SPAWN_WEAPONS ][ 1 ],pData[ PlayerID ][ P_SPAWN_WEAPONS ][ 2 ],
			pData[ PlayerID ][ P_SPAWN_WEAPONS ][ 3 ],pData[ PlayerID ][ P_SPAWN_WEAPONS ][ 4 ],pData[ PlayerID ][ P_SPAWN_WEAPONS ][ 5 ],
			pData[ PlayerID ][ P_SPAWN_WEAPONS ][ 6 ],pData[ PlayerID ][ P_SPAWN_WEAPONS ][ 7 ],pData[ PlayerID ][ P_SPAWN_WEAPONS ][ 8 ],
			pData[ PlayerID ][ P_SPAWN_WEAPONS ][ 9 ],pData[ PlayerID ][ P_SPAWN_WEAPONS ][ 10 ],pData[ PlayerID ][ P_SPAWN_WEAPONS ][ 11 ],
			pData[ PlayerID ][ P_SPAWN_WEAPONS ][ 12 ], Name );
		
		Result = db_query( Database, Query );
		db_free_result( Result );
		
		format( Query, sizeof( Query ),
		    "UPDATE `lva_users` SET `ammo_0`=%d,`ammo_1`=%d,`ammo_2`=%d,`ammo_3`=%d,`ammo_4`=%d,`ammo_5`=%d,\
			`ammo_6`=%d,`ammo_7`=%d,`ammo_8`=%d,`ammo_9`=%d,`ammo_10`=%d,`ammo_11`=%d,`ammo_12`=%d,`playtime`=%d,\
			`lastlogin`=strftime('%%s','now'),`bounty`=%d, `lastskin`=%d WHERE `name`=lower('%s')",
			pData[ PlayerID ][ P_SPAWN_AMMO ][ 0 ],pData[ PlayerID ][ P_SPAWN_AMMO ][ 1 ],
			pData[ PlayerID ][ P_SPAWN_AMMO ][ 2 ],pData[ PlayerID ][ P_SPAWN_AMMO ][ 3 ],pData[ PlayerID ][ P_SPAWN_AMMO ][ 4 ],
			pData[ PlayerID ][ P_SPAWN_AMMO ][ 5 ],pData[ PlayerID ][ P_SPAWN_AMMO ][ 6 ],pData[ PlayerID ][ P_SPAWN_AMMO ][ 7 ],
			pData[ PlayerID ][ P_SPAWN_AMMO ][ 8 ],pData[ PlayerID ][ P_SPAWN_AMMO ][ 9 ],pData[ PlayerID ][ P_SPAWN_AMMO ][ 10 ],
			pData[ PlayerID ][ P_SPAWN_AMMO ][ 11 ],pData[ PlayerID ][ P_SPAWN_AMMO ][ 12 ],pData[ PlayerID ][ P_ONLINE_TICKS ],
			pData[ PlayerID ][ P_BOUNTY ], pData[ PlayerID ][ P_SKIN ], Name );

		#else
		

		format( Query, sizeof( Query ),
		    "UPDATE `lva_users` SET `kills`=%d,`deaths`=%d,`bank`=%d,`playtime`=%d,`lastlogin`=strftime('%%s','now'),`bounty`=%d,\
			`lastskin`=%d WHERE `name`=lower('%s')",
		    pData[ PlayerID ][ P_KILLS ], pData[ PlayerID ][ P_DEATHS ],
			pData[ PlayerID ][ P_BANK ], pData[ PlayerID ][ P_ONLINE_TICKS ],
			pData[ PlayerID ][ P_BOUNTY ], pData[ PlayerID ][ P_SKIN ], Name
		);
		
		#endif

		Result = db_query( Database, Query );
		db_free_result( Result );

	    return 1;
	}
	else
	{
		db_free_result( Result );
		
		return 0;
	}
}

stock IsUserRegistered( DB:Database, Name[ ] )
{
	new
		Query[ 256 ],
		DBResult:Result;
	
	format( Query, sizeof( Query ), "SELECT `name` FROM `lva_users` WHERE `name`=lower('%s')", Name );
	Result = db_query( Database, Query );
	
	if ( db_num_fields( Result ) )
	{
		db_free_result( Result );
	    return 1;
	}
	else
	{
		db_free_result( Result );
		return 0;
	}
}

stock IsUserRegisteredEx( DB:Database, Name[ ], IP[ ] )
{
	new
		szQuery[ 256 ],
		DBResult: dbResult;

	format( szQuery, sizeof( szQuery ), "SELECT lastip FROM lva_users WHERE name=lower('%s')", Name );
	dbResult = db_query( Database, szQuery );

	if ( db_num_fields( dbResult ) )
	{
		db_get_field_assoc( dbResult, "lastip", IP, 16 );
		db_free_result( dbResult );

		return 1;
	}
	else
	{
		db_free_result( dbResult );

		return 0;
	}
}

stock IsUserBanned( DB:Database, Name[ ] )
{
	new
		Query[ 256 ],
		DBResult:Result;

	format( Query, sizeof( Query ), "SELECT `banned` FROM `lva_users` WHERE `banned`=1 AND `name`=lower('%s')", Name );
	Result = db_query( Database, Query );
	
	if ( db_num_fields( Result ) )
	{
		db_free_result( Result );
	    return 1;
	}
	else
	{
		db_free_result( Result );
	    return 0;
	}
}

stock IsIPRegistered( DB:Database, IP[ ] )
{
	new
		Query[ 256 ],
		DBResult:Result,
		retval;

	format
		( Query, sizeof( Query ), "SELECT `registerip` FROM `lva_users` WHERE `registerip`='%s'", IP );

	Result	= db_query( Database, Query );
	retval	= db_num_rows( Result );

	db_free_result( Result );
	
	return
		( retval );
}

stock SetUserEmail( DB:Database, Name[ ], NewEmail[ ] )
{
	new DBResult:Result;
	
	if ( Database )
	{
	    new
			Query	[ 512 ];

		format( Query, sizeof( Query ), "SELECT * FROM `lva_users` WHERE `name`=lower('%s')", Name );
		Result = db_query( Database, Query );
		
		if ( db_num_fields( Result ) )
		{
		    db_free_result( Result );
		    
		    format( Query, sizeof( Query ), "UPDATE `lva_users` SET `email`='%s' WHERE `name`=lower('%s')", NewEmail, Name );
		    Result = db_query( Database, Query );
		    
		    db_free_result( Result );
		    
		    return 1;
		}
		else
		{
		    db_free_result( Result );
		    
		    return 0;
		}
	}
	else
	    return !print( "ERROR: NO DATABASE!" );
}

stock SetUserPassword( DB:Database, Name[ ], OldPass[ ], NewPass[ ] )
{
	new DBResult:Result;
	
	if ( Database )
	{
	    new
			Query	[ 512 ],
	        Password[ 64 ];

		Password = encrypt( OldPass );
	    format( Query, sizeof( Query ), "SELECT * FROM `lva_users` WHERE `name`=lower('%s') AND `password`='%s'", Name, Password );
	    Result = db_query( Database, Query );
	    
	    if ( db_num_fields( Result ) )
	    {
			db_free_result( Result );
			
			format( Query, sizeof( Query ), "UPDATE `lva_users` SET `password`='%s' WHERE `name`=lower('%s') AND `password`='%s'", encrypt( NewPass ), Name, Password );
			Result = db_query( Database, Query );
	        
	        db_free_result( Result );
	        
	        return 1;
		}
	    else
		{
			db_free_result( Result );
			return 0;
		}
	}
	else
	{
		printf( "[ERROR] NO DATABASE!" );
		return 0;
	}
}

stock SetUserLevel( DB:Database, Name[ ], Level )
{
	new DBResult:Result;
	
	if ( Database )
	{
	    if ( !IsUserRegistered( Database, Name ) )
			return 0;
	    
	    new
			Query[ 256 ];
	    
	    format( Query, sizeof( Query ), "UPDATE `lva_users` SET `level`=%d WHERE `name`=lower('%s')", Level, Name );
		Result = db_query( Database, Query );
		db_free_result( Result );
		
		return 1;
	}
	else
	{
		print( "[ERROR] NO DATABASE!" );
		return 0;
	}
}

stock SetUserName( DB:Database, OldName[ ], NewName[ ] )
{
	new DBResult:Result;
	
	if ( Database )
	{
	    if ( !IsUserRegistered( Database, OldName ) || IsUserRegistered( Database, NewName ) )
			return 0;
	    
	    new Query[ 256 ];
	    
		format( Query, sizeof( Query ), "UPDATE `lva_users` SET `name`=lower('%s') WHERE `name`=lower('%s')", NewName, OldName );
	    Result = db_query( Database, Query );
	    db_free_result( Result );
	    
	    return 1;
	}
	else
	{
	    print( "[ERROR] NO DATABASE!" );
	    return 0;
	}
}

stock InitDatabase( DB:Database )
{
	if ( Database )
	{
		RegisterUser( Database,	"littlewhitey",	"CHANGEME" );
		RegisterUser( Database,	"Mike",			"CHANGEME" );
		RegisterUser( Database,	"Simon",		"CHANGEME" );
		
		SetUserLevel( Database, "littlewhitey",	1337 );
		SetUserLevel( Database, "Mike",			1337 );
		SetUserLevel( Database, "Simon",		1337 );
		
		// Others?
	}
	else
	    print( "[ERROR] NO DATABASE!" );
}

stock RegisterUser( DB:Database, PlayerID, Name[ ], Password[ ], Email[ ] )
{
	new
		DBResult:Result;

	if ( Database )
	{
	    new
			Query[ 512 ];

	    format( Query, sizeof( Query ), "SELECT `name` FROM `lva_users` WHERE `name`=lower('%s')", Name );
	    Result = db_query( Database, Query );
	    
	    if ( !db_num_fields( Result ) )
	    {
	        db_free_result( Result );
	        
	        new
				e_Pass[ 256 ], pIP[ 16 ];
	        
	        GetPlayerIp( PlayerID, pIP, 16 );
	        
	        e_Pass = encrypt( Password );
			
	        format( Query, sizeof( Query ), "\
	        INSERT INTO lva_users(name,password,level,register,registerip,email,kills,deaths,bank,playtime,banned,unbandate,lastlogin,lastskin,clanid) values(\
		    	lower('%s'),'%s',0,strftime('%%s','now'),'%s','%s',%d,%d,%d,%d,0,0,strftime('%%s','now'),0,0\
			);\
			",	Name, e_Pass, pIP, Email,
				pData[ PlayerID ][ P_KILLS ],	pData[ PlayerID ][ P_DEATHS ],
				pData[ PlayerID ][ P_BANK ],	pData[ PlayerID ][ P_ONLINE_TICKS ]
			);

	        Result = db_query( Database, Query );
	        db_free_result( Result );
	        
	        format( Query, sizeof( Query ), "SELECT `userid` FROM `lva_users` WHERE `name`=lower('%s')", Name );
	        Result = db_query( Database, Query );

	        if ( db_num_fields( Result ) )
	        {
		        db_get_field_assoc( Result, "userid", Query, sizeof( Query ) );
		        pData[ PlayerID ][ P_USERID ] = strval( Query );

				printf( "%s [PlayerID: %d, UserID: %s, IP: %s, Email: %s] registered their name.", Name, PlayerID, Query, pIP, Email );

				pData[ PlayerID ][ P_REGISTERED ]	= 1;
				pData[ PlayerID ][ P_LOGGED_IN ]	= 1;
			}
			
			db_free_result( Result );
	        
	        return 1;
	    }
	    else
	        return 0;
	}
	else
	{
	    print( "[ERROR] NO DATABASE!" );
	    return 0;
	}
}

stock DeleteAccount( DB:Database, Name[ ] )
{
	if ( Database )
	{
		new Query[ 512 ], DBResult:Result;
		
		format( Query, sizeof( Query ), "DELETE FROM `lva_users` WHERE `name`=lower('%s')", Name );
		Result = db_query( Database, Query );
		db_free_result( Result );

		return 1;
	}
	else
	{
		print( "[ERROR] NO DATABASE!" );
		return 0;
	}
}

stock UnbanPlayer( DB:Database, Name[ ], Unbanner[ ] )
{
	if ( Database )
	{
	    new
			Query[ 512 ],
	    	DBResult:Result;

		if ( !IsUserRegistered( Database, Name ) )
			return 0;

		format( Query, sizeof( Query ), "UPDATE `lva_users` SET `banned`=0 WHERE `name`=lower('%s')", Name );
		
		Result = db_query( Database, Query );
		db_free_result( Result );
		
	    format( Query, sizeof( Query ), "INSERT INTO lva_bans(name,reporter,reason,ip,time,type) values(\
	        lower('%s'), '%s', 'UNBAN', 'NONE', strftime('%%s','now'),-1\
		);\
		", Name, Unbanner );
		
		Result = db_query( Database, Query );
		db_free_result( Result );
		
		return 1;
	}
	else
	{
	    print( "[ERROR] NO DATABASE!" );
	    return 0;
	}
}

stock BanPlayer( DB:Database, PlayerID, AdminID, Reason[ ] )
{
	if ( Database )
	{
	    new Query	[ 512 ],
			DBResult:Result,
			Name	[ MAX_PLAYER_NAME ],
			Banner	[ MAX_PLAYER_NAME ],
			pIP		[ 16 ],
			t1, t2, t3;
			
	    if ( AdminID == 1000 )
	        Banner = "-LWBot-";

	    else if ( AdminID == INVALID_PLAYER_ID )
	        Banner = "-Unknown-";

	    else
			GetPlayerName( AdminID, Banner, MAX_PLAYER_NAME );
	    
	    gettime( t1, t2, t3 );
	    GetPlayerName( PlayerID, Name, MAX_PLAYER_NAME );
	    GetPlayerIp( PlayerID, pIP, 16 );
	    
	    format( Query, sizeof( Query ), "INSERT INTO lva_bans(name,reporter,reason,ip,time,type) values(\
	        lower('%s'), '%s', '%s', '%s', strftime('%%s','now'),2\
		);\
		", Name, Banner, Reason, pIP );
		
		Result = db_query( Database, Query );
		db_free_result( Result );
		
		format( Query, sizeof( Query ), ">> %s (ID: %d) has banned %s (ID: %d) for: %s", Banner, AdminID, Name, PlayerID, Reason );
		SendClientMessageToAll( COLOR_ORANGE, Query );
		
	    SendClientMessage( PlayerID, COLOR_YELLOW, ">> You have been banned. Please write this information down ...");
	    
	    format( Query, sizeof( Query ), ">> Admin : %s", Banner );
	    SendClientMessage( PlayerID, COLOR_ORANGE, Query );
	    
	    format( Query, sizeof( Query ), ">> Time  : %02d:%02d:%02d", t1, t2, t3 );
	    SendClientMessage( PlayerID, COLOR_ORANGE, Query );
	    
	    getdate( t1, t2, t3 );
	    format( Query, sizeof( Query ), ">> Date  : %02d/%02d/%02d", t3, t2, t1 );
	    SendClientMessage( PlayerID, COLOR_ORANGE, Query );
	    
	    format( Query, sizeof( Query ), ">> Reason: %s", Reason );
	    SendClientMessage( PlayerID, COLOR_ORANGE, Query );
	    
	    format( Query, sizeof( Query ), ">> IP    : %s", pIP );
	    SendClientMessage( PlayerID, COLOR_ORANGE, Query );
	    SendClientMessageToAdmins( COLOR_RED, Query );
	    
	    SendClientMessage( PlayerID, COLOR_YELLOW, ">> If you feel you have been WRONGFULLY banned, please appeal in" );
		SendClientMessage( PlayerID, COLOR_YELLOW, ">> littlewhitey's ban appeal forum at http://gta-mp.littlewhitey.com" );
		
		if ( IsUserRegistered( Database, Name ) )
		{
			format( Query, sizeof( Query ), "UPDATE `lva_users` SET `banned`=1 WHERE `name`=lower('%s')", Name );
			
			Result = db_query( Database, Query );
			db_free_result( Result );
			
			Kick( PlayerID );
			
			printf( "[acc-ban] %s (IP: %s) was banned by %s for the reason %s.", Name, pIP, Banner, Reason );
		}
		else
		{
			Ban         ( PlayerID );
			Kick        ( PlayerID );
		    printf		( "[ip-ban] %s (IP: %s) was banned by %s for the reason %s.", Name, pIP, Banner, Reason );
		}
		
		format	( Query, sizeof( Query ), "[banreason] %s %s %s [IP:%s]", Banner, Name, Reason, pIP );
		add_log	( Query );
		
		return 1;
	}
	else
	{
		print( "[ERROR] NO DATABASE!" );
	    return 0;
	}
}

stock KickPlayer( DB:Database, PlayerID, AdminID, Reason[ ] )
{
	if ( Database )
	{
	    new Query	[ 512 ],
			DBResult:Result,
			Name	[ MAX_PLAYER_NAME ],
			Kicker	[ MAX_PLAYER_NAME ],
			pIP		[ 16 ],
			t1, t2, t3;

	    if ( AdminID == 1000 )
	        Kicker = "-LWBot-";

	    else if ( AdminID == INVALID_PLAYER_ID )
	        Kicker = "-Unknown-";

	    else
			GetPlayerName( AdminID, Kicker, MAX_PLAYER_NAME );

	    gettime( t1, t2, t3 );
	    GetPlayerName( PlayerID, Name, MAX_PLAYER_NAME );
	    GetPlayerIp( PlayerID, pIP, 16 );

	    format( Query, sizeof( Query ), "INSERT INTO lva_bans(name,reporter,reason,ip,time,type) values(\
	        '%s', '%s', '%s', '%s', strftime('%%s','now'),1\
		);\
		", Name, Kicker, Reason, pIP );
		
		Result = db_query( Database, Query );
		db_free_result( Result );
		
		format( Query, sizeof( Query ), ">> %s (ID: %d) has kicked %s (ID: %d) for: %s", Kicker, AdminID, Name, PlayerID, Reason );
		SendClientMessageToAll( COLOR_ORANGE, Query );

	    SendClientMessage( PlayerID, COLOR_YELLOW, ">> You have been kicked. Please write this information down ...");

	    format( Query, sizeof( Query ), ">> Admin : %s", Kicker );
	    SendClientMessage( PlayerID, COLOR_ORANGE, Query );

	    format( Query, sizeof( Query ), ">> Time  : %02d:%02d:%02d", t1, t2, t3 );
	    SendClientMessage( PlayerID, COLOR_ORANGE, Query );

	    getdate( t1, t2, t3 );
	    format( Query, sizeof( Query ), ">> Date  : %02d/%02d/%02d", t3, t2, t1 );
	    SendClientMessage( PlayerID, COLOR_ORANGE, Query );

	    format( Query, sizeof( Query ), ">> Reason: %s", Reason );
	    SendClientMessage( PlayerID, COLOR_ORANGE, Query );

	    format( Query, sizeof( Query ), ">> IP    : %s", pIP );
	    SendClientMessage( PlayerID, COLOR_ORANGE, Query );
	    SendClientMessageToAdmins( COLOR_RED, Query );

	    SendClientMessage( PlayerID, COLOR_YELLOW, ">> If you feel you have been WRONGFULLY kicked, please complain in" );
	    SendClientMessage( PlayerID, COLOR_YELLOW, ">> littlewhitey's Complaints at http://gta-mp.littlewhitey.com" );

		Kick( PlayerID );
		printf( "[kick] %s (IP: %s) was kicked by %s for the reason %s.", Name, pIP, Kicker, Reason );
		
		format( Query, sizeof( Query ), "[kickreason] %s %s %s [IP:%s]", Kicker, Name, Reason, pIP );
		add_log( Query );

		return 1;
	}
	else
	{
	    print( "[ERROR] NO DATABASE!" );

	    return 0;
	}
}

stock ReportPlayer( DB:Database, PlayerID, ReporterID, Reason[ ] )
{
	if ( Database )
	{
	    new Query	[ 512 ],
			DBResult:Result,
			Name	[ MAX_PLAYER_NAME ],
			Reporter[ MAX_PLAYER_NAME ],
			pIP		[ 16 ];
			
	    if ( ReporterID == 1000 )
	        Reporter = "-LWBot-";

	    else if ( ReporterID == INVALID_PLAYER_ID )
	        Reporter = "-Unknown-";

	    else
			GetPlayerName( ReporterID, Reporter, MAX_PLAYER_NAME );

	    GetPlayerName( PlayerID, Name, MAX_PLAYER_NAME );
	    GetPlayerIp( PlayerID, pIP, 16 );

		format( Query, sizeof( Query ), "INSERT INTO lva_bans(name,reporter,reason,ip,time,type) values(\
	        '%s', '%s', '%s', '%s', strftime('%%s','now'),0\
		);\
		", Name, Reporter, Reason, pIP );

		Result = db_query( Database, Query );
		db_free_result( Result );
		
		format( Query, sizeof( Query ), "* %s (ID: %d) has been reported by %s (ID: %d) for: %s", Name, PlayerID, Reporter, ReporterID, Reason );
		SendMessageToLevelAndHigher( _:P_LEVEL_MOD, COLOR_RED, Query );
		
		format	( Query, sizeof( Query ), "[report] %d %s %d %s %s", ReporterID, Reporter, PlayerID, Name, Reason );
		add_log	( Query );

		printf( "[report] %s (IP: %s) was reported by %s for the reason %s.", Name, pIP, Reporter, Reason );
		
		return 1;
	}
	else
	{
	    print( "[ERROR] NO DATABASE!" );

	    return 0;
	}
}

stock RegisterGang( DB:Database, Name[ ], Tag[ ] )
{
	new DBResult:Result;

	if ( Database )
	{
	    new Query[ 512 ];

	    format( Query, sizeof( Query ), "SELECT tag FROM lva_gangs WHERE tag='%s'", Tag );
	    Result = db_query( Database, Query );

		if ( !db_num_fields( Result ) )
		{
		    db_free_result( Result );
		    
		    format( Query, sizeof( Query ), "\
			INSERT INTO lva_gangs (name,tag,times_owned_lv,gbank) values(\
				'%s', '%s', 0, 0\
			);\
			", Name, Tag );

		    Result = db_query( Database, Query );
			db_free_result( Result );
			
			return 1;
		}
		else
			return 0;
	}
	else
	{
		print( "[ERROR] NO DATABASE!" );
		return 0;
	}
}

stock encrypt(pass[])
{
	// JSCHash - Created by Y_Less's Dad and Y_Less!
	
	static
		charset[] = "qwertyaQWERTYUIOPZXCVBNMLKJHGFDSAsdfghzxcvbnuiopjklm1324657809_",
		css = 63;
		
	new
		target[MAX_PASSWORD_LENGTH + 1],
		j = strlen(pass);
	new
		sum = j,
		tmp = 0,
		i,
		mod;
		
	for (i = 0; i < MAX_PASSWORD_LENGTH || i < j; i++)
	{
		mod = i % MAX_PASSWORD_LENGTH;
		tmp = (i >= j) ? charset[(7 * i) % css] : pass[i];
		sum = (sum + chrfind(tmp, charset) + 1)		% css;
		target[mod] = charset[(sum + target[mod])	% css];
	}
	target[MAX_PASSWORD_LENGTH] = '\0';
	return target;
}

stock chrfind(needle, haystack[], start = 0)
{
	// Created by Y_Less!
	
	while (haystack[start]) if (haystack[start++] == needle) return start - 1;
	return -1;
}

/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	End Of Include: $scriptname, $author
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/
