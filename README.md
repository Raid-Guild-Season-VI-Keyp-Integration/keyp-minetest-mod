# Keyp Mod for Minetest

This is a mod for Minetest that adds Keyp login functionality. It requires a front-end and auth server api.

## Installation for local testing

1. Navigate to the Minetest mods directory (usually `~/.minetest/mods`).
2. Clone this repository: `git clone https://github.com/Raid-Guild-Season-VI-Keyp-Integration/keyp-minetest-mod.git`.
3. Rename the resulting folder to `keyp` if it is not already named that.
4. Start Minetest and enable the mod from the 'Configure' menu.
5. Add the lines in `minetest.conf.keyp` to your installations `minetest.conf` (usually `~/.minetest/minetest.conf`) or run with the config option `minetest --config /path/to/minetest.conf.keyp`

## Deployment for server

1. Create a docker vm

2. ssh into the vm

3. grab the mod repo (this repo): `git clone https://github.com/Raid-Guild-Season-VI-Keyp-Integration/keyp-minetest-mod.git`

4. add the .env file at /root/.env which includes the auth server key. It just needs this line: `AUTH_KEY=auth-server-api-key-tbd`

5. give permissions to bash script `chmod +x keyp-minetest-mod/run-server.sh`

6. run bash script which will set up folders and run it the server in the background `./keyp-minetest-mod/run-server.sh` (ONLY RUN ONCE, do manual updates to the mod with a cp, see update section. )

7. People can then join the server based on the vm IP at port 30000

### make updates

1. pull the latest version of this repo
2. from the root directory `cp -r keyp-minetest-mod/* minetest-data/mods/keyp/`
3. kill the server: `docker compose -f keyp-minetest-mod/minetest-keyp.yml down`
4. start the server `docker compose -f keyp-minetest-mod/minetest-keyp.yml up -d`
