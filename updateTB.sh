#!/bin/bash

update_table() {
    # List all tables (non-hidden files)
    tables=($(ls -p | grep -v / | grep -vE '^\.'))

    if [ ${#tables[@]} -eq 0 ]; then
        whiptail --title "Error" --msgbox "No tables found in the current database." 10 60
        return
    fi

    # Build whiptail menu
    menu_options=()
    for i in "${!tables[@]}"; do
        menu_options+=("$((i+1))" "${tables[$i]}")
    done

    # Show table selection menu
    selected_index=$(whiptail --title "Table Selection" --menu "Choose a table to update:" 15 50 5 "${menu_options[@]}" 3>&1 1>&2 2>&3)
    [ $? -ne 0 ] && return

    tname="${tables[$((selected_index-1))]}"

    # Check metadata file
    if [ ! -f ".${tname}-metadata" ]; then
        whiptail --title "Error" --msgbox "Metadata for $tname not found!" 10 60
        return
    fi

    # Show current data
    tempfile=$(mktemp)
    echo -e "=== Current Data in $tname ===" > "$tempfile"
    cat "$tname" >> "$tempfile"  # Remove .table extension
    whiptail --title "Table Contents" --scrolltext --textbox "$tempfile" 20 60
    rm -f "$tempfile"

    # Get primary key
    pk=$(whiptail --title "Update Row" --inputbox "Enter primary key value:" 10 60 3>&1 1>&2 2>&3)
    [ -z "$pk" ] && return

    # Verify primary key exists
    if ! grep -q "^$pk:" "$tname"; then
        whiptail --title "Error" --msgbox "Primary key '$pk' not found!" 10 60
        return
    fi

    # Read metadata
    mapfile -t columns < <(awk -F: '{print $1":"$2}' ".${tname}-metadata")
    pk_col=$(awk -F: '/:pk$/ {print $1}' ".${tname}-metadata")

    # Get existing row
    old_row=$(grep "^$pk:" "$tname")
    IFS=':' read -ra old_values <<< "$old_row"
    new_values=("${old_values[@]}")

    # Update columns
    for i in "${!columns[@]}"; do
        IFS=':' read -r col_name col_type <<< "${columns[$i]}"
        
        # Skip primary key column
        [[ "$col_name" == "$pk_col" ]] && continue

        while true; do
            new_val=$(whiptail --title "Update Column" \
                --inputbox "New value for $col_name ($col_type)\nCurrent: ${old_values[$i]}\n(Leave empty to keep)" \
                12 60 "${old_values[$i]}" 3>&1 1>&2 2>&3)
            [ $? -ne 0 ] && return

            # Keep original value if empty
            [ -z "$new_val" ] && break

            # Validate input
            case $col_type in
                int) [[ "$new_val" =~ ^[0-9]+$ ]] || {
                    whiptail --title "Error" --msgbox "Invalid integer!" 10 60
                    continue
                } ;;
                string) new_val=$(echo "$new_val" | tr ' ' '_') ;;
                bool) [[ "$new_val" =~ ^(true|false)$ ]] || {
                    whiptail --title "Error" --msgbox "Must be 'true' or 'false'!" 10 60
                    continue
                } ;;
            esac

            new_values[$i]="$new_val"
            break
        done
    done

    # Update the file
    updated_row=$(IFS=:; echo "${new_values[*]}")
    awk -v pk="$pk" -v new="$updated_row" -F: '
        BEGIN {OFS=FS} 
        $1 == pk {print new; next} 
        {print}
    ' "$tname" > tmpfile && mv tmpfile "$tname"

    # Show updated data
    tempfile=$(mktemp)
    echo -e "=== Updated Data in $tname ===" > "$tempfile"
    cat "$tname" >> "$tempfile"
    whiptail --title "Success" --scrolltext --textbox "$tempfile" 20 60
    rm -f "$tempfile"
}