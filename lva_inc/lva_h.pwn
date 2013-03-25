//******************************************************************************
//	LVA Header File
//******************************************************************************

//******************************************************************************
//	Includes: Generic
//******************************************************************************

#include <a_samp>					// Includes all Generic SA:MP functions.

#include "lva_inc\gen\color.pwn"	// Includes Colour setting and manipulation functions.
#include "lva_inc\gen\global.pwn"	// Includes Global functions, defines and macros.
#include "lva_inc\gen\ctype.pwn"	// Includes Character checking functions

//******************************************************************************
//  Defines / Constants
//******************************************************************************

// * Generic Redefinitions *****************************************************

#undef	MAX_PLAYERS
#define	MAX_PLAYERS         200

#undef	INVALID_TEXT_DRAW
#define INVALID_TEXT_DRAW	Text:0xFFFF

#undef	INVALID_MENU
#define INVALID_MENU        Menu:0xFF

#undef  COLOR_GREEN
#define COLOR_GREEN         0x00CC00FF

#undef	COLOR_GREY
#define	COLOR_GREY			0xC0C0C0FF

// * Macros ********************************************************************

#define LOOP_TYPE   0

#if LOOP_TYPE == 0
	#define	loopPlayers(%1)\
			for (new %1=0;%1<sMaxPlayers;%1++) if(IsPlayerConnected(%1))
#else
	#define	loopPlayers(%1)\
			for(new %1=g_iLastJoinedPlayerID; %1!=INVALID_PLAYER_ID; %1=pData[%1][P_LIST_PREVIOUS_ID])
#endif

// * Colours *******************************************************************

#define COLOR_ZONE_DEFAULT	0x00000080

// * Integers ******************************************************************

#define MAX_SAVES           64
#define MAX_WEAPON_SLOT		13
#define MAX_RANDOM_PICKUPS  16
#define MAX_SCRIPT_ZONES    25
#define MAX_GANG_NAME		16
#define MAX_GANGS       	16
#define MAX_ZONE_TICKS		120	// 120 = 2 minutes.
#define MAX_GANG_MEMBERS    16
#define MAX_CLIENT_MSG      128

#define DEFAULT_PICKUP_TYPE 3
#define WEP_LIMIT           150
#define POCKET_MONEY		500
#define START_WEAPON        24
#define START_AMMO          300
#define TEAM_INTERIOR		222
#define SPAWN_PRICE_RATIO	3.25
#define SHIP_CASH_DEFAULT   10
#define SHIP_CASH_INCREASE  5
#define PERSONAL_BANK_LIMIT	5000000
#define GANG_BANK_LIMIT		50000000

#define NEW_PIRATE_MODE		false
#define RANDOM_PICKUPS		false

#define VERSION_MAJOR		2
#define VERSION_MINOR		5
#define VERSION_BUILD		696
#define VERSION_LITE        false

#define MODE_PROTECTED_WEAPONS  1

// * Booleans ******************************************************************

#define TEXT_DRAWS_INSTEAD_OF_CLIENT_MESSAGES	false
#define ADMIN_SPAWN_COMMAND						true

// * Strings *******************************************************************

#define	sWelcomeGTXT		"~w~<NAME>'s~n~~y~SA-MP Server"
#define gWelcomeMSG1		"" #SZ_GAMEMODE_L_NAME  " (" #SZ_GAMEMODE_S_NAME ")"
#define gWelcomeMSG2		"Type /help to get started."

#define SZ_GAMEMODE_L_NAME	"Las Venturas Arena"
#define SZ_GAMEMODE_S_NAME  "LVA"
#define SZ_SQLITE_DB		"lva_gm.db"

//******************************************************************************
//  Enumerations
//******************************************************************************
		
enum e_P_DATA
{
    P_LIST_NEXT_ID,
	P_LIST_PREVIOUS_ID,
	P_REGISTERED,
	P_SEND_TO_CLASS_SELECT,
	P_RETURNING_SPAWN,
	P_ADMIN_SPAWN,
	P_RESAVE_TICKS,
	P_LOGGED_IN,
	P_LOGIN_ATTEMPTS,
	P_USERID,
	P_LEVEL,
	P_DROP_WARNED,
	P_MONEY,
	P_ACCOUNT_BAN,
	P_KILLS,
	P_DEATHS,
	P_KILL_SPREE,
	P_BANK,
	P_BOUNTY,
	P_SHIP_CASH,
	P_SKIN,
	P_GANG_VOTE,
	P_TRACKING_ID,
	P_GANG_ID,
	P_GANG_POS,
	P_GANG_INVITE,
	P_MUTE,
	P_ONLINE_TICKS,
	P_GANG_ZONE,
	P_IN_ZONE,
	P_LAST_PM_ID,
	P_SCRIPT_MONEY,
	P_NO_WEAPON_AREA,
	P_CHECKPOINT_AREA,
	P_IN_CHECKPOINT,
	P_PIZZA_PAYMENT,
	P_PIZZA_TICKS,
	P_ACTIVITY,
	P_SEEN_CLASS_SELECT,					// A check for "if" the player has already had the class text shown.
	P_FULLY_CONNECTED,
	P_INVINCIBLE_TICKS,
	P_SPAWN_WEAPONS	[ MAX_WEAPON_SLOT ],	// (pWeapons)	= Spawn Weapon IDs
	P_SPAWN_AMMO	[ MAX_WEAPON_SLOT ],	// (pWeapons)	= Spawn Weapon Ammo
	P_TEMP_WEAPONS	[ MAX_WEAPON_SLOT ],	// (pWeapon)	= Weapons (weaponid) the player has, used to give weapons back on reconnect (NOT purchased spawn weapons).
	P_TEMP_AMMO     [ MAX_WEAPON_SLOT ],	// (pAmmo)		= The amount of ammo a player has for pWeapon (NOT purchased spawn weapons).
	Text:	P_BANK_TEXT,
	Float:	P_ARMOR,
	Float:	P_HEALTH
};

