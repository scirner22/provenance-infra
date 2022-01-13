#!/bin/bash

echo 'mode = "full"' >> /home/ubuntu/config/config.toml

sudo sed -i "s/\ -t\ /\ /" /etc/supervisor/conf.d/cosmovisor_provenanced.conf

sudo service supervisor restart
