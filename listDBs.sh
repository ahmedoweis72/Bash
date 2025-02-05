#!/bin/bash
List_DBs() {
  # Check if databases directory exists and get list
    if [ ! -d "./DataBase" ]; then
        whiptail --title "Error" --msgbox "Database directory does not exist." 10 60
        return 1
    fi

    databases=$(ls -1 "./DataBase" 2>/dev/null)
    count=$(echo "$databases" | wc -l)

    if [ "$count" -eq 0 ]; then
        whiptail --title "Error" --msgbox "You don't have any databases yet." 10 60
    else
        # Create a temporary file for scrollable content
        tempfile=$(mktemp)
        echo -e "=== Available Databases ===\n" > "$tempfile"
        # Add numbering using awk
        echo "$databases" | awk '{print NR ". " $0}' >> "$tempfile"
        whiptail --title "Database List" --textbox "$tempfile" 20 60
        rm -f "$tempfile"
    fi
}