enum e_P_LEVEL
{
	P_LEVEL_NOT_LOGGED = -1,
	P_LEVEL_NONE,
	P_LEVEL_MOD,
	P_LEVEL_ADMIN,
	P_LEVEL_SERVER
};

enum e_T_DATA
{
	T_NAME[ MAX_PLAYER_NAME ],
	T_MONEY,
	T_BANK,
	T_BOUNTY,
	T_KILLS,
	T_DEATHS,
	T_SKIN,
	T_TICKS,
	T_MUTE,
	T_SPAWN_WEAPONS [ MAX_WEAPON_SLOT ], // (tWeapons)= Spawn Weapons
	T_SPAWN_AMMO    [ MAX_WEAPON_SLOT ], // (tWeapons)= Spawn Weapons
	T_TEMP_WEAPONS  [ MAX_WEAPON_SLOT ], // (tWeapon) = Temporary player weapon storage (NOT purchased spawn weapons).
	T_TEMP_AMMO     [ MAX_WEAPON_SLOT ], // (tAmmo)   = Temporary player ammo storage (NOT purchased spawn weapons).
	Float:	T_ARMOR,
	Float:	T_HEALTH
};

enum e_ACTIVITY
{
	P_ACTIVITY_NONE,
	P_ACTIVITY_BANK,
	P_BANK_DEPOSIT,
	P_BANK_WITHDRAW,
	G_BANK_DEPOSIT,
	G_BANK_WITHDRAW,
	P_ACTIVITY_AMMU_MAIN,
	P_ACTIVITY_AMMU_PISTOLS,
	P_ACTIVITY_AMMU_MICRO_SMGS,
	P_ACTIVITY_AMMU_SHOTGUNS,
	P_ACTIVITY_AMMU_SMG,
	P_ACTIVITY_AMMU_RIFLES,
	P_ACTIVITY_AMMU_ASSAULT,
	P_ACTIVITY_PROPERTY
};

enum e_CHECKPOINT
{
	CP_WEAPONS,
	CP_INT_ID,
	Float:CP_MIN_X,
	Float:CP_MIN_Y,
	Float:CP_MIN_Z,
	Float:CP_MAX_X,
	Float:CP_MAX_Y,
	Float:CP_MAX_Z,
	Float:CP_POS_X,
	Float:CP_POS_Y,
	Float:CP_POS_Z,
	Float:CP_SIZE
};

enum e_GANG_ZONES
{
    Text:G_ZONE_TEXT,
    G_ZONE_ID,
    G_ZONE_OWNER,
	G_ZONE_COLOR,
	G_ZONE_WAR,
	G_ZONE_TIMER,
	Float:G_ZONE_MINX,
	Float:G_ZONE_MINY,
	Float:G_ZONE_MAXX,
	Float:G_ZONE_MAXY,
};

enum e_CP_ID
{
	CP_LIBERTY,
//	CP_PIZZA_HOME,
//	CP_PIZZA_DELIVER,
	CP_S_BANK,
	CP_L_BANK,
	CP_L_AMMUNATION,
	CP_M_AMMUNATION,
	CP_S_AMMUNATION,
	CP_ZIP,
	CP_SOUTH_STRIP_CLUB,
	CP_BINCO,
	CP_SEX_SHOP,
	CP_NORTH_STRIP_CLUB,
	CP_LV_GYM,
	CP_SMALL_CASINO,
	CP_SUBURBAN,
	CP_VICTIM,
	CP_PROLAPS,
	CP_CALIGULAS,
	CP_FOUR_DRAGONS,
	CP_TATTOO,
	CP_BARBER,
	CP_LIL_PROBE_INN,
	CP_SHITHOLE_BAR,
	CP_PLANNING_DEPT,
	CP_DANCE_CLUB,
	CP_BURGER_SHOT,
	CP_CLUCKIN_BELL,
	CP_PIZZA_STACK,
	CP_DIDIER_SACHS//,
//	CP_GTA_HOST
};

enum e_WEAPONS
{
	WEAPON_SPAWN_WEAPON,
	WEAPON_NAME[ 32 ],
	WEAPON_AMMO,
	WEAPON_PRICE
};

enum e_PROPERTY
{
	PROPERTY_NAME[ 32 ],
	PROPERTY_PRICE,
	PROPERTY_PAYMENT,
	PROPERTY_OWNER,
	PROPERTY_TIME,          // Seconds
	PROPERTY_TICKS,			// Seconds
	PROPERTY_CAN_BE_BOUGHT
};

enum e_MP
{
	Float:MP_X,
	Float:MP_Y,
	Float:MP_Z,
	MP_NAME[ 32 ],
	Float:MP_RANGE
};

