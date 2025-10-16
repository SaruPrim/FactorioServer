#!/bin/bash
set -e

# Download server
DOWNLOAD="/download.sh"
if [ -n "$VERSION" ]; then
        > "$DOWNLOAD"
        echo "wget --no-verbose https://factorio.com/get-download/${VERSION}/headless/linux64" >> "$DOWNLOAD"
	chmod +x "$DOWNLOAD"
fi
if [ -f "$DOWNLOAD" ]; then
	echo "Downloading server ${VERSION}..."
	bash "$DOWNLOAD"
else
	echo "Downloading server stable version..."
	wget --no-verbose https://factorio.com/get-download/stable/headless/linux64
fi

echo "Installing server..."
tar -xf /linux64

ENV_FILE="/env_set"
MOD_LIST="/factorio/mods/mod-list.json"

# Setting mod file
if [ -n "$SPACE_AGE" ] || [ -n "$QUALITY" ] || [ -n "$ELEVATED_RAILS" ]; then
  > "$ENV_FILE" 
  echo "SPACE_AGE=${SPACE_AGE:-false}" >> "$ENV_FILE"
  echo "QUALITY=${QUALITY:-false}" >> "$ENV_FILE"
  echo "ELEVATED_RAILS=${ELEVATED_RAILS:-false}" >> "$ENV_FILE"
fi

# Update setting mod
update_mod_from_env_file() {
  if [ ! -f "$ENV_FILE" ]; then
    echo "Error: Missing file $ENV_FILE — skipping mod settings update"
    return
  fi

  while IFS='=' read -r key value; do
    case "$key" in
      SPACE_AGE) mod_name="space-age" ;;
      QUALITY) mod_name="quality" ;;
      ELEVATED_RAILS) mod_name="elevated-rails" ;;
      *) continue ;;
    esac

    jq --arg name "$mod_name" --argjson enabled "$value" \
      '(.mods[] | select(.name == $name) | .enabled) = $enabled' \
      "$MOD_LIST" > "$MOD_LIST.tmp" && mv "$MOD_LIST.tmp" "$MOD_LIST"
  done < "$ENV_FILE"
  
  echo "Mod settings updated"
  return
}

# Creating maps and a save
SAVE="save.zip"
if [ ! -f "/factorio/saves/$SAVE" ]; then
	echo "Save $SAVE not found, creating new save..."
	/factorio/bin/x64/factorio --create "/factorio/saves/$SAVE"
fi

# Start mod update and server
update_mod_from_env_file
echo "Starting server with save $SAVE..."
exec /factorio/bin/x64/factorio --start-server "/factorio/saves/$SAVE"


# SaruPrim :)
