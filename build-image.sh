#!/bin/bash

cat ~/.ssh/id_rsa.pub > id_rsa.pub

echo  "build docker hadoop image"
docker build -t tqc/hadoop:1.0 .
