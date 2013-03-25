/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Include:

	6:56 p.m, 24/09/2007
	color.inc, Simon Campbell
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/

/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Global
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/

#if defined __color__included
	#endinput
#endif

#define __color__included

/* -- Colours
*/

#if !defined COLOR_BLACK
	#define COLOR_BLACK	0x000000FF
#endif

#if !defined COLOR_NAVY
	#define COLOR_NAVY		0x000080FF
#endif

#if !defined COLOR_BLUE
	#define COLOR_BLUE		0x0000FFFF
#endif

#if !defined COLOR_GREEN
	#define COLOR_GREEN		0x008000FF
#endif

#if !defined COLOR_TEAL
	#define COLOR_TEAL		0x008080FF
#endif

#if !defined COLOR_LIME
	#define COLOR_LIME		0x00FF00FF
#endif

#if !defined COLOR_AQUA
	#define COLOR_AQUA		0x00FFFFFF
#endif

#if !defined COLOR_CYAN
	#define COLOR_CYAN		0x00FFFFFF
#endif

#if !defined COLOR_MAROON
	#define COLOR_MAROON	0x800000FF
#endif

#if !defined COLOR_PURPLE
	#define COLOR_PURPLE   0x800080FF
#endif

#if !defined COLOR_OLIVE
	#define COLOR_OLIVE    0x808000FF
#endif

#if !defined COLOR_GRAY
	#define COLOR_GRAY     0x808080FF
#endif

#if !defined COLOR_GREY
	#define COLOR_GREY     0x808080FF
#endif

#if !defined COLOR_SILVER
	#define COLOR_SILVER   0xC0C0C0FF
#endif

#if !defined COLOR_RED
	#define COLOR_RED      0xFF0000FF
#endif

#if !defined COLOR_FUCHSIA
	#define COLOR_FUCHSIA  0xFF00FFFF
#endif

#if !defined COLOR_PINK
	#define COLOR_PINK		0xFF00FFFF
#endif

#if !defined COLOR_YELLOW
	#define COLOR_YELLOW   0xFFFF00FF
#endif

#if !defined COLOR_WHITE
	#define COLOR_WHITE    0xFFFFFFFF
#endif

#if !defined COLOR_ORANGE
	#define COLOR_ORANGE   0xEE9911FF
#endif

/* -- Other
*/

#define NO_SET			-1

/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Functions
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/

stock setRed( color, red ) // Set the red intensity on a colour.
{
	if ( red > 0xFF )
	    red	= 0xFF;
	else if ( red < 0x00 )
	    red	= 0x00;

	return ( color & 0x00FFFFFF ) | ( red << 24 );
}

stock setGreen( color, green ) // Set the green intensity on a colour.
{
	if ( green > 0xFF )
	    green	= 0xFF;
	else if ( green < 0x00 )
	    green	= 0x00;

	return ( color & 0xFF00FFFF ) | ( green << 16 );
}

stock setBlue( color, blue ) // Set the blue intensity on a colour.
{
	if ( blue > 0xFF )
	    blue	= 0xFF;
	else if ( blue < 0x00 )
	    blue	= 0x00;

	return ( color & 0xFFFF00FF ) | ( blue << 8 );
}

stock setAlpha( color, alpha ) // Set the alpha intensity on a colour.
{
	if ( alpha > 0xFF )
	    alpha	= 0xFF;
	else if ( alpha < 0x00 )
	    alpha	= 0x00;

	return ( color & 0xFFFFFF00 ) | alpha;
}

stock stripRed( color ) // Remove all red from a colour.
	return ( color ) & 0x00FFFFFF;

stock stripGreen( color ) // Remove all green from a colour.
	return ( color ) & 0xFF00FFFF;

stock stripBlue( color ) // Remove all blue from a colour.
	return ( color ) & 0xFFFF00FF;

stock stripAlpha( color ) // Remove all alpha from a colour.
	return ( color ) & 0xFFFFFF00;

stock fillRed( color ) // Fill all red in a colour.
	return ( color ) | 0xFF000000;

stock fillGreen( color ) // Fill all green in a colour.
	return ( color ) | 0x00FF0000;

stock fillBlue( color ) // Fill all blue in a colour.
	return ( color ) | 0x0000FF00;

stock fillAlpha( color ) // Fill all alpha in a colour.
	return ( color ) | 0x000000FF;

stock getRed( color ) // Get the intensity of red in a colour.
	return ( color >> 24 ) & 0x000000FF;

stock getGreen( color ) // Get the intensity of green in a colour.
	return ( color >> 16 ) & 0x000000FF;

stock getBlue( color ) // Get the intensity of blue in a colour.
	return ( color >> 8 ) & 0x000000FF;

stock getAlpha( color ) // Get the intensity of alpha in a colour.
	return ( color ) & 0x000000FF;

stock makeColor( red=0, green=0, blue=0, alpha=0 ) // Make a colour with the specified intensities.
	return ( setAlpha( setBlue( setGreen( setRed( 0x00000000, red ), green ), blue ), alpha ) );

stock setColor( color, red = NO_SET, green = NO_SET, blue = NO_SET, alpha = NO_SET ) // Set the properties of a colour.
{
	if ( red != NO_SET )
	    color = setRed    ( color, red );
	if ( green != NO_SET )
	    color = setGreen  ( color, green );
	if ( blue != NO_SET )
	    color = setBlue   ( color, blue );
	if ( alpha != NO_SET )
	    color = setAlpha  ( color, alpha );

	return color;
}
