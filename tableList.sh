#!/bin/bash

. createTB.sh
. listTB.sh
. updateTB.sh
. dropTB.sh
. insertIntoTB.sh
. deleteFromTable.sh
. selectFromTB.sh

ListOfTable(){
    while true; do
    choice=$(whiptail --title "Table Management" --menu "Choose an option" 15 60 4 \
        "1" "Create Table" \
        "2" "List Tables" \
        "3" "Insert into Table" \
        "4" "Select From Table" \
        "5" "Delete From Table" \
        "6" "Update Table" \
        "7" "Drop Table" \
        "8" "Quit" 3>&1 1>&2 2>&3)

    case $choice in
        1)
            whiptail --title "Create Table"  10 60
            Creat_TA
            ;;
        2)
            whiptail --title "List Tables"  10 60
            list_tables
            ;;
        3)
            whiptail --title "Insert Into Table"  10 60
            insert_into_table
            ;;
        4)
            whiptail --title "Select From Table"  10 60
            select_from_table
            ;;
        5)
            whiptail --title "Delete From Table"  10 60
            delete_from_table
            ;;
        6)
            whiptail --title "Update Table"  10 60
            update_table
            ;;
        7)
            whiptail --title "Drop Table"  10 60
            drop_table
            ;;
        8)
            whiptail --title "Quit" --msgbox "Exiting To Main." 10 60
            cd ../..
            break
            ;;
        *)
            whiptail --title "Invalid Option" --msgbox "Invalid option selected." 10 60
            ;;
    esac
done
}
