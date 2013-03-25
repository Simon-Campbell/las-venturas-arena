/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Include: menu

	20/08/2007, 8:24 p.m
	menu.inc, Simon Campbell
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/

/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Global
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/

#include <a_samp>

#if defined __menu__included
	#endinput
#endif

#define __menu__included

#define INVALID_BANK_MENU	0xFF
#define INVALID_AMMU_MENU   0xFF

enum e_BANK_MENU
{
	Menu:e_BANK_MENU_MAIN_NO_GANG,
	Menu:e_BANK_MENU_MAIN_IN_GANG,
	Menu:e_BANK_MENU_SECONDARY_PERSONAL,
	Menu:e_BANK_MENU_SECONDARY_GANG,
	Menu:e_BANK_MENU_MONEY_TABLE
};

new
	Menu:mBank[ e_BANK_MENU ],
	Menu:mAmmu[ e_AMMUNATION_MENU ],
	Menu:mPropertyOwner,
	Menu:mPropertyBuyer;

/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Functions
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/

stock GenerateMenus( )
{
	// Generate all static menus.

	/* Create the opening bank menu for gangless players
	 * that looks like this:
	 *	24/7
	 *	  ATM
	 *  o Personal
	 *	o -G-a-n-g-
	*/

	mBank[ e_BANK_MENU_MAIN_NO_GANG ] = CreateMenu( "24/7", 1, 29.3, 150.0, 206.0, 0.0 );

	SetMenuColumnHeader	( mBank[ e_BANK_MENU_MAIN_NO_GANG ], 0, "ATM" );
	AddMenuItem			( mBank[ e_BANK_MENU_MAIN_NO_GANG ], 0, "Personal" );
	AddMenuItem			( mBank[ e_BANK_MENU_MAIN_NO_GANG ], 0, "Gang" );
	DisableMenuRow		( mBank[ e_BANK_MENU_MAIN_NO_GANG ], 1 );

	/* Create the opening bank menu for gang players
	 * that looks like this:
	 *	24/7
	 *	  ATM
	 *  o Personal
	 *	o Gang
	*/

	mBank[ e_BANK_MENU_MAIN_IN_GANG ] = CreateMenu( "24/7", 1, 29.3, 150.0, 206.0, 0.0 );

	SetMenuColumnHeader	( mBank[ e_BANK_MENU_MAIN_IN_GANG ], 0, "ATM" );
	AddMenuItem			( mBank[ e_BANK_MENU_MAIN_IN_GANG ], 0, "Personal" );
	AddMenuItem			( mBank[ e_BANK_MENU_MAIN_IN_GANG ], 0, "Gang" );

	/* Create the property menu for the property owner
	 * that looks like this:
	 *  Property
	 *      Owner Control
	 *  o Sell
	 */
	 
	mPropertyOwner = CreateMenu( "Property", 1, 29.3, 150.0, 206.0, 0.0 );
	
	SetMenuColumnHeader	( mPropertyOwner, 0, "Owner Control" );
	AddMenuItem         ( mPropertyOwner, 0, "Sell" );
	
	/* Create the property menu for the purchase
	 * that looks like this:
	 *  Property
	 *		Buyer Control
	 *  o Purchase
	 */

	mPropertyBuyer = CreateMenu( "Property", 1, 29.3, 150.0, 206.0, 0.0 );

	SetMenuColumnHeader	( mPropertyBuyer, 0, "Buyer Control" );
	AddMenuItem         ( mPropertyBuyer, 0, "Purchase" );
	
	/* Create the "Personal ATM" personal menu
	 * that looks like this:
	 *	24/7
	 *	  Personal ATM
	 *  o Deposit
	 *	o Withdraw
	 */

	mBank[ e_BANK_MENU_SECONDARY_PERSONAL ] = CreateMenu( "24/7", 1, 29.3, 150.0, 206.0, 0.0 );

	SetMenuColumnHeader	( mBank[ e_BANK_MENU_SECONDARY_PERSONAL ], 0, "Personal ATM" );
	AddMenuItem			( mBank[ e_BANK_MENU_SECONDARY_PERSONAL ], 0, "Deposit" );
	AddMenuItem			( mBank[ e_BANK_MENU_SECONDARY_PERSONAL ], 0, "Withdraw" );
    AddMenuItem			( mBank[ e_BANK_MENU_SECONDARY_PERSONAL ], 0, " " );
	AddMenuItem         ( mBank[ e_BANK_MENU_SECONDARY_PERSONAL ], 0, "Deposit All" );
	AddMenuItem         ( mBank[ e_BANK_MENU_SECONDARY_PERSONAL ], 0, "Withdraw All" );
	
	DisableMenuRow		( mBank[ e_BANK_MENU_SECONDARY_PERSONAL ], 2 );

	/* Create the "Gang ATM" gang menu
	 * that looks like this:
	 *	24/7
	 *	  Gang ATM
	 *  o Deposit
	 *	o Withdraw
	 */

	mBank[ e_BANK_MENU_SECONDARY_GANG ] = CreateMenu( "24/7", 1, 29.3, 150.0, 206.0, 0.0 );

	SetMenuColumnHeader	( mBank[ e_BANK_MENU_SECONDARY_GANG ], 0, "Gang ATM" );

	AddMenuItem			( mBank[ e_BANK_MENU_SECONDARY_GANG ], 0, "Deposit" );
	AddMenuItem			( mBank[ e_BANK_MENU_SECONDARY_GANG ], 0, "Withdraw" );
	AddMenuItem			( mBank[ e_BANK_MENU_SECONDARY_GANG ], 0, " " );
	AddMenuItem         ( mBank[ e_BANK_MENU_SECONDARY_GANG ], 0, "Deposit All" );
	AddMenuItem         ( mBank[ e_BANK_MENU_SECONDARY_GANG ], 0, "Withdraw All" );
	
	DisableMenuRow		( mBank[ e_BANK_MENU_SECONDARY_GANG ], 2 );
	
	/* Create the money table for selection of money values.
	 *	24/7
	 *	  Money Table
	 *  o $1
	 *	o $10
	 *	o $100
	 *	o $1000
	 *	o $10000
	 *	o $100000
	 *	o $1000000
	 *	o $10000000
	 *	o $100000000
	 */

	mBank[ e_BANK_MENU_MONEY_TABLE ] = CreateMenu( "24/7", 1, 29.3, 133.3, 206.0, 0.0 );

	SetMenuColumnHeader	( mBank[ e_BANK_MENU_MONEY_TABLE ], 0, "Money Table" );

	AddMenuItem			( mBank[ e_BANK_MENU_MONEY_TABLE ], 0, "$1" );
//	AddMenuItem			( mBank[ e_BANK_MENU_MONEY_TABLE ], 0, "$2" );
	AddMenuItem			( mBank[ e_BANK_MENU_MONEY_TABLE ], 0, "$10" );
//	AddMenuItem			( mBank[ e_BANK_MENU_MONEY_TABLE ], 0, "$20" );
	AddMenuItem			( mBank[ e_BANK_MENU_MONEY_TABLE ], 0, "$100" );
	AddMenuItem			( mBank[ e_BANK_MENU_MONEY_TABLE ], 0, "$1000" );
	AddMenuItem			( mBank[ e_BANK_MENU_MONEY_TABLE ], 0, "$10000" );
	AddMenuItem			( mBank[ e_BANK_MENU_MONEY_TABLE ], 0, "$100000" );
	AddMenuItem			( mBank[ e_BANK_MENU_MONEY_TABLE ], 0, "$1000000" );
	AddMenuItem			( mBank[ e_BANK_MENU_MONEY_TABLE ], 0, "$10000000" );
	AddMenuItem			( mBank[ e_BANK_MENU_MONEY_TABLE ], 0, "$100000000" );
	
	// Create the Ammunation Main Menu

	mAmmu[ AMMU_MENU_MAIN ] = CreateMenu( "Ammunation", 1, 29.3, 133.3, 206.0, 0.0 );
	
	SetMenuColumnHeader	( mAmmu[ AMMU_MENU_MAIN ], 0, "Weapon Types" );

	AddMenuItem			( mAmmu[ AMMU_MENU_MAIN ], 0, "Pistols" );
	AddMenuItem			( mAmmu[ AMMU_MENU_MAIN ], 0, "Micro SMGs" );
	AddMenuItem			( mAmmu[ AMMU_MENU_MAIN ], 0, "Shotguns" );
//	AddMenuItem			( mAmmu[ AMMU_MENU_MAIN ], 0, "Thrown" );
//	AddMenuItem			( mAmmu[ AMMU_MENU_MAIN ], 0, "Armor" );
	AddMenuItem			( mAmmu[ AMMU_MENU_MAIN ], 0, "SMG" );
	AddMenuItem			( mAmmu[ AMMU_MENU_MAIN ], 0, "Rifles" );
	AddMenuItem			( mAmmu[ AMMU_MENU_MAIN ], 0, "Assault" );
	
	// Generate all the sub menu's
	
	GenerateWeaponMenu  ( "Pistols",	MENU_PISTOLS );
	GenerateWeaponMenu  ( "Micro SMGs",	MENU_MICRO_SMGS );
	GenerateWeaponMenu  ( "Shotguns",	MENU_SHOTGUNS );
	GenerateWeaponMenu  ( "SMG",		MENU_SMG );
	GenerateWeaponMenu  ( "Rifles",		MENU_RIFLES );
	GenerateWeaponMenu  ( "Assault",	MENU_ASSAULT );

	return 1;
}

