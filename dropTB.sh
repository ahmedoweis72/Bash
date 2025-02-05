#!/bin/bash

drop_table() {
    # List all tables (excluding metadata files)
    tables=($(ls -1 2>/dev/null))  # Remove .table extension

    if [ ${#tables[@]} -eq 0 ]; then
        whiptail --title "Error" --msgbox "No tables found in the current database." 10 60
        return
    fi

    # Build whiptail menu
    menu_options=()
    for i in "${!tables[@]}"; do
        menu_options+=("$((i+1))" "${tables[$i]}")  # Numbered list
    done

    # Show table selection menu
    selected_index=$(whiptail --title "Drop Table" --menu "Choose a table to delete:" 15 50 5 "${menu_options[@]}" 3>&1 1>&2 2>&3)

    if [ $? -ne 0 ]; then
        whiptail --title "Canceled" --msgbox "Operation canceled." 10 60
        return
    fi

    table_name="${tables[$((selected_index-1))]}"

    # Confirmation dialog
    whiptail --title "Confirm Deletion" --yesno "Permanently delete table '$table_name'?\nThis cannot be undone!" 12 60
    if [ $? -eq 0 ]; then
        rm -f "$table_name" ".${table_name}-metadata" 2>/dev/null
        if [ $? -eq 0 ]; then
            whiptail --title "Success" --msgbox "Table '$table_name' deleted successfully." 10 60
        else
            whiptail --title "Error" --msgbox "Failed to delete table '$table_name'." 10 60
        fi
    else
        whiptail --title "Canceled" --msgbox "Table deletion canceled." 10 60
    fi
}