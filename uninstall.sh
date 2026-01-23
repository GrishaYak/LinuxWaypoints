#!/bin/sh
# Installer for Waypoints

WAYPOINTS_FILE="$PWD/.waypoints"
SCRIPT_FILE="$PWD/waypoints.sh"
OLD_DIR="$HOME/.local/share/waypoints"
OLD="$OLD_DIR/waypoints.sh"
UNINS_FILE="$PWD/uninstall.sh"
INS_FILE="$PWD/install.sh"
README_MD="$PWD/README.md"

# Detect shell startup file
case "$SHELL" in
    */zsh)
        SHELL_RC="$HOME/.zshrc"
        ;;
    */bash)
        SHELL_RC="$HOME/.bashrc"
        ;;
    *)
        SHELL_RC="$HOME/.profile"
        ;;
esac

grep -vxF ". $SCRIPT_FILE" "$SHELL_RC" > .tmp
case "$1" in
    --old)
        grep -vxF ". $OLD" .tmp > "$SHELL_RC"
        rm -rf "$OLD_DIR"
        ;;
    *)
        cat .tmp > "$SHELL_RC"
        ;;
esac
rm .tmp
rm -f "$WAYPOINTS_FILE" "$INS_FILE" "$SCRIPT_FILE" "$README_MD"

echo "waypoints have been uninstalled"

rm "$UNINS_FILE"