enum Menu:e_AMMUNATION_MENU
{
	Menu:MENU_NONE,		// Weapon has no menu and is unable to be purchased.
	Menu:AMMU_MENU_MAIN,	// Main Menu
	Menu:MENU_PISTOLS,	// Weapon is found in "Pistols" menu.
	Menu:MENU_MICRO_SMGS,// Weapon is found in "Micro SMGs" menu.
	Menu:MENU_SHOTGUNS,	// Weapon is found in "Shotguns" menu.
	Menu:MENU_THROWN,	// Weapon is found in "Thrown" menu.
	Menu:MENU_ARMOR,		// Weapon is found in "Armor" menu.
	Menu:MENU_SMG,		// Weapon is found in "SMG" menu.
	Menu:MENU_RIFLES,    // Weapon is found in "Rifles" menu.
	Menu:MENU_ASSAULT	// Weapon is found in "Assault" menu.
};

//******************************************************************************
//	Variables
//******************************************************************************

stock
	// Current save position for temporary data.
	sSave,

	// A variable for if the server is muted or not.
	sMute,

	// Pickup ID for the beer at the ShitHole bar.
	sBeer = -1,

	sMaxPlayers = MAX_PLAYERS,

	#if NEW_PIRATE_MODE == true
	// PlayerID for the owner of the Pirate Ship.
	sPirateOwner		= INVALID_PLAYER_ID,

	// Pickup ID for the Pirate Ship briefcase.
	sPirateBriefcase	= -1,
	
	// Object ID for the Pirate Ship briefcase.
	sPirateBriefcaseObj	= -1,
	#endif
	
	// The playerid for the last joined player.
	g_iLastJoinedPlayerID= INVALID_PLAYER_ID,

	// Amount of players that joined the server during
	// the gamemode's current session.
	g_iTotalPlayerCnt,
	
	// The current amount of players connect to the server.
	g_iCurrentPlayerCnt,
	
	// Pickup ID for the marker at the Pirate Ship.
	sPirate		= -1,

	// Pickup IDs for the markers in the Strip Clubs.
	sStrip[ 2 ] = { -1, -1 },

	// Variable for if the gamemode is restarting.
	sGameModeExit,

	// Timer ID's.
	sTimerIDs[ 5 ]	= -1,

	// Includes most (soon to be all) of the players data.
	pData			[ MAX_PLAYERS ][ e_P_DATA ],

	// Includes most of the temporary data storage.
	tData			[ MAX_SAVES ][ e_T_DATA ],

	// Stores data for how many ticks a zone has left and how
	// many players in a zone for each gang.
	//  zTicks[ gangid ][ zoneid ][ Ticks(0) | Players(1) ]
	#if VERSION_LITE == false
	zTicks			[ MAX_GANGS ][ MAX_SCRIPT_ZONES ][ 2 ],
	#endif

	// Stores data for how many deaths and kills a gang has in
	// each zone.
	//		zDeaths[ gangid ][ Kills(0) | Deaths(1) ]
	#if VERSION_LITE == false
	zDeaths			[ MAX_GANGS ][ MAX_SCRIPT_ZONES ][ 2 ],
	#endif

	// Stores all money given by the server for AntiCheat purposes.
	AC_Money		[ MAX_PLAYERS ];

new
	sWeapons[ ][ e_WEAPONS ] = {
	{ _:MENU_NONE,	"Unarmed", 1, 0 },
	{ _:MENU_NONE, 	"Brass Knuckles", 1, 25 },
	{ _:MENU_NONE,	"Golf Club", 1, 120 },
	{ _:MENU_NONE,	"Night Stick", 1, 80 },
	{ _:MENU_NONE,	"Knife", 1, 100 },
	{ _:MENU_NONE,	"Baseball Bat", 1, 75 },
	{ _:MENU_NONE,	"Shovel", 1, 30 },
	{ _:MENU_NONE,	"Pool Cue", 1, 110 },
	{ _:MENU_NONE,	"Katana", 1, 500 },
	{ _:MENU_NONE,	"Chainsaw", 1, 250 },
	{ _:MENU_NONE,	"Purple Dildo", 1, 50 },
	{ _:MENU_NONE,	"White Dildo", 1, 55 },
	{ _:MENU_NONE,	"White Vibrator", 1, 65 },
	{ _:MENU_NONE,	"Silver Vibrator", 1, 80 },
	{ _:MENU_NONE,	"Flowers", 1, 10 },
	{ _:MENU_NONE,	"Cane", 1, 100 },
	{ _:MENU_NONE,	"Grenade", 5, 300 },
	{ _:MENU_NONE,	"Tear Gas", 5, 200 },
	{ _:MENU_NONE,	"Molotov Cocktail", 5, 200 },
	{ _:MENU_NONE,	"", 0, 0 },
	{ _:MENU_NONE,	"", 0, 0 },
	{ _:MENU_NONE,	"", 0, 0 },
	{ _:MENU_PISTOLS,	"9mm", 30, 200 },
	{ _:MENU_PISTOLS,	"Silenced 9mm", 30, 600 },
	{ _:MENU_PISTOLS,	"Desert Eagle", 15, 1200 },
	{ _:MENU_SHOTGUNS,"Shotgun", 15, 600 },
	{ _:MENU_SHOTGUNS,"Sawnoff Shotgun", 12, 800 },
	{ _:MENU_SHOTGUNS,"Combat Shotgun", 10, 1000 },
	{ _:MENU_MICRO_SMGS,"Micro Uzi", 60, 500 },
	{ _:MENU_SMG,		"SMG", 90, 2000 },
	{ _:MENU_ASSAULT,	"AK47", 120, 3500 },
	{ _:MENU_ASSAULT,	"M4", 150, 4500 },
	{ _:MENU_MICRO_SMGS,"Tec 9", 60, 300 },
	{ _:MENU_RIFLES,	"Country Rifle", 20, 1000 },
	{ _:MENU_RIFLES,	"Sniper Rifle", 10, 5000 },
	{ _:MENU_NONE,	"Rocket Launcher", 5, 10000 },
	{ _:MENU_NONE,	"HeatSeeking Rocket Launcher", 5, 12000 },
	{ _:MENU_NONE,	"Flamethrower", 80, 6000 },
	{ _:MENU_NONE,	"Minigun", 500, 10000 },
	{ _:MENU_NONE,	"Satchel Charge", 1, 2000 },
	{ _:MENU_NONE,	"Detonator", 1, 100 },
	{ _:MENU_NONE,	"Spraycan", 250, 50 },
	{ _:MENU_NONE,	"Fire Extinguisher", },
	{ _:MENU_NONE,	"Camera", 50, 50 },
	{ _:MENU_NONE,	"Nightvision Goggles", 1, 1200 },
	{ _:MENU_NONE,	"Infrared Vision", 1, 1200 },
	{ _:MENU_NONE,	"Parachute", 1, 150 }
},

