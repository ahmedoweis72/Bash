#!/bin/bash

list_tables() {
    # List tables with .table extension (adjust the pattern if needed)
    tables=$(ls -1 2>/dev/null)
    
    if [ -z "$tables" ]; then
        whiptail --title "Error" --msgbox "No tables found in the current database." 10 60
    else
        # Create a temporary file for scrollable content
        tempfile=$(mktemp)
        echo -e "=== Available Tables ===\n" > "$tempfile"
        echo "$tables" | awk '{print NR ". " $0}' >> "$tempfile"  # Add numbering
        whiptail --title "Table List" --textbox "$tempfile" 20 60
        rm -f "$tempfile"
    fi
}