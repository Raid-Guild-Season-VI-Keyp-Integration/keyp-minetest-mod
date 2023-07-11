#!/bin/bash

# Define the directory
DIR="/root/minetest-data"

# Check if the directory exists
if [ -d "$DIR" ]
then
    echo "$DIR exists."
else
    echo "$DIR does not exist. Creating now..."
    mkdir -p $DIR/mods/keyp $DIR/main-config
    echo "$DIR has been created."
fi

# Copy files from the repo into the minetest-data directory
cp -R /root/keyp-minetest-mod/* $DIR/mods/keyp/
cp /root/keyp-minetest-mod/minetest.conf.keyp $DIR/main-config/minetest.conf

# Run docker compose to setup world and other files
docker compose -f /root/keyp-minetest-mod/minetest-keyp.yml up -d

# shut down to edit
docker compose -f /root/keyp-minetest-mod/minetest-keyp.yml down

# Add necessary line to world.mt file
echo "load_mod_kep = true" >> $DIR/worlds/world/world.mt

# Restart
docker compose -f /root/keyp-minetest-mod/minetest-keyp.yml up -d