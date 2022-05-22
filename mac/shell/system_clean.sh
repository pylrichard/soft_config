#!/bin/sh

sudo find / -name ".DS_Store" -type f -delete
sudo find / -name "*.lastUpdated" -type f -delete
sudo find / -name "._*" -type f -delete
sudo periodic daily weekly monthly
