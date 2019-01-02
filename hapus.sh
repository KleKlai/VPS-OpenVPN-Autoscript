#!/bin/bash
#Script to remove SSH & OpenVPN users
clear
read -p "Enter username to be terminate: " Users

if getent passwd $Users > /dev/null 2>&1; then
        userdel $Users
        echo -e "$Users connection has been terminated successfully."
else
        echo -e "Oops something went wrong, $Users doesn't exist ."
        echo -e "You can use 'member' command to see member list"
fi
