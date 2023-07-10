FROM registry.gitlab.com/minetest/minetest/server:latest

# Change to root user for copying files
USER root

# Copy the mods from your local mods directory to the mods directory in the container
COPY . /var/lib/minetest/.minetest/mods

# Copy custom minetest.conf file to the correct location
COPY minetest.conf.keyp /var/lib/minetest/.minetest/minetest.conf

# Switch back to the non-root user
USER minetest
