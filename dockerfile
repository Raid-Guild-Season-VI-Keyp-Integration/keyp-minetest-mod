FROM registry.gitlab.com/minetest/minetest/server:latest
# COPY . /root/.minetest/mods/keyp/
# COPY minetest.conf.keyp /var/lib/minetest/.minetest/minetest.conf


# Copy the mods from your local mods directory to the mods directory in the container
COPY . /var/lib/minetest/.minetest/mods

# Copy custom minetest.conf file to the correct location
COPY minetest.conf.keyp /var/lib/minetest/.minetest/minetest.conf

# Expose the Minetest server port
EXPOSE 30000/udp

# Set the default command to run the Minetest server
CMD ["/usr/local/bin/minetest", "--server"]
