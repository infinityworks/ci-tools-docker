#!/bin/bash

/usr/local/bin/consul-template -config "/etc/consul_template.d" -once
sudo chown jenkins /var/run/docker.sock
exec /usr/local/bin/jenkins.sh