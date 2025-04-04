export PATH="$HOME/.local/bin:$PATH"
hex_to_rgb() {
    echo ""
    for hex in "$@"; do
	hex_dig="${hex#"#"}"  # Strip leading #
	r=$((16#${hex_dig:0:2}))
	g=$((16#${hex_dig:2:2}))
	b=$((16#${hex_dig:4:2}))
	echo -e "\t\033[48;2;${r};${g};${b}m   \033[0m	#$hex\n"
    done
}

alias mkhex='hex_to_rgb "$@"'

