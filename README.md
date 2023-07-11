# Keyp Mod for Minetest

This is a mod for Minetest that adds Keyp login functionality. It requires a front-end and auth server api.

## Installation for local testing

1. Navigate to the Minetest mods directory (usually `~/.minetest/mods`).
2. Clone this repository: `git clone https://github.com/Raid-Guild-Season-VI-Keyp-Integration/keyp-minetest-mod.git`.
3. Rename the resulting folder to `keyp` if it is not already named that.
4. Start Minetest and enable the mod from the 'Configure' menu.

## Deployment

1. Create a docker vm (easy via digitial ocean)

2. ssh into the vm

3. grab the mod repo (this repo): `git clone https://github.com/Raid-Guild-Season-VI-Keyp-Integration/keyp-minetest-mod.git`

4. cd into the repo folder `cd keyp-minetest-mod`

5. create the minetest-data folder (add more detail)

6. build the docker file `docker compose -f minetest-keyp.yml up`

7. kill it `docker compose -f load_mod_keyp.yml down`

8. add the .env file at /root/.env which includes the auth server key

9. add keyp to the world file world.mt `load_mod_keyp = true`

10. restart with `docker compose -f minetest-keyp.yml up`
