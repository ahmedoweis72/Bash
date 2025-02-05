#!/bin/bash
. createDB.sh
. selectDB.sh
. listDBs.sh
. dropDB.sh

Entry_Point(){
   
    export NEWT_COLORS='
root=,blue
window=white
border=white,blue
textbox=white,blue
button=black,white
actbutton=red,black
'

while true; do
    choice=$(whiptail --title "Database Management" --menu "Choose an option" 15 60 4 \
        "1" "Create Database" \
        "2" "Connect Database" \
        "3" "List Databases" \
        "4" "Drop Database" \
        "5" "Quit" 3>&1 1>&2 2>&3)

    case $choice in
        1)
            whiptail --title "Create Database"  10 60
            Creat_DB
            ;;
        2)
            whiptail --title "Connect Database"  10 60
            Select_DB
            ;;
        3)
            whiptail --title "List Databases"  10 60
            List_DBs
            ;;
        4)
            whiptail --title "Drop Database"  10 60
            Drop_DB
            ;;
        5)
            whiptail --title "Quit" --msgbox "Exiting the program." 10 60
            clear
            break
            ;;
        *)
            whiptail --title "Invalid Option" --msgbox "Invalid option selected." 10 60
            ;;
    esac
done
}
Entry_Point