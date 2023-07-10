FROM registry.gitlab.com/minetest/minetest/server:latest
COPY . /root/.minetest/mods/keyp/
COPY minetest.conf.keyp /var/lib/minetest/.minetest/minetest.conf