sWeapon[ 43 ];

new
	moneyPickups	[ MAX_PLAYERS ][ 7 ],
	#if RANDOM_PICKUPS == true
	randPickups		[ MAX_RANDOM_PICKUPS ],
	#endif

	#if VERSION_LITE == false
	Text:TEXT_NoZoneOwner		=	INVALID_TEXT_DRAW,
	Text:TEXT_WarProvokedAttack	=	INVALID_TEXT_DRAW,
	Text:TEXT_WarProvokedDefense=	INVALID_TEXT_DRAW,
	Text:TEXT_TurfLost			=	INVALID_TEXT_DRAW,
	Text:TEXT_TurfIsYours		=	INVALID_TEXT_DRAW,
	Text:TEXT_TurfDefended		=	INVALID_TEXT_DRAW,
	#endif
	
	Text:TEXT_SpawnScreenInfo   =   INVALID_TEXT_DRAW,
	Text:TEXT_Day               =   INVALID_TEXT_DRAW,
	
	sRhino,
	sRhinoOwner					= INVALID_PLAYER_ID,
	sHighBountyPlayer           = INVALID_PLAYER_ID,
	sHour						=	22,
	sMinute 					=	45,
	sDay						=	5,
	sWeather[ 3 ][ 2 ],
	sDays[ 7 ][ ]				=	{
										"Sunday",
										"Monday",
										"Tuesday",
										"Wednesday",
										"Thursday",
										"Friday",
										"Saturday"
									};

new
	gPropertyData[ ][ e_PROPERTY ] = {
	// { NAME, PRICE, PAYMENT, OWNER, TIME=Seconds, TICKS, PURCHASABLE=0/1 }
	{ "Zip", 15000, 1000 + 500, INVALID_PLAYER_ID, 50, 12, 1 },
	{ "South Strip Club", 25000, 2000 + 500, INVALID_PLAYER_ID, 50, 12, 1 },
	{ "Binco", 15000, 1000 + 500, INVALID_PLAYER_ID, 50, 12, 1 },
	{ "Sex Shop", 25000, 2000 + 500, INVALID_PLAYER_ID, 50, 12, 1 },
	{ "North Strip Club", 35000, 2800 + 500, INVALID_PLAYER_ID, 50, 12, 1 },
	{ "LV Gym", 20000, 1500 + 500, INVALID_PLAYER_ID, 50, 12, 1 },
	{ "Small Casino", 22000, 1700 + 500, INVALID_PLAYER_ID, 50, 12, 1 },
	{ "SubUrban", 30000, 2500 + 500, INVALID_PLAYER_ID, 50, 12, 1 },
	{ "Victim", 25000, 2000 + 500, INVALID_PLAYER_ID, 50, 12, 1 },
	{ "ProLaps", 25000, 2000 + 500, INVALID_PLAYER_ID, 50, 12, 1 },
	{ "Caligulas Casino", 100000, 7000 + 500, INVALID_PLAYER_ID, 50, 12, 1 },
	{ "Four Dragons Casino", 75000, 5000 + 500, INVALID_PLAYER_ID, 50, 12, 1 },
	{ "Tattoo Parlour", 10000, 700 + 500, INVALID_PLAYER_ID, 50, 12, 1 },
	{ "Barber Shop", 30000, 2500 + 500, INVALID_PLAYER_ID, 50, 12, 1 },
	{ "Lil' Probe Inn", 40000, 3000 + 500, INVALID_PLAYER_ID, 50, 12, 1 },
	{ "City Planning Department", 120000, 8500 + 500, INVALID_PLAYER_ID, 50, 12, 1 },
	{ "Shithole Bar", 20000, 1500 + 500, INVALID_PLAYER_ID, 50, 12, 1 },
	{ "Dance Club", 45000, 3800 + 500, INVALID_PLAYER_ID, 50, 12, 1 },
	{ "Burger Shot", 50000, 3500 + 500, INVALID_PLAYER_ID, 50, 12, 1 },
	{ "Cluckin' Bell", 60000, 4000 + 500, INVALID_PLAYER_ID, 50, 12, 1 },
	{ "Pizza Stack", 55000, 3500 + 500, INVALID_PLAYER_ID, 50, 12, 1 },
	{ "Didier Sachs", 75000, 5000 + 500, INVALID_PLAYER_ID, 50, 12, 1 }//,
//	{ "GTA-Host Farm", 500000, 11000 + 500, INVALID_PLAYER_ID, 50, 12, 1 }
};

new
	gCheckpoints[ _:e_CP_ID ][ e_CHECKPOINT ] = {
	// { ALLOW_WEAPONS, INTERIOR_ID, MIN_X, MIN_Y, MIN_Z, MAX_X, MAX_Y, MAX_Z, CP_X, CP_Y, CP_Z, CP_SIZE }
	{ 1, 1, -890.6196,448.4243,1345.0,-712.1725,527.3693,1390.0,-794.9108,491.7425,1376.1953, 2.0 },		// LIBERTY CITY
	{ 0, 6, -38.0534,-59.0,1002.0,-16.6681,-47.8012,1009.0,-23.4579,-54.7157,1003.5469, 2.0 },				// SMALL BANK
	{ 0, 18,-39.1483,-92.0702,1003.0,-13.4451,-73.3923,1007.9487,-27.3428,-89.2989,1003.5469,2.0 },			// LARGE BANK
	{ 0, 1, 284.2428,-41.7024,1000.0,298.5352,-30.2174,1005.5156,292.1051,-32.5395,1001.5156, 2.0 },        // LARGE AMMUNATION
	{ 0, 4, 283.7986,-87.0,1000.0,303.2378,-56.4547,1004.6417,290.9599,-84.0210,1001.5156,2.0 },			// MEDIUM AMMUNATION
	{ 0, 6, 284.5088,-112.3029,1000.0,298.0416,-102.9301,1006.0,292.4005,-107.1378,1001.5156,2.0 },         // SMALL AMMUNATION
	{ 1, 18,144.8088,-96.7315, 1001.0, 178.1746,-69.7921, 1006.5547,161.2896,-80.0951,1001.8047, 2.0 },		// ZIP
	{ 1, 3, 1205.6256,-41.2795, 1000.0, 1216.9816,-23.8491, 1003.8786, 1212.5179,-34.9022,1000.9531, 2.0 },	// SOUTH STRIP CLUB
	{ 1, 15, 200.2388,-110.9672, 1005.0, 214.7584,-96.7784,1009.0625, 207.4720,-97.9535,1005.2578, 2.0 },	// BINCO
	{ 1, 3, -108.4353,-24.9072, 1000.0, -98.8945,-10.3072,1004.7188,-103.4667,-22.4568,1000.7188, 2.0 },    // SEX SHOP
	{ 1, 2, 1200.9628,-18.7042, 1000.0,1222.5258,9.7610,1004.6573,1211.6123,-8.5670,1000.9219, 2.0 },		// NORTH STRIP CLUB
	{ 1, 7, 56.8781,-78.6386,1000.0,776.5205,-57.8387,1005.6035,771.7515,-68.0093,1000.6563, 2.0 },         // LV GYM
	{ 1, 12,1113.2974,-18.6082,1000.0,1143.7325,12.2420,1006.4844,1141.2769,9.3297,1000.6797,2.0 },        	// SMALL CASINO
	{ 1, 1, 196.3030,-50.6369, 1000.0, 211.3108,-32.2858,1008.1484,203.6302,-40.8225,1001.8047,2.0 },       // SUBURBAN
	{ 1, 5, 199.6448,-12.9245, 1001.0,227.8458,-3.3436,1009.2109,208.5376,-10.6026,1001.2109,2.0 },         // VICTIM
	{ 1, 3, 196.8632,-139.5691,1001.0,216.7130,-126.2099,1006.5078,205.1733,-130.5532,1003.5078,2.0 },      // PROLAPS
	{ 1, 1, 2147.1572,1573.1588,970.0,2275.0,1714.0790,1019.4531,2235.7375,1677.2257,1008.3594,2.0 },		// CALIGULAS
	{ 1, 10,1924.0562,967.1267,990.0,2019.0679,1070.0,1003.3851,1993.4432,1008.4990,994.4688,2.0},      	// FOUR DRAGONS
	{ 1, 3, -205.1587,-44.5421,1002.0,-199.8923,-39.5410,1005.4949,-202.2995,-42.9260,1002.2734,2.0 },      // TATTOO
	{ 1, 3, 416.5589,-84.6427, 1001.0,424.0674,-73.9028,1006.5859,418.5699,-80.1835,1001.8047,2.0 },        // BARBER
	{ 1, 18, -229.0687, 1393.8162, 27.0, -212.0, 1411.7920, 32.0, -220.2435,1405.7611,27.7734, 2.0 },       // LIL' PROBE INN
	{ 1, 3, 315.2059, 149.0884,1008.0,390.0,217.5,1029.7865,357.2276,173.5224,1008.3822,2.0 },				// CITY PLANNING DEPARTMENT
	{ 1, 11, 477.7484, -92.6517,998.0,512.1829,-67.6648,1003.0396,499.0260,-74.9592,998.7578, 2.0 },        // SHITHOLE BAR
	{ 1, 17,473.5262,-26.6484, 1000.0,507.0990,-1.2475,1005.7266,501.2493,-12.9501,1000.6797,2.0 },			// DANCE CLUB
	{ 1, 10,361.0072,-77.1740, 1001.0,382.7520,-56.3645,1005.5078,377.1060,-61.7182,1001.5078,2.0 },		// BURGER SHOT
	{ 1, 9, 363.7612,-11.8408,1001.0,381.6252,-5.9235,1005.7109,377.2984,-7.9478,1001.8516,2.0 },			// CLUCKIN' BELL
	{ 1, 5,	367.0583,-133.5558,1001.0,380.4274,-112.5055,1004.5938,376.6779,-125.8378,1001.4995,2.0 },		// PIZZA STACK
	{ 1, 14,197.9253,-168.0076,1000.0,217.2373,-151.0527,1003.6094,199.9319,-158.9013,1000.5234, 2.0 }//,	// DIDIER SACHS
//	{ 1, 0,	-171.6243,-69.4193,2.0,-113.1439,-29.9922,25.0,-147.1172,-52.4347,3.1172, 2.0 }					// GTA-HOST FARM
};

