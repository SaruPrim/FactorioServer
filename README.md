# Factorio Server (Docker)

<pre>
docker run -d --name factorio \
  -p 34197:34197/udp \
  -v factorio:/factorio \
  --restart=unless-stopped \
  saruprim/factorio
</pre>
The latest stable version of the Factorio server is installed automatically when the container starts. If you need to update the server, simply stop and restart the container:
<pre>docker stop factorio && docker start factorio</pre>
Game saves are stored in a volume, so they will not be deleted.

The container starts up briefly, and you can monitor its progress with:
<pre>docker logs factorio -f</pre>

Default modifications are disabled, but you can enable them using environment variables:
<pre>
docker run -d --name factorio \
  -p 34197:34197/udp \
  -v factorio:/factorio \
  -e ELEVATED_RAILS=true \
  -e QUALITY=true \
  -e SPACE_AGE=true \
  --restart=unless-stopped \
  saruprim/factorio
</pre>

If you need an older server version, use:
<pre>
-e VERSION=2.0.47
</pre>


Compose:
<pre>
services:
  factorio:
    image: saruprim/factorio
    container_name: factorio
    ports:
      - 34197:34197/udp
    volumes:
      - factorio:/factorio
    # environment:
      # ELEVATED_RAILS: "true"
      # QUALITY: "true"
      # SPACE_AGE: "true"
      # VERSION: "2.0.47"
    network_mode: bridge
    restart: unless-stopped
volumes:
  factorio:
    name: factorio
</pre>
