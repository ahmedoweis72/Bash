#!/bin/bash
. createDB.sh
. selectDB.sh

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
        "1" "Create DataBase" \
        "2" "Connect DataBase" \
        "3" "Drop DataBase" \
        "4" "Quit" 3>&1 1>&2 2>&3)

    case $choice in
        1)
            whiptail --title "Create DataBase"  10 60
            Creat_DB
            ;;
        2)
            whiptail --title "Connect DataBase"  10 60
            Select_DB
            ;;
        3)
            whiptail --title "Drop DataBase"  10 60
            ;;
        4)
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