#if VERSION_LITE == false

#define _GZONE  INVALID_TEXT_DRAW, INVALID_GANG_ZONE, 255, COLOR_ZONE_DEFAULT, 0, 0

/*

INVALID_TEXT_DRAW, INVALID_GANG_ZONE, 255, COLOR_ZONE_DEFAULT, 0, 0
new gZones[ MAX_SCRIPT_ZONES ][ E_GANG_ZONES ] = {
	{ INVALID_TEXT_DRAW, INVALID_GANG_ZONE, 255, COLOR_ZONE_DEFAULT, 0, 0, 2481.942, 1620.241, 2645.946, 1819.0909 },
	{ INVALID_TEXT_DRAW, INVALID_GANG_ZONE, 255, COLOR_ZONE_DEFAULT, 0, 0, 2481.942, 1819.0909, 2645.946, 1952.894 },
	{ INVALID_TEXT_DRAW, INVALID_GANG_ZONE, 255, COLOR_ZONE_DEFAULT, 0, 0, 2325.749, 1616.373, 2481.942, 1789.7194 },
	{ INVALID_TEXT_DRAW, INVALID_GANG_ZONE, 255, COLOR_ZONE_DEFAULT, 0, 0, 2325.749, 1789.7194, 2481.942, 1972.235 },
	{ INVALID_TEXT_DRAW, INVALID_GANG_ZONE, 255, COLOR_ZONE_DEFAULT, 0, 0, 2321.844, 1972.235, 2481.942, 2111.485 },
	{ INVALID_TEXT_DRAW, INVALID_GANG_ZONE, 255, COLOR_ZONE_DEFAULT, 0, 0, 2481.942, 1952.894, 2821.664, 2111.485 },
	{ INVALID_TEXT_DRAW, INVALID_GANG_ZONE, 255, COLOR_ZONE_DEFAULT, 0, 0, 2497.562, 2111.485, 2653.756, 2289.416 },
	{ INVALID_TEXT_DRAW, INVALID_GANG_ZONE, 255, COLOR_ZONE_DEFAULT, 0, 0, 2259.366, 2243.1030, 2497.562, 2409.326 },
	{ INVALID_TEXT_DRAW, INVALID_GANG_ZONE, 255, COLOR_ZONE_DEFAULT, 0, 0, 2259.366, 2111.485, 2497.562, 2243.1030 },
	{ INVALID_TEXT_DRAW, INVALID_GANG_ZONE, 255, COLOR_ZONE_DEFAULT, 0, 0, 631.045, 1921.38, 787.2389, 2111.485 },
	{ INVALID_TEXT_DRAW, INVALID_GANG_ZONE, 255, COLOR_ZONE_DEFAULT, 0, 0, 631.045, 1662.789, 787.2389, 1921.95 },
	{ INVALID_TEXT_DRAW, INVALID_GANG_ZONE, 255, COLOR_ZONE_DEFAULT, 0, 0, 787.2389, 1821.38, 986.386, 2192.715 },
	{ INVALID_TEXT_DRAW, INVALID_GANG_ZONE, 255, COLOR_ZONE_DEFAULT, 0, 0, 986.386, 1817.512, 1193.343, 2057.332 },
	{ INVALID_TEXT_DRAW, INVALID_GANG_ZONE, 255, COLOR_ZONE_DEFAULT, 0, 0, 986.386, 2057.332, 1154.294, 2343.569 },
	{ INVALID_TEXT_DRAW, INVALID_GANG_ZONE, 255, COLOR_ZONE_DEFAULT, 0, 0, 1622.876, 1140.6, 1751.736, 1283.719 },
	{ INVALID_TEXT_DRAW, INVALID_GANG_ZONE, 255, COLOR_ZONE_DEFAULT, 0, 0, 1544.779, 896.9124, 1755.641, 1148.337 },
	{ INVALID_TEXT_DRAW, INVALID_GANG_ZONE, 255, COLOR_ZONE_DEFAULT, 0, 0, 1380.776, 931.7249, 1544.779, 1152.205 }
};
*/

