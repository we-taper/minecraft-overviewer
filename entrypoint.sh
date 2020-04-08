#!/bin/bash
set -o errexit

# Require MINECRAFT_VERSION environment variable to be set (no default assumed)
if [ -z "$MINECRAFT_VERSION" ]; then
  echo "Expecting environment variable MINECRAFT_VERSION to be set to non-empty string. Exiting."
  exit 1
fi

# Download Minecraft client .jar (Contains textures used by Minecraft Overviewer)
CLIENT_URL=$(python3 /home/minecraft/download_url.py "$MINECRAFT_VERSION")
echo "Using Client URL $CLIENT_URL."
wget -N "${CLIENT_URL}" -O "${MINECRAFT_VERSION}.jar" -P "/home/minecraft/.minecraft/versions/${MINECRAFT_VERSION}/"

if [ -n "$RCON_ARGS_PRE" ]; then
  rcon-cli $RCON_ARGS_PRE
fi

# Render the Map
if [ "$RENDER_MAP" == "true" ]; then
  overviewer.py --config "$CONFIG_LOCATION" $ADDITIONAL_ARGS
fi

# Render the POI
if [ "$RENDER_POI" == "true" ]; then
  overviewer.py --config "$CONFIG_LOCATION" --genpoi $ADDITIONAL_ARGS_POI
fi

if [ -n "$RCON_ARGS_POST" ]; then
  rcon-cli $RCON_ARGS_POST
fi