stock GenerateWeaponMenu( name[ ], Menu:type )
{
	new
		tString[ 128 ];

	mAmmu[ type ] = CreateMenu( "Ammunation", 2, 29.3, 133.3, 206.0, 0.0 );

	SetMenuColumnHeader ( mAmmu[ type ], 0, name );
	SetMenuColumnHeader ( mAmmu[ type ], 1, "Bullets - Price" );

	for ( new i = 0; i < sizeof( sWeapons ); i++ )
	{
	    if ( sWeapons[ i ][ WEAPON_SPAWN_WEAPON ] == _:type )
	    {
			format( tString, sizeof( tString ), "%d - $%d", sWeapons[ i ][ WEAPON_AMMO ], floatround( floatmul( sWeapons[ i ][ WEAPON_PRICE ], SPAWN_PRICE_RATIO ), floatround_round ) );
			
			AddMenuItem ( mAmmu[ type ], 0, sWeapons[ i ][ WEAPON_NAME ] );
			AddMenuItem ( mAmmu[ type ], 1, tString );
	    }
	}
}

stock ShowWeaponMenu( playerid )
{
	TogglePlayerControllable( playerid, 0 );
	
	pData[ playerid ][ P_ACTIVITY ] = _:P_ACTIVITY_AMMU_MAIN;
	
	ShowMenuForPlayer( mAmmu[ AMMU_MENU_MAIN ], playerid );
	
	return 1;
}