new gZones[ MAX_SCRIPT_ZONES ][ e_GANG_ZONES ] = {
	// HELIPAD TERRITORY
//	{ _GZONE, 2013.361, 2347.437, 2169.555, 2440.271 },

	// NORTH TERRITORIES ( WEST TO EAST )
	{ _GZONE, 2267.176, 2235.263, 2403.845, 2409.326 },
	{ _GZONE, 2403.845, 2235.263, 2509.276, 2409.326 },
	{ _GZONE, 2509.276, 2235.263, 2602.993, 2409.326 },

	// THE OLD STRIP TERRITORIES
	{ _GZONE, 2138.316, 2049.596, 2321.844, 2235.263 },
	{ _GZONE, 2321.844, 2146.298, 2509.276, 2235.263 },
	{ _GZONE, 2321.844, 2049.596, 2509.276, 2146.298 },

	// EAST ( COVERS NORTH AMMU )
	{ _GZONE, 2509.276, 2049.596, 2602.993, 2235.263 },

	// SOUTHEST NORTH EAST
	{ _GZONE, 2321.844, 1976.103, 2485.847, 2049.596 },
	{ _GZONE, 2485.847, 1952.894, 2688.899, 2049.596 },
	{ _GZONE, 2321.844, 1778.831, 2485.847, 1976.103 },

	// WEST
	{ _GZONE, 646.6644, 1887.137, 716.9516, 2010.915 },
	{ _GZONE, 716.9516, 1798.172, 814.5728, 2010.915 },
	{ _GZONE, 646.6644, 1755.623, 716.9516, 1887.137 },

	// WEST CENTER (UP TO DOWN)
	{ _GZONE, 982.4812, 2192.715, 1158.199, 2389.986 },
	{ _GZONE, 982.4812, 2053.464, 1158.199, 2192.715 },
	{ _GZONE, 982.4812, 1945.158, 1087.912, 2053.464 },
	{ _GZONE, 1087.912, 1945.158, 1158.199, 2053.464 },
	{ _GZONE, 982.4812, 1817.512, 1158.199, 1945.158 },
	{ _GZONE, 880.9552, 1945.158, 982.4812, 2192.715 },

	// ABOVE CAMELS TOE, LEFT TO RIGHT
//	{ _GZONE, 2224.223, 1380.421, 2403.845, 1539.011 },
//	{ _GZONE, 2403.845, 1380.421, 2595.183, 1616.373 },

	// CAMELS TOE, LEFT TO RIGHT
	{ _GZONE, 2052.409, 1202.49, 2204.698, 1380.421 },
	{ _GZONE, 2204.698, 1202.49, 2403.845, 1380.421 },
	{ _GZONE, 2403.845, 1202.49, 2505.372, 1380.421 },
	{ _GZONE, 2505.372, 1260.51, 2606.897, 1380.421 },

	// COME-A-LOT
	{ _GZONE, 2052.409, 975.0538, 2346.2249, 1202.49 },

	// SOUTH EAST
	{ _GZONE, 2321.844, 1074.6913, 2606.8828, 1202.49 }
};

#undef _GZONE

#endif

