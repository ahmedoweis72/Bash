#!/bin/bash

Drop_DB() {
  # Check if DataBase directory exists
  if [ ! -d "DataBase" ]; then
    whiptail --title "Error" --msgbox "Database directory does not exist." 10 60
    return 1
  fi

  files=($(ls DataBase))

  if [ ${#files[@]} -eq 0 ]; then
    whiptail --title "Error" --msgbox "No databases found." 10 60
    return 1
  fi

  menu_options=()
  for i in "${!files[@]}"; do
    menu_options+=("$((i+1))" "${files[$i]}")  # Fixed: No "." in tags
  done

  selected_index=$(whiptail --title "Delete Database" --menu "Select a database to delete:" 15 50 5 "${menu_options[@]}" 3>&1 1>&2 2>&3)

  if [ $? -eq 0 ]; then
    DBName="${files[$((selected_index-1))]}"
    if rm -rf "DataBase/$DBName"; then  # Force-delete
      whiptail --title "Success" --msgbox "Database '$DBName' deleted successfully." 10 60
    else
      whiptail --title "Error" --msgbox "Failed to delete database '$DBName'." 10 60
    fi
  else
    whiptail --title "Canceled" --msgbox "Deletion canceled." 10 60
  fi
}