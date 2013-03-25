#if defined __debugger__included
	#endinput
#endif

#define __debugger__included

#define	DEBUG_COLOR			0x44DD44FF		// Colour of the DEBUG message.
#define DEBUG_PREFIX		"[DEBUG]"		// Constant string prefix, which helps differentiate DEBUG text from normal text.

#if !defined C_DEBUG
	#define C_DEBUG			false		// True / False (ON/OFF), SAA's CONSOLE debugger.
#endif
#if !defined G_DEBUG
	#define G_DEBUG			false		// True / False (ON/OFF), SAA's IN-GAME debugger.
#endif

#if C_DEBUG == true || G_DEBUG == true

	new DEBUG_STR	[ 256 ];			// Global string for formatting debug strings.
	new DEBUGGER	[ MAX_PLAYERS ];    // Variable declaring whether a player is a debugger or not.
	
	#define fSendDebugMessage(%1,%2,%3)		format(%1, sizeof(%1), %2, %3);	SendDebugMessage(%1)

#if C_DEBUG == true && G_DEBUG == true
	#define DEBUGF(%1,%2)					fSendDebugMessage(DEBUG_STR, DEBUG_PREFIX " " #%1, %2); printf(DEBUG_PREFIX " " #%1, %2)
	#define DEBUG(%1)						SendDebugMessage(DEBUG_PREFIX " " #%1);	print(DEBUG_PREFIX " " #%1)

#elseif C_DEBUG == true && G_DEBUG == false
	#define DEBUGF(%1,%2)					printf(DEBUG_PREFIX " " #%1, %2)
	#define DEBUG(%1)						print(DEBUG_PREFIX " " #%1)

#elseif C_DEBUG == false && G_DEBUG == true
	#define DEBUGF(%1,%2)					fSendDebugMessage(DEBUG_STR, DEBUG_PREFIX " " #%1, %2)
	#define DEBUG(%1)						SendDebugMessage(DEBUG_PREFIX " " #%1);

#elseif C_DEBUG == false && G_DEBUG == false
	#define DEBUGF(%1,%2)					NOTHING()
	#define DEBUG(%1)						NOTHING()

#endif

/*

native DEBUGF(str[], {Float,_}:...);
native DEBUG(str[]);
native SendDebugMessage(msg[]);
native fSendDebugMessage(output[], sizeof(output), {Float,_}:...);
native NOTHING();

*/

stock SendDebugMessage( msg[ ] )
{
	for ( new i = 0, j = GetMaxPlayers( ); i < j; i++ )
	{
		if ( DEBUGGER[ i ] || IsPlayerAdmin( i ) )
			SendClientMessage( i, DEBUG_COLOR, msg );
	}
}

stock NOTHING( )
{
	// The nothing function... that does nothing at all.
}
