#!/bin/bash

export $(grep -v '^#' .env | xargs)

ansible-playbook -i ./deploy/inventory.yml ./deploy/playbook.yml