stock OnPlayerSelectedWeaponRow( playerid, Menu:aMenuID, row )
{
	new
		pMoney = GetPlayerMoney( playerid ), c, wprice;
	
	if ( aMenuID == mAmmu[ AMMU_MENU_MAIN ] )
	{
		switch ( row )
		{
			case 0: { ShowMenuForPlayer	( mAmmu[ MENU_PISTOLS ],	playerid ); pData[ playerid ][ P_ACTIVITY ] = _:P_ACTIVITY_AMMU_PISTOLS; }
			case 1: { ShowMenuForPlayer	( mAmmu[ MENU_MICRO_SMGS ],	playerid ); pData[ playerid ][ P_ACTIVITY ] = _:P_ACTIVITY_AMMU_MICRO_SMGS; }
			case 2: { ShowMenuForPlayer	( mAmmu[ MENU_SHOTGUNS ],	playerid ); pData[ playerid ][ P_ACTIVITY ] = _:P_ACTIVITY_AMMU_SHOTGUNS; }
			case 3: { ShowMenuForPlayer	( mAmmu[ MENU_SMG ],		playerid ); pData[ playerid ][ P_ACTIVITY ] = _:P_ACTIVITY_AMMU_SMG; }
			case 4: { ShowMenuForPlayer	( mAmmu[ MENU_RIFLES ],		playerid ); pData[ playerid ][ P_ACTIVITY ] = _:P_ACTIVITY_AMMU_RIFLES; }
			case 5: { ShowMenuForPlayer	( mAmmu[ MENU_ASSAULT ],	playerid ); pData[ playerid ][ P_ACTIVITY ] = _:P_ACTIVITY_AMMU_ASSAULT; }
		}
	}
	else if ( aMenuID == mAmmu[ MENU_PISTOLS ] )
	{
		switch ( row )
		{
			case 0: c = WEAPON_COLT45;
			case 1: c = WEAPON_SILENCED;
			case 2: c = WEAPON_DEAGLE;
		}
		ShowMenuForPlayer( mAmmu[ MENU_PISTOLS ], playerid );
	}
	else if ( aMenuID == mAmmu[ MENU_MICRO_SMGS ] )
	{
		switch ( row )
		{
			case 0: c = WEAPON_UZI;
			case 1: c = WEAPON_TEC9;
		}
		ShowMenuForPlayer( mAmmu[ MENU_MICRO_SMGS ], playerid );
	}
	else if ( aMenuID == mAmmu[ MENU_SHOTGUNS ] )
	{
		switch ( row )
		{
			case 0: c = WEAPON_SHOTGUN;
			case 1: c = WEAPON_SAWEDOFF;
			case 2: c = WEAPON_SHOTGSPA;
		}
		ShowMenuForPlayer( mAmmu[ MENU_SHOTGUNS ], playerid );
	}
	else if ( aMenuID == mAmmu[ MENU_SMG ] )
	{
		switch ( row )
		{
			case 0: c = WEAPON_MP5;
		}
		ShowMenuForPlayer( mAmmu[ MENU_SMG ], playerid );
	}
	else if ( aMenuID == mAmmu[ MENU_RIFLES ] )
	{
		switch ( row )
		{
			case 0: c = WEAPON_RIFLE;
			case 1: c = WEAPON_SNIPER;
		}
		ShowMenuForPlayer( mAmmu[ MENU_RIFLES ], playerid );
	}
	else if ( aMenuID == mAmmu[ MENU_ASSAULT ] )
	{
		switch ( row )
		{
			case 0: c = WEAPON_AK47;
			case 1: c = WEAPON_M4;
		}
		
		ShowMenuForPlayer( mAmmu[ MENU_ASSAULT ], playerid );
	}
	else return 0;
	
	if ( c )
	{
	    new
			slot = GetWeaponSlot( c );
	        
		wprice = floatround( floatmul( sWeapons[ c ][ WEAPON_PRICE ], SPAWN_PRICE_RATIO ), floatround_round );

		if ( pMoney >= wprice && ( pData[ playerid ][ P_SPAWN_AMMO ][ slot ] + sWeapons[ c ][ WEAPON_AMMO ] ) <= 9999 )
		{
			AC_GivePlayerMoney		( playerid,	-wprice );
			
			#if MODE_PROTECTED_WEAPONS == 0
			if ( !pData[ playerid ][ P_NO_WEAPON_AREA ] )
				GivePlayerWeapon( playerid, c, sWeapons[ c ][ WEAPON_AMMO ] );
			
			else
			{
			    pData[ playerid ][ P_TEMP_WEAPONS ][ slot ] =	c;
			    pData[ playerid ][ P_TEMP_AMMO ][ slot ]    +=	sWeapons[ c ][ WEAPON_AMMO ];
			}
			#else
			GivePlayerWeapon( playerid, c, sWeapons[ c ][ WEAPON_AMMO ] );
			#endif
			pData[ playerid ][ P_SPAWN_WEAPONS ][ slot ]	=  c;
			pData[ playerid ][ P_SPAWN_AMMO ][ slot ]		+= sWeapons[ c ][ WEAPON_AMMO ];
		}
		
		return 1;
	}
	else return 0;
}

