**Example Build and Run**
```
cd tekkit
sudo docker build -t 'tekkit' .
cd ../hexxit
sudo docker build -t 'hexxit' .
cd ../mapserver/
sudo docker build -t 'mapserver' .
cd ../overviewer/
sudo docker build -t 'overviewer' .

# Tekkit on primary ports
TEKKIT=$(sudo docker run -p 25565:25565 -d -name='tekkit_v1' tekkit)
MAPSERVER=$(sudo docker run -p 8000:8000 -d -name='tekkit_v1_map' mapserver)
sudo docker run -volumes-from $TEKKIT -volumes-from $MAPSERVER -name='tekkit_mapgen' overviewer;

# Hexxit on alternative ports
HEXXIT=$(sudo docker run -p 25566:25565 -d -name='hexxit_v1' hexxit)
MAPSERVER=$(sudo docker run -p 8001:8000 -d -name='hexxit_v1_map' mapserver)
sudo docker run -volumes-from $HEXXIT -volumes-from $MAPSERVER -name='hexxit_mapgen' overviewer;
```

** Usage / Maintenance Tips **
- the overviewer should be ran through a scheudled crontab however often you want to update the map, if you have performance issues look into -c to limit CPU usage
- If you want to dockerize your old map simply use the Dockerfile 'ADD' command to drop map files into /minecraft/world after the existing dockerfile actions, then r
e-build the docker image.


*** Auto commiting/saving updated world data into docker images ***
```
# Add to crontab on your save schedule
TAG=hexxit 
*/5 * * * * sudo docker commit -m "$(date +%F_%Hh%Mm%Ss) autosave" $(sudo docker ps | grep $TAG | cut -c-12) $TAG:autosave
TAG=tekkit
*/5 * * * * sudo docker commit -m "$(date +%F_%Hh%Mm%Ss) autosave" $(sudo docker ps | grep $TAG | cut -c-12) $TAG:autosave
```
