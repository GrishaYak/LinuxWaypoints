# ~/.local/share/waypoints/.waypoints.sh
[ -n "$WP_LOADED" ] && return
WP_LOADED=1
WAYPOINTS_FILE="$HOME/.local/share/waypoints/.waypoints"
WP_TEMP="$WAYPOINTS_FILE.tmp"

wp() {
    mkdir -p "$(dirname "$WAYPOINTS_FILE")"
    touch "$WAYPOINTS_FILE"

    case "$1" in
        add)
            [ -z "$2" ] && { echo "Usage: wp add <name>"; return 1; }
            name=$2
            path=$(pwd)

            grep -v "^$name=" "$WAYPOINTS_FILE" > $WP_TEMP
            mv "$WP_TEMP" "$WAYPOINTS_FILE"
            if [ -f "$WP_TEMP" ]; then
                rm "$WP_TEMP"
            fi

            printf '%s=%s\n' "$name" "$path" >> "$WAYPOINTS_FILE"
            printf 'Waypoint \"%s\" added\n' "$name"
            ;;
        rm)
            [ -z "$2" ] && { echo "Usage: wp rm <name>"; return 1; }
            case "$3" in 
                -e) 
                    regex="$(printf '%s' "$2" | sed 's/\*/.*/g; s/?/./g')"
                    grep -v -E "^$regex=" "$WAYPOINTS_FILE" > "$WP_TEMP"
                    ;;
                *) 
                    grep -v "^$2=" "$WAYPOINTS_FILE" > "$WP_TEMP"
            esac    
            echo Following waypoints will be deleted: 
            comm -13 "$WP_TEMP" "$WAYPOINTS_FILE" | cut -d= -f1
            echo Type \"y\" if you are okay with this
            read ok
            if [ "$ok" = "y" ]; then
                mv "$WP_TEMP" "$WAYPOINTS_FILE"
                if [ -f "$WP_TEMP" ]; then
                    rm "$WP_TEMP"
                fi
            fi
            ;;
        ls)
            cut -d= -f1 "$WAYPOINTS_FILE"
            ;;
        *)
            echo "Usage: wp {add|rm|ls}"
            ;;
    esac
}

tp() {
    [ -z "$1" ] && { echo "Usage: tp <name>"; return 1; }

    dest=$(grep "^$1=" "$WAYPOINTS_FILE" | cut -d= -f2-)
    [ -z "$dest" ] && { echo "Directory not found: $dest"; return 1; }
    cd "$dest" || return 1
}