stock ShowBankMenu( playerid )
{
	TogglePlayerControllable( playerid, 0 );
	
    pData[ playerid ][ P_ACTIVITY ] = _:P_ACTIVITY_BANK;
    
    TextDrawHideForPlayer( playerid, pData[ playerid ][ P_BANK_TEXT ] );
	TextDrawShowForPlayer( playerid, pData[ playerid ][ P_BANK_TEXT ] );
    
	if ( !IsPlayerInAnyGang( playerid ) )
		ShowMenuForPlayer( mBank[ e_BANK_MENU_MAIN_NO_GANG ], playerid );
	else
	{
		ShowMenuForPlayer( mBank[ e_BANK_MENU_MAIN_IN_GANG ], playerid );
		TextDrawHideForPlayer( playerid, gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK_TEXT ] );
		TextDrawShowForPlayer( playerid, gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK_TEXT ] );
	}
		
	return 1;
}

stock GetBankMenuID( Menu:MenuID )
{
	for ( new bMenuID = 0; bMenuID < _:e_BANK_MENU; bMenuID++ )
	{
		if ( mBank[ e_BANK_MENU:bMenuID ] == MenuID )
			return bMenuID;
	}
	return INVALID_BANK_MENU;
}

stock ShowPropertyMenu( playerid )
{
	new
		iPropertyID = pData[ playerid ][ P_CHECKPOINT_AREA ] - _:CP_ZIP;
		
    TogglePlayerControllable( playerid, 0 );
    
    pData[ playerid ][ P_ACTIVITY ] = _:P_ACTIVITY_PROPERTY;
    
    if ( gPropertyData[ iPropertyID ][ PROPERTY_OWNER ] == playerid )
		ShowMenuForPlayer( mPropertyOwner, playerid );
        
	else if ( gPropertyData[ iPropertyID ][ PROPERTY_CAN_BE_BOUGHT ] )
		ShowMenuForPlayer( mPropertyBuyer, playerid );
}