new
	pColors[ 200 ] = {
	0x7EBDCBFF, 0x9D11D1FF, 0xF43BAAFF, 0x2CD945FF, 0xFE57A8FF, 0x0C59B3FF,
	0xA03B1AFF, 0xA2356CFF, 0xEAB5B7FF, 0xDCF121FF, 0x2BEEADFF, 0x6B59C8FF,
	0x8AD96CFF, 0x2EA323FF, 0xBB06DDFF, 0x9244CEFF, 0x30460EFF, 0xFBFB6DFF,
	0x3E6B1BFF, 0xAFA1BEFF, 0xC40EBEFF, 0xCC08EBFF, 0xEB21E5FF, 0xB61202FF,
	0x2C7A11FF, 0xA7FBBAFF, 0xB7BAF0FF, 0xCE3ABFFF, 0x5C89B6FF, 0x0264B5FF,
	0xBC589BFF, 0xA6B5BFFF, 0x8EB056FF, 0x39A2AAFF, 0x94BDDCFF, 0x4B7F5DFF,
	0xC6AA1AFF, 0xC3EC80FF, 0x86BDAFFF, 0x4CDF89FF, 0xF3FD4EFF, 0x3C4C2BFF,
	0x7E3844FF, 0x962D1CFF, 0x8CC60CFF, 0xB1DD0CFF, 0xE0BCEBFF, 0x582E08FF,
	0x6DAD3BFF, 0xBACE0CFF, 0x231C4EFF, 0x6EB7E8FF, 0x95D5D6FF, 0xA35E6AFF,
	0xCC8B1DFF, 0x1E5C82FF, 0x4FDDEFFF, 0x36D6C7FF, 0xC42520FF, 0x4DB95BFF,
	0xEBC510FF, 0xCFB798FF, 0x85A161FF, 0xDA3F69FF, 0x31EED2FF, 0xC27BBEFF,
	0x2D9408FF, 0xD894D7FF, 0xF60C52FF, 0xE3C1CCFF, 0x8492EBFF, 0xEBE999FF,
	0xDC495AFF, 0x50D5A9FF, 0x77153FFF, 0xD10A10FF, 0x6E60CAFF, 0xC55E7EFF,
	0x7B89E9FF, 0x4FBFACFF, 0xFF2BDEFF, 0xBA9166FF, 0xA4D1FDFF, 0x4D6E05FF,
	0xC7CCC3FF, 0x7B127EFF, 0x38BBF4FF, 0xEF91C5FF, 0x97B6A8FF, 0xD9D3E9FF,
	0xCD8A5AFF, 0xEAC890FF, 0xED3368FF, 0x1DD2ECFF, 0x31DC7CFF, 0x669902FF,
	0x8F43D7FF, 0xADC992FF, 0xD892E9FF, 0x244B6BFF, 0xAAD92FFF, 0xF8C5EAFF,
	0xAADC36FF, 0xEA23DBFF, 0x918E40FF, 0xB54DAFFF, 0xC4DC96FF, 0xA56B60FF,
	0x2EB92BFF, 0xB8C840FF, 0xF4EEC2FF, 0x4BAF4EFF, 0x04A9FFFF, 0xB97DB8FF,
	0xADC1D2FF, 0xFD7F6BFF, 0xB295EAFF, 0x4E82DCFF, 0xD7F5BDFF, 0x04CA01FF,
	0x74A2DAFF, 0x123DFAFF, 0x42150AFF, 0xBEA37CFF, 0xD68DA6FF, 0xD739E5FF,
	0xED9FD1FF, 0x3E83A8FF, 0xA13FEFFF, 0x1A7711FF, 0x0127FFFF, 0x6C64C7FF,
	0xDC7959FF, 0xA1CDA9FF, 0xBCD79DFF, 0x7B1ECDFF, 0x7C1016FF, 0xCF9642FF,
	0xCAFB40FF, 0xA02E2CFF, 0x724FE3FF, 0xC629B4FF, 0x2AD76DFF, 0x16BAFBFF,
	0xFCDF75FF, 0x53E0C6FF, 0x2BBD8BFF, 0xBAE0AFFF, 0x748C8DFF, 0xB3A176FF,
	0x05CDBCFF, 0x2B1FA8FF, 0x1EBAD2FF, 0xB0AFBEFF, 0x0A1F9FFF, 0xA8A831FF,
	0xC8B8FBFF, 0xAB940BFF, 0xBB33BCFF, 0xC88DC1FF, 0x576AECFF, 0x7BAD9DFF,
	0xD979EAFF, 0x24FCCAFF, 0x18AAA8FF, 0xBA83D2FF, 0x6ED5C0FF, 0xF7BA0BFF,
	0xAB19ADFF, 0x4CFE49FF, 0xFCA7A8FF, 0xEAD6F8FF, 0x893D2FFF, 0x77C33AFF,
	0x20DBDEFF, 0x64DC7CFF, 0xE2E481FF, 0xB0E4B9FF, 0x7CA5D2FF, 0x2AF8D3FF,
	0x71D10AFF, 0xB411B7FF, 0xD4A4F6FF, 0xC1CDE4FF, 0x1B0A2EFF, 0xE347A3FF,
	0x3595ABFF, 0xF66FD7FF, 0x599A5FFF, 0x65E922FF, 0xE6B07AFF, 0xF8BF5BFF,
	0xB87DBEFF, 0xAA4E62FF, 0x11AEF0FF, 0x0E94A9FF, 0x634CA2FF, 0xF44AC3FF,
	0x1AFCA0FF, 0xF12EAEFF
};

#if TEXT_DRAWS_INSTEAD_OF_CLIENT_MESSAGES == true

//LnX's Variable' for funkyness
new lvisiblemessage[MAX_PLAYERS];
//What a player's viewing - MUST STAY UP TO DATE OR MUCH UNHAPPYNESS WILL OCCUR
//0 - Nothing
//1 - allprops
//2 - Gangs
//3 - weapons
//4 - n/a
new Text:lrules;
new Text:lweaps;
new Text:lprops [3];
new Text:lgangs [2];
forward Text:lmakeprops1();
forward Text:lmakeprops2();
forward Text:lmakeprops3();
forward Text:lmakegangs1();
forward Text:lmakegangs2();
forward Text:lshowmessage(playerid, Text:text);

//end thereof

#endif

//==============================================================================
// Forward

forward GetPlayerLevel( playerid );
forward AC_GetPlayerMoney( playerid );
forward AC_GivePlayerMoney( playerid, money );
forward AC_ResetPlayerMoney( playerid );
forward DestroyDeathPickups( playerid );
forward CreateDeathPickups( playerid );
forward SpawnFinish( playerid );
forward	BanSync( );
forward ScriptSync( );
forward WeatherSync( );
forward SaveSync( );
forward PropertySync( );
forward EndGangWar( zoneid );
forward OnPlayerLeaveGangZone( playerid, zoneid );
forward OnPlayerEnterGangZone( playerid, zoneid );
forward Text:CreateTerritoryText( name[ ] );
forward Text:CreateBankText( playerid );
forward Text:CreateGangBankText( gangid );

//******************************************************************************
//	Includes: LVA
//******************************************************************************

#include "lva_inc\lva\gangs.pwn"	// Includes Gang functions and defines.
#include "lva_inc\lva\menu.pwn"		// Includes Menu functions and variables.
#include "lva_inc\lva\vehicles.pwn"	// Includes Vehicle functions, defines and variables.
#include "lva_inc\lva\register.pwn"	// Includes Registration functions, defines and variables.
