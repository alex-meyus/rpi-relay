#Update and check dependecys
apt update
apt install mosquitto-clients
chmod +x gpio_mqtt_control.sh
echo "Check Config of MQTT and GPIO"
(crontab -l 2>/dev/null; echo "@reboot sleep 5 && /home/alex/rpi-relay/gpio_mqtt_control.sh &") | crontab -