stock OnPlayerSelectedPropertyRow( playerid, Menu:menu, row )
{
	#pragma unused row
	
	if ( menu != mPropertyBuyer && menu != mPropertyOwner )
		return 0;
		
	new
		iPropertyID = pData[ playerid ][ P_CHECKPOINT_AREA ] - _:CP_ZIP;

	if ( gPropertyData[ iPropertyID ][ PROPERTY_OWNER ] == playerid )
	{
		// Player owns the property so he could be selling it!
		
	    gPropertyData[ iPropertyID ][ PROPERTY_OWNER ]			= INVALID_PLAYER_ID;
	    gPropertyData[ iPropertyID ][ PROPERTY_CAN_BE_BOUGHT ]	= 1;

		AC_GivePlayerMoney	( playerid, gPropertyData[ iPropertyID ][ PROPERTY_PRICE ] );
		
		ShowMenuForPlayer	( mPropertyBuyer, playerid );
	}
	
	else
	{
		if ( gPropertyData[ iPropertyID ][ PROPERTY_CAN_BE_BOUGHT ] )
		{
			// Not owner so this means he could be buying it!
		    
		    new
				iMoney = GetPlayerMoney( playerid );

			if ( iMoney < gPropertyData[ iPropertyID ][ PROPERTY_PRICE ] )
				ShowMenuForPlayer( mPropertyBuyer, playerid );

			else
			{
				AC_GivePlayerMoney( playerid, -gPropertyData[ iPropertyID ][ PROPERTY_PRICE ] );
			    
			    if ( gPropertyData[ iPropertyID ][ PROPERTY_OWNER ] != INVALID_PLAYER_ID )
			    {
			        new
						szString[ 128 ];
			        
					GetPlayerName	( playerid, szString, MAX_PLAYER_NAME );
					format			( szString, sizeof( szString ), "* Your property, the %s has been bought out by %s (ID:%d).", gPropertyData[ iPropertyID ][ PROPERTY_NAME ], szString, playerid );
			        
					SendClientMessage	( gPropertyData[ iPropertyID ][ PROPERTY_OWNER ], COLOR_ORANGE, szString );
					AC_GivePlayerMoney	( gPropertyData[ iPropertyID ][ PROPERTY_OWNER ], gPropertyData[ iPropertyID ][ PROPERTY_PRICE ] );
			    }
			    
			    ShowMenuForPlayer( mPropertyOwner, playerid );
			    
				gPropertyData[ iPropertyID ][ PROPERTY_OWNER ]			= playerid;
			    gPropertyData[ iPropertyID ][ PROPERTY_CAN_BE_BOUGHT ]  = 0;
				gPropertyData[ iPropertyID ][ PROPERTY_TICKS ]			= gPropertyData[ iPropertyID ][ PROPERTY_TIME ];
			}
		}
		
		else
			ShowMenuForPlayer( mPropertyBuyer, playerid );
	}
	
	return 1;
}

