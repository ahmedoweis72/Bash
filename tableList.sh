#!/bin/bash

. createTB.sh

ListOfTable(){
    while true; do
    choice=$(whiptail --title "Table Management" --menu "Choose an option" 15 60 4 \
        "1" "Create Table" \
        "2" "Update Table" \
        "3" "Drop Table" \
        "4" "Quit" 3>&1 1>&2 2>&3)

    case $choice in
        1)
        
            whiptail --title "Create Table"  10 60
            Creat_TA
            ;;
        2)
            whiptail --title "Update Table"  10 60
            Select_DB
            ;;
        3)
            whiptail --title "Drop Table"  10 60
            ;;
        4)
            whiptail --title "Quit" --msgbox "Exiting To Main." 10 60
            cd DataBase
            break
            ;;
        *)
            whiptail --title "Invalid Option" --msgbox "Invalid option selected." 10 60
            ;;
    esac
done
}
