#!usr/bin/env sh
[ -n "$WP_LOADED" ] && return
WP_LOADED=1
WAYPOINTS_FILE="$HOME/.local/share/waypoints/.waypoints"
WP_TEMP="$WAYPOINTS_FILE.tmp"
USAGE='Usage:'
RM_USAGE='
wp rm <name>                   - remove <name> (understands regular expressions)
wp rm <name> -n|--no-regex     - understand <name> literally'
ADD_USAGE='
wp add <name>                  - add <name> to the waypoint list'
LS_USAGE='
wp ls                          - print all waypoints'
WP_USAGE="
$ADD_USAGE$LS_USAGE$RM_USAGE
Use \"tp\" to teleport to waypoints"
TP_USAGE="
tp <name>                      - teleport to waypoint named <name>"


wp() {
    touch "$WAYPOINTS_FILE"

    case "$1" in
        add)
            [ -z "$2" ] && { echo "$USAGE$ADD_USAGE"; return 1; }
            name=$2

            grep -v "^$name=" "$WAYPOINTS_FILE" > $WP_TEMP
            mv "$WP_TEMP" "$WAYPOINTS_FILE"

            printf '%s=%s\n' "$name" "$PWD" >> "$WAYPOINTS_FILE"
            ;;
        rm)
            [ -z "$2" ] && { echo "$USAGE$RM_USAGE"; return 1; } 
            
            case "$3" in 
                -n|--no-regex) 
                    grep -v "^$2=" "$WAYPOINTS_FILE" > "$WP_TEMP"
                    ok=Y
                    ;;
                *) 
                    regex="$(printf '%s' "$2" | sed 's/\*/.*/g; s/?/./g')"
                    grep -v -E "^$regex=" "$WAYPOINTS_FILE" > "$WP_TEMP"

                    comm -13 "$WP_TEMP" "$WAYPOINTS_FILE" | cut -d= -f1 | sed 's/^/rm /g'
                    
                    ok=Y
                    ;;
            esac    
            if [ "$ok" = "Y" ]; then
                mv "$WP_TEMP" "$WAYPOINTS_FILE"
            else
                rm "$WP_TEMP"
            fi
            ;;
        ls)
            cut -d= -f1 "$WAYPOINTS_FILE"
            ;;
        *)
            echo "$USAGE$WP_USAGE"
            ;;
    esac
}

tp() {
    [ -z "$1" ] && { echo "$USAGE$TP_USAGE"; return 1; }

    DEST=$(grep "^$1=" "$WAYPOINTS_FILE" | cut -d= -f2-)
    [ -z "$DEST" ] && { echo "Directory not found: $DEST"; return 1; }
    cd "$DEST" || return 1
}
