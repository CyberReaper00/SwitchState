{ pkgs }:

/*  
	Instructions:

	truetype --> ttf
	opentype --> otf
	type1	 --> pfb
*/
let
	new_font = font_name: font_type:
		pkgs.stdenv.mkDerivation {
			pname	= font_name;
			version = "1";
			src		= ../fonts/${font_name};
			installPhase = ''
				mkdir -p $out/share/fonts/${font_type}
				cp -r $src/* $out/share/fonts/${font_type}/
			'';
		};
in
{
	monkey		= new_font "monkey"		"opentype";
	vandria		= new_font "vandria"	"opentype";
	winking		= new_font "winking"	"opentype";
	dm_serif	= new_font "dm_serif"	"truetype";
	quicksand	= new_font "quicksand"	"truetype";
}
