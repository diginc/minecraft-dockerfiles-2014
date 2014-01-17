#!/bin/sh
if [ -n $1 ] ; then
  XMX='3G'
  XMS='2G'
  JAVA_ARGS="-Xmx${XMX} -Xms${XMS}"
else
  JAVA_ARGS=$1
fi;

JAR='Tekkit.jar'
java $1 -jar $JAR nogui
