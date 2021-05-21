#!/bin/bash

PERSISTENT_PEERS="\"620acf78f2430ef69c181eee0cceec89b1694f2f@ip-10-0-0-60.ec2.internal:26656,330af5084dca908e405bffb91dd5509dd53e3a1b@ip-10-0-1-109.ec2.internal:26656\""

sed -i "s/persistent_peers\ =.*/persistent_peers\ =\ $PERSISTENT_PEERS/" /home/ubuntu/config/config.toml
sed -i "s/pex\ =.*/pex\ =\ false/" /home/ubuntu/config/config.toml

sudo sed -i "s/\ -t\ /\ /" /etc/supervisor/conf.d/cosmovisor_provenanced.conf

sudo service supervisor restart
