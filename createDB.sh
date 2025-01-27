Creat_DB() {
    DBName=$(whiptail --title "Create Database" --inputbox "Enter Database Name:" 10 60 3>&1 1>&2 2>&3)

    if [[ $? -ne 0 || -z "$DBName" ]]; then
        whiptail --title "Error" --msgbox "Operation canceled or no name entered." 10 60
        return
    fi
    if [[ -e DataBase/"$DBName" ]]; then
        whiptail --title "Error" --msgbox "Database '$DBName' already exists." 10 60
    else
        
        mkdir -p DataBase/"$DBName"
        whiptail --title "Success" --msgbox "Database '$DBName' created successfully." 10 60
    fi
} 