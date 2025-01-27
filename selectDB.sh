#!/bin/bash

Select_DB() {
    
    DBName=$(whiptail --title "Select Database" --inputbox "Please Enter Database Name:" 10 60 3>&1 1>&2 2>&3)

    if [[ $? -ne 0 || -z "DataBase/$DBName" ]]; then
        whiptail --title "Error" --msgbox "Operation canceled or no name entered." 10 60
        return
    fi   
    if [[ -d "DataBase/$DBName" ]]; then
        cd "DataBase/$DBName" || exit  
        whiptail --title "Success" --msgbox "Database '$DBName' is connected successfully." 10 60
    else
        whiptail --title "Error" --msgbox "Database '$DBName' does not exist." 10 60
    fi
}