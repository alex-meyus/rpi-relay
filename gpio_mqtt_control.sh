#!/bin/bash

#https://www.waveshare.com/wiki/RPi_Relay_Board_(B)
#Channel number	RPi pin number	wiringPi	BCM	Description
#Channel label	29	P21	5	Channel 1
#Channel label	31	P22	6	Channel 2
#Channel label	33	P23	13	Channel 3
#Channel label	36	P27	16	Channel 4
#Channel label	35	P24	19	Channel 5
#Channel label	38	P28	20	Channel 6
#Channel label	40	P29	21	Channel 7
#Channel label	37	P25	26	Channel 8

# Debug switch
DEBUG=0

# MQTT-Setting - edit to your own
MQTT_SERVER="srv-iobroker"
MQTT_TOPIC="gpio/#" #MQTT message in IoBroker: mqtt.0.gpio.6
MQTT_USER="mqtt"
MQTT_PW="mqtt"
MQTT_PORT="1884"

# MQTT-messages receiving & processing
process_message() {
    topic=$1
    if [ $DEBUG = 1 ]; then echo "pm1:"$1; fi
    message=$2
    if [ $DEBUG = 1 ]; then echo "pm2:"$2; fi
    
    # GPIO-Nummer aus dem Topic extrahieren
    gpio=$(echo $topic | cut -d'/' -f2)
    if [ $DEBUG = 1 ]; then echo "pm3:"$gpio; fi
    # Befehl aus der Nachricht extrahieren
    command=$message
    
    case $command in
        "true") #inverse Logik!
            # GPIO einschalten            
            pinctrl set $gpio op dl
            ;;
        "false")
            # GPIO ausschalten
            pinctrl set $gpio op dh
            ;;
        *)
            echo "Unbekannter Befehl: $command"
            ;;
    esac
}

# MQTT-Subscription starting
mosquitto_sub -h $MQTT_SERVER -p $MQTT_PORT -u $MQTT_USER -P $MQTT_PW -t $MQTT_TOPIC -v | while read -r line
do
    if [ $DEBUG = 1 ]; echo "Read from mqtt: >>"$line"<<"; fi
    topic=$(echo $line | cut -d' ' -f1)
    #topic=$(echo $line | cut -d' ' -f1 | cut -d'/' -f2)
    if [ $DEBUG = 1 ]; then echo "mqtt-t"$topic; fi
    message=$(echo $line | cut -d' ' -f2-)
    if [ $DEBUG = 1 ]; then echo "mqtt-m:"$message; fi
    process_message "$topic" "$message"
done
