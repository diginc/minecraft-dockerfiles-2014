# About Minecraft Dockerfiles
A finished docker product to run Minecraft, Tekkit, Hexxit, and Overviewer (online map).  Dockerfiles based off of Michael Crosby's
* Advanced Docker Volume tutorial: http://crosbymichael.com/advanced-docker-volumes.html
* Dockerfiles: https://github.com/crosbymichael/Dockerfiles

## Requirements
1. Docker
2. Some basic docker and linux knowledge

This isn't meant to teach docker's terminology or commands; You may be able to lean some docker through using this project, but there are plenty of dedicated tutorials out there for that.  This project is just to help our minecraft server admin out and show him the basics of working with docker containers.

## Instructions
Instructions below are for tekkit + hexxit simulatenously since that's my use case.  I threw in a stock minecraft Dockerfile because it was what the original advanced docker volume tutorial used...but I'm not using; if you are, you're on your own kid.
  
### Build Images
```
cd tekkit
sudo docker build -t 'tekkit' .
cd ../hexxit
sudo docker build -t 'hexxit' .
cd ../mapserver/
sudo docker build -t 'mapserver' .
cd ../overviewer/
sudo docker build -t 'overviewer' .
```

### Basic Container Run
The 3rd command for overviewer is optional here and may not run if your minecraft server hasn't gotten to the spawn generation step yet, it'll be added to crontab later but the initial run takes a while so you may wish to manually run it.
```
# Tekkit on primary ports + initial map gen
TEKKIT=$(sudo docker run -p 25565:25565 -d -name='tekkit_v1' tekkit)
MAPSERVER=$(sudo docker run -p 8000:8000 -d -name='tekkit_v1_map' mapserver)
sudo docker run -volumes-from tekkit_v1 -volumes-from tekkit_v1_map -name='tekkit_mapgen' overviewer;

# Hexxit on alternative ports + initial map gen
HEXXIT=$(sudo docker run -p 25566:25565 -d -name='hexxit_v1' hexxit)
MAPSERVER=$(sudo docker run -p 8001:8000 -d -name='hexxit_v1_map' mapserver)
sudo docker run -volumes-from hexxit_v1 -volumes-from hexxit_v1_map -name='hexxit_mapgen' overviewer;
```

### Overviewer Updating
Overviewer should be ran through a scheduled crontab so the mapserver's (webserver container) served files get updated continually
```
crontab -e
# Add:
*/10 * * * * sudo docker run -volumes-from tekkit_v1 -volumes-from tekkit_v1_map -name='tekkit_mapgen' overviewer;
*/10 * * * * sudo docker run -volumes-from hexxit_v1 -volumes-from hexxit_v1_map -name='hexxit_mapgen' overviewer;
```

### Map Autosave
Auto commiting/saving updated containers is very quick, low impact, and convenient should a crash happen.  If the tag (`-t=`) was cutomized when images were build, DOCKER_TAG should match.  If the -name was matched during the run step, replaced tekkit_v1 and/or hexxit_v1 with your container name.
```
# Auto-Save
*/5 * * * * DOCKER_TAG=tekkit && sudo docker commit -m "$(date +%F_%Hh%Mm%Ss) autosave" tekkit_v1 $DOCKER_TAG:autosave
*/5 * * * * DOCKER_TAG=hexxit && sudo docker commit -m "$(date +%F_%Hh%Mm%Ss) autosave" hexxit_v1 $DOCKER_TAG:autosave
```

### Viewing logs
Watch/tail current logs: `sudo docker attach tekkit_v1` (Ctrl+Z to dettach)

Output ALL logs to screen `sudo docker logs tekkit_v1`

### Map Export as docker container
```
sudo docker export tekkit_v1 > ~/tekkit_server_container.tgz
```

### Importing your old map
* If you want to dockerize your old map simply use the Dockerfile 'ADD' command to drop map files into /minecraft/world after the existing dockerfile actions, then re-build the docker image...you'll need to `sudo docker rm tekkit_v1` or `hexxit_v1` if you named them.
```
Example coming
```
