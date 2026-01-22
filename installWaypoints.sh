#!/bin/sh
# Installer for Waypoints

WAYPOINTS_FOLDER="$HOME/.local/share/waypoints"

SCRIPT_FILE="$WAYPOINTS_FOLDER/waypoints.sh"

WAYPOINTS_FILE="$WAYPOINTS_FOLDER/.waypoints"

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

mkdir -p "$WAYPOINTS_FOLDER"
cp waypoints.sh "$SCRIPT_FILE"
chmod +x "$SCRIPT_FILE"

touch "$WAYPOINTS_FILE"

grep -qxF ". $SCRIPT_FILE" "$SHELL_RC" || printf "\n. $SCRIPT_FILE\n" >> "$SHELL_RC"

echo "Installation complete!"
echo "Restart your terminal to start using wp and tp."

case $1 in
    "--clear")
            rm waypoints.sh
            rm -- "$0"
        ;;
    "*")
        ;;
esac


