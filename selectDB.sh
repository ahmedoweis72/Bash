#!/bin/bash
. tableList.sh
Select_DB() {
    
    # DBName=$(whiptail --title "Select Database" --inputbox "Please Enter Database Name:" 10 60 3>&1 1>&2 2>&3)

    # if [[ $? -ne 0 || -z "DataBase/$DBName" ]]; then
    #     whiptail --title "Error" --msgbox "Operation canceled or no name entered." 10 60
    #     return
    # fi   
    # if [[ -d "DataBase/$DBName" ]]; then
    #     cd "DataBase/$DBName" || exit  
    #     whiptail --title "Success" --msgbox "Database '$DBName' is connected successfully." 10 60
    # else
    #     whiptail --title "Error" --msgbox "Database '$DBName' does not exist." 10 60
    # fi


files=($(ls DataBase))

if [ ${#files[@]} -eq 0 ]; then
  whiptail --title "Error" --msgbox "No files found in the current directory." 10 60
  
fi


menu_options=()
for i in "${!files[@]}"; do
  menu_options+=("$((i+1))" "${files[$i]}")  
done


selected_index=$(whiptail --title "File Selection" --menu "Please select a file:" 15 50 5 "${menu_options[@]}" 3>&1 1>&2 2>&3)


if [ $? -eq 0 ]; then
  DBName="${files[$((selected_index-1))]}"
  whiptail --title "Success" --msgbox " Database '$DBName' is connected successfully." 10 60
  cd DataBase/$DBName
  ListOfTable
  
else
  echo "No file selected or dialog canceled."
fi
}