#!/bin/sh
XMX='3G'
XMS='2G'
JAR='Hexxit.jar'

java -Xmx$XMX -Xms$XMS -jar $JAR nogui
