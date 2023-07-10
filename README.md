# Keyp Mod for Minetest

This is a mod for Minetest that adds Keyp login functionality. It requires a front-end and auth server api.

## Installation

1. Navigate to the Minetest mods directory (usually `~/.minetest/mods`).
2. Clone this repository: `git clone https://github.com/username/keyp.git`.
3. Rename the resulting folder to `keyp` if it is not already named that.
4. Start Minetest and enable the mod from the 'Configure' menu.

## Deployment

1. Create a docker vm (easy via digitial ocean)

2. ssh into the vm

3. `docker pull registry.gitlab.com/minetest/minetest/server:latest`

4. grab the mod repo: `git clone docker pull registry.gitlab.com/minetest/minetest/server:latest`
