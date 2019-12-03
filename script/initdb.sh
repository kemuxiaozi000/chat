#!/bin/bash

rails db:environment:set RAILS_ENV="$RAILS_ENV"
echo -e "\\e[48;5;231m\\e[38;5;0m   drop   \\e[0m"
rails db:drop
echo -e "\\e[48;5;231m\\e[38;5;0m   create   \\e[0m"
rails db:create
echo -e "\\e[48;5;231m\\e[38;5;0m   migrate   \\e[0m"
rails db:migrate
echo -e "\\e[48;5;231m\\e[38;5;0m   seed   \\e[0m"
rails db:seed
