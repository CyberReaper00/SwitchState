{ pkgs }:

/*  
	Instructions:

	truetype	--> ttf
	opentype	--> otf
	type1		--> pfb
*/

rec {
	monkey = pkgs.stdenv.mkDerivation {
		pname	= "monkey";
		version = "1";
		src		= ../fonts/monkey;
		installPhase = ''
			mkdir -p $out/share/fonts/opentype
			cp -r $src/* $out/share/fonts/opentype/
		'';
	};

	vandria = pkgs.stdenv.mkDerivation {
		pname	= "vandria";
		version = "1";
		src		= ../fonts/vandria;
		installPhase = ''
			mkdir -p $out/share/fonts/opentype
			cp -r $src/* $out/share/fonts/opentype/
		'';
	};

	winking = pkgs.stdenv.mkDerivation {
		pname	= "winking";
		version = "1";
		src		= ../fonts/winking;
		installPhase = ''
			mkdir -p $out/share/fonts/opentype
			cp -r $src/* $out/share/fonts/opentype/
		'';
	};

	dm_serif = pkgs.stdenv.mkDerivation {
		pname	= "dm_serif";
		version = "1";
		src		= ../fonts/dm_serif;
		installPhase = ''
			mkdir -p $out/share/fonts/truetype
			cp -r $src/* $out/share/fonts/truetype/
		'';
	};

}
