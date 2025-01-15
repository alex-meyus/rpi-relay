#Update and check dependecys
apt update
apt install mosquitto-clients
chmod +x gpio_mqtt_control.sh

echo "Check Config of MQTT and GPIO"

#Autostart --> Daemon
# funktioniert nicht #(crontab -l 2>/dev/null; echo "@reboot sleep 5 && /home/alex/rpi-relay/gpio_mqtt_control.sh &") | crontab -
mv rpi-relay.service /etc/systemd/system/rpi-relay.service
systemctl enable rpi-relay.service
systemctl start rpi-relay.service
