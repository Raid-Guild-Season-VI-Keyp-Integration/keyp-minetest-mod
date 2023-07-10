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

3. `docker pull registry.gitlab.com/minetest/minetest/server:latest`

4. grab the mod repo (this repo): `git clone https://github.com/Raid-Guild-Season-VI-Keyp-Integration/keyp-minetest-mod.git`

5. cd into the repo folder `cd keyp-minetest-mod`

6. create the minetest-data folder (add more detail)

7. build the docker file `docker compose -f .yml up`

8. killl it `docker compose -f .yml down`

9. add keyp to the world file world.my `load_mod_keyp = true`

10. restart with compose
