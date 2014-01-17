Minecraft, Tekkit, Hexxit, and Overviewer Dockerfiles based off of Michael Crosby's
Advanced Docker Volume tutorial: http://crosbymichael.com/advanced-docker-volumes.html 
Dockerfiles: https://github.com/crosbymichael/Dockerfiles

*Example Usage*
Customize ram values in launch.sh of your desired server type
```
cd tekkit
sudo docker build -t 'tekkit' .
cd hexxit
sudo docker build -t 'hexxit' .
cd ../mapserver/
sudo docker build -t 'mapserver' .
cd ../overviewer/
sudo docker build -t 'overviewer' .

TEKKIT=$(sudo docker run -d tekkit)
MAPSERVER=$(sudo docker run -d mapserver)

```


**Auto commiting updated maps into docker images**
```
# Add to crontab on your save schedule
TAG=hexxit
sudo docker commit -m "$(date +%F_%Hh%Mm%Ss) autosave" $(sudo docker ps | grep $TAG | cut -c-12) $TAG:autosave
```
