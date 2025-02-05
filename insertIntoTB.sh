#!/bin/bash

insert_into_table() {
    # List all tables (non-hidden files)
    tables=($(ls -1 2>/dev/null))

    if [ ${#tables[@]} -eq 0 ]; then
        whiptail --title "Error" --msgbox "No tables found in current database." 10 60
        return
    fi

    # Build selection menu
    menu_options=()
    for i in "${!tables[@]}"; do
        menu_options+=("$((i+1))" "${tables[$i]}")
    done

    # Select table
    selected_index=$(whiptail --title "Insert Data" --menu "Choose a table:" 15 50 5 "${menu_options[@]}" 3>&1 1>&2 2>&3)
    [ $? -ne 0 ] && return

    table_name="${tables[$((selected_index-1))]}"

    # Check metadata file
    if [ ! -f ".${table_name}-metadata" ]; then
        whiptail --title "Error" --msgbox "Metadata for $table_name not found!" 10 60
        return
    fi

    # Read schema
    columns=()
    pk_index=-1
    while IFS=':' read -r col_name col_type col_extra; do
        columns+=("$col_name:$col_type")
        [[ "$col_extra" == *"pk"* ]] && pk_index=$(( ${#columns[@]} - 1 ))
    done < ".${table_name}-metadata"

    new_row=()

    # Process columns
    for index in "${!columns[@]}"; do
        IFS=':' read -r col_name col_type <<< "${columns[$index]}"
        while true; do
            input=$(whiptail --title "Enter Value" \
                --inputbox "Column: $col_name ($col_type)\nEnter value:" \
                12 60 3>&1 1>&2 2>&3)
            [ $? -ne 0 ] && return

            input=$(echo "$input" | xargs)

            # Validate type
            case $col_type in
                int) [[ "$input" =~ ^[0-9]+$ ]] || { 
                    whiptail --title "Error" --msgbox "Invalid integer: $input"; continue; } ;;
                string) input=$(echo "$input" | tr ' ' '_')
                     [[ "$input" =~ ^[a-zA-Z0-9_]+$ ]] || {
                    whiptail --title "Error" --msgbox "Invalid characters in string"; continue; } ;;
                *) whiptail --title "Error" --msgbox "Unknown type: $col_type"; return ;;
            esac

            # Check PK uniqueness
            if [ $index -eq $pk_index ]; then
                if grep -q "^$input:" "$table_name" 2>/dev/null; then
                    whiptail --title "Error" --msgbox "Duplicate primary key: $input"
                    continue
                fi
            fi

            new_row+=("$input")
            break
        done
    done

    # Save to table
    echo "${new_row[*]}" | tr ' ' ':' >> "$table_name"
    whiptail --title "Success" --msgbox "Data inserted into $table_name successfully!" 10 60
}