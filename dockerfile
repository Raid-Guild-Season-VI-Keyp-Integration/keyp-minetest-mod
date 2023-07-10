FROM registry.gitlab.com/minetest/minetest/server:latest

# Copy the mods from your local mods directory to the mods directory in the container
COPY . /var/lib/minetest/.minetest/mods

# Copy custom minetest.conf file to the correct location
COPY minetest.conf.keyp /var/lib/minetest/.minetest/minetest.conf

# Change ownership of the copied directories to minetest user
RUN chown -R minetest:minetest /var/lib/minetest/.minetest/mods
RUN chown minetest:minetest /var/lib/minetest/.minetest/minetest.conf
