#!/bin/bash

for font in \
    "DejaVu Sans" "DejaVu Sans,DejaVu Sans Condensed" "DejaVu Sans Mono" "DejaVu Serif" \
    "DejaVu Serif,DejaVu Serif Condensed" "Fixed" "FreeMono" "FreeSans" "FreeSerif" \
    "Liberation Mono" "Liberation Sans" "Liberation Serif" "TeX Gyre Adventor" \
    "TeX Gyre Bonum" "TeX Gyre Cursor" "TeX Gyre Heros" "TeX Gyre Heros Cn" \
    "TeX Gyre Pagella" "TeX Gyre Schola" "TeX Gyre Termes"; do
    echo -e "\e[0mThis is \e[1m$font\e[0m" | PANGOCAIRO_BACKEND=fc pango-view --font="$font" --dpi=96 --text="This is $font"
done