stock OnPlayerSelectedBankRow( playerid, e_BANK_MENU:bMenuID, row )
{
	new c = 0;
	
	switch ( bMenuID )
	{
		case e_BANK_MENU_MAIN_NO_GANG:
		{
			ShowMenuForPlayer( mBank[ e_BANK_MENU_SECONDARY_PERSONAL ], playerid );
		}

		case e_BANK_MENU_MAIN_IN_GANG:
		{
			switch ( row )
			{
				case 0:	ShowMenuForPlayer( mBank[ e_BANK_MENU_SECONDARY_PERSONAL ], playerid );
				case 1:	ShowMenuForPlayer( mBank[ e_BANK_MENU_SECONDARY_GANG ], playerid );
			}
		}

		case e_BANK_MENU_SECONDARY_PERSONAL:
		{
			switch ( row )
			{
				case 0:
				{
					pData[ playerid ][ P_ACTIVITY ] = _:P_BANK_DEPOSIT;
					
					ShowMenuForPlayer( mBank[ e_BANK_MENU_MONEY_TABLE ], playerid );
				}
				case 1:
				{
					pData[ playerid ][ P_ACTIVITY ] = _:P_BANK_WITHDRAW;
					
					ShowMenuForPlayer( mBank[ e_BANK_MENU_MONEY_TABLE ], playerid );
					
				}
				case 3:
				{	// Deposit All (pbank)
				
				    new
						pMoney = GetPlayerMoney( playerid );
				    
				    if ( pMoney > 0 )
				    {
						if ( pData[ playerid ][ P_BANK ] < PERSONAL_BANK_LIMIT )
						{
							if ( ( pMoney + pData[ playerid ][ P_BANK ] ) > PERSONAL_BANK_LIMIT )
								pMoney = ( PERSONAL_BANK_LIMIT - pData[ playerid ][ P_BANK ] );

                            AC_GivePlayerMoney( playerid, -pMoney );
							pData[ playerid ][ P_BANK ] += pMoney;
						}
					}

					// Hide the bank text for the player.
					TextDrawHideForPlayer( playerid, pData[ playerid ][ P_BANK_TEXT ] );

					// If IsPlayerInAnyGang then hide the gang bank text.
					if ( IsPlayerInAnyGang( playerid ) )
						TextDrawHideForPlayer( playerid, gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK_TEXT ] );

					ShowBankMenu( playerid );

					c = 1;
				}
				case 4:
				{	// Withdraw All (pbank)
				
				    if ( pData[ playerid ][ P_BANK ] > 0 )
				    {
					    AC_GivePlayerMoney( playerid, pData[ playerid ][ P_BANK ] );
						pData[ playerid ][ P_BANK ] = 0;
					}

					// Hide the bank text for the player.
					TextDrawHideForPlayer( playerid, pData[ playerid ][ P_BANK_TEXT ] );

					// If IsPlayerInAnyGang then hide the gang bank text.
					if ( IsPlayerInAnyGang( playerid ) )
						TextDrawHideForPlayer( playerid, gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK_TEXT ] );

					ShowBankMenu( playerid );

					c = 1;
				}
			}
		}

		case e_BANK_MENU_SECONDARY_GANG:
		{
			switch ( row )
			{
				case 0:
				{
					pData[ playerid ][ P_ACTIVITY ] = _:G_BANK_DEPOSIT;

					ShowMenuForPlayer( mBank[ e_BANK_MENU_MONEY_TABLE ], playerid );
				}
				case 1:
				{
					pData[ playerid ][ P_ACTIVITY ] = _:G_BANK_WITHDRAW;

					ShowMenuForPlayer( mBank[ e_BANK_MENU_MONEY_TABLE ], playerid );
				}
				case 3:
				{
					// Deposit All (gbank)
					
				    new
						pMoney = GetPlayerMoney( playerid );

					if ( pMoney > 0 )
					{
						if ( IsPlayerInAnyGang( playerid ) && gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK ] < GANG_BANK_LIMIT )
						{
							if ( ( pMoney + gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK ] ) > GANG_BANK_LIMIT )
								pMoney = ( GANG_BANK_LIMIT - gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK ] );
							
                            AC_GivePlayerMoney( playerid, -pMoney );
							gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK ] += pMoney;
						}
 					}

					// Hide the bank text for the player.
					TextDrawHideForPlayer( playerid, pData[ playerid ][ P_BANK_TEXT ] );

					// If IsPlayerInAnyGang then hide the gang bank text.
					if ( IsPlayerInAnyGang( playerid ) )
						TextDrawHideForPlayer( playerid, gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK_TEXT ] );

					ShowBankMenu( playerid );

					c = 2;
				}
				case 4:
				{	// Withdraw All (gbank)
					if ( gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK ] > 0 )
					{
					        
						AC_GivePlayerMoney( playerid, gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK ] );
						gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK ] = 0;
					}

					// Hide the bank text for the player.
					TextDrawHideForPlayer( playerid, pData[ playerid ][ P_BANK_TEXT ] );

					// If IsPlayerInAnyGang then hide the gang bank text.
					if ( IsPlayerInAnyGang( playerid ) )
						TextDrawHideForPlayer( playerid, gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK_TEXT ] );

					ShowBankMenu( playerid );

					c = 2;
				}
			}
		}

		case e_BANK_MENU_MONEY_TABLE:
		{
			new
				pMoney = GetPlayerMoney( playerid ),
				mMoney = power( 10, row );

			if ( pData[ playerid ][ P_ACTIVITY ] == _:P_BANK_DEPOSIT )
			{
				if ( pData[ playerid ][ P_BANK ] < PERSONAL_BANK_LIMIT )
				{
				    if ( ( mMoney + pData[ playerid ][ P_BANK ] ) > PERSONAL_BANK_LIMIT )
				        mMoney = ( PERSONAL_BANK_LIMIT - pData[ playerid ][ P_BANK ] );
				}
				else
					return ShowBankMenu(playerid);
   			}

   			else if ( pData[ playerid ][ P_ACTIVITY ] == _:G_BANK_DEPOSIT )
   			{
   			    if ( !IsPlayerInAnyGang( playerid ) )
						return ShowBankMenu( playerid );
						
				if ( gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK ] < GANG_BANK_LIMIT )
				{
				    if ( ( mMoney + gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK ] ) > GANG_BANK_LIMIT )
				        mMoney = ( GANG_BANK_LIMIT - gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK ] );
				}
				else
					return ShowBankMenu(playerid);
			}

			switch ( pData[ playerid ][ P_ACTIVITY ] )
			{
				case P_BANK_DEPOSIT :
				{
					if ( pMoney >= mMoney )
					{
						pData[ playerid ][ P_BANK ] += mMoney;
						AC_GivePlayerMoney( playerid, -mMoney );
						ShowMenuForPlayer( mBank[ e_BANK_MENU_MONEY_TABLE ], playerid );
						
						c = 1;
					}
				}
				case P_BANK_WITHDRAW:
				{
					if ( pData[ playerid ][ P_BANK ] >= mMoney )
					{
						pData[ playerid ][ P_BANK ] -= mMoney;
						AC_GivePlayerMoney( playerid, mMoney );
						ShowMenuForPlayer( mBank[ e_BANK_MENU_MONEY_TABLE ], playerid );
						
						c = 1;
					}
				}
				case G_BANK_DEPOSIT:
				{
				    if ( !IsPlayerInAnyGang( playerid ) )
				    {
						ShowBankMenu( playerid );
				        return 0;
					}
				        
				    if ( pMoney >= mMoney )
				    {
				        gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK ] += mMoney;
						AC_GivePlayerMoney( playerid, -mMoney );
						ShowMenuForPlayer( mBank[ e_BANK_MENU_MONEY_TABLE ], playerid );
						
						c = 2;
					}
				}

				case G_BANK_WITHDRAW:
				{
				    if ( !IsPlayerInAnyGang( playerid ) )
				    {
						ShowBankMenu( playerid );
				        return 0;
					}
				        
                    if ( gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK ] >= mMoney )
				    {
				        gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK ] -= mMoney;
						AC_GivePlayerMoney( playerid, mMoney );
						ShowMenuForPlayer( mBank[ e_BANK_MENU_MONEY_TABLE ], playerid );
						
						c = 2;
					}
				}
			}
			ShowMenuForPlayer( mBank[ e_BANK_MENU_MONEY_TABLE ], playerid );
		}
	}
	
	if ( c == 1 )
	{
		pData[ playerid ][ P_BANK_TEXT ] = CreateBankText( playerid );
	}

	if ( c == 2 && IsPlayerInAnyGang( playerid ) )
	{
		gData[ pData[ playerid ][ P_GANG_ID ] ][ G_BANK_TEXT ] = CreateGangBankText( pData[ playerid ][ P_GANG_ID ] );
	}
	
	return 1;
}

/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	End Of Include: menu.inc, Simon Campbell
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/
