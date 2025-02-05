#!/bin/bash
select_from_table() {
    # List tables (non-hidden files)
    tables=($(ls -p | grep -v / | grep -vE '^\.'))

    if [ ${#tables[@]} -eq 0 ]; then
        whiptail --title "Error" --msgbox "No tables found in current database." 10 60
        return
    fi

    # Build table selection menu
    menu_options=()
    for i in "${!tables[@]}"; do
        menu_options+=("$((i+1))" "${tables[$i]}")
    done

    # Select table
    selected_index=$(whiptail --title "Select Data" --menu "Choose a table:" 15 50 5 "${menu_options[@]}" 3>&1 1>&2 2>&3)
    [ $? -ne 0 ] && return
    tname="${tables[$((selected_index-1))]}"

    # Check metadata
    if [ ! -f ".${tname}-metadata" ]; then
        whiptail --title "Error" --msgbox "Metadata for $tname not found!" 10 60
        return
    fi

    # Get primary key info
    pk_info=$(awk -F: '/:pk$/ {print $1":"NR}' ".${tname}-metadata")
    IFS=':' read -r pk_col pk_line <<< "$pk_info"
    if [ -z "$pk_col" ]; then
        whiptail --title "Error" --msgbox "Primary key not defined in metadata!" 10 60
        return
    fi

    # Selection type
    choice=$(whiptail --title "Selection Type" --menu "Choose option:" 15 50 2 \
        "1" "Show entire table" \
        "2" "Search by primary key" 3>&1 1>&2 2>&3)
    [ $? -ne 0 ] && return

    # Process selection
    case $choice in
        1)
            content=$(column -t -s: "$tname")
            ;;
        2)
            pk_value=$(whiptail --title "Search" --inputbox "Enter $pk_col value:" 10 60 3>&1 1>&2 2>&3)
            [ -z "$pk_value" ] && return
            
            content=$(awk -F: -v pk="$pk_value" -v col="$pk_line" \
                'BEGIN {OFS=" | "} NR==0 {print; next} $col == pk' "$tname" | column -t)
            
            if [ -z "$content" ]; then
                whiptail --title "No Results" --msgbox "No matching rows found!" 10 60
                return
            fi
            ;;
        *) return ;;
    esac

    # Show results
    tempfile=$(mktemp)
    echo -e "=== Table Data ===" > "$tempfile"
    echo "$content" >> "$tempfile"
    whiptail --title "Query Results" --scrolltext --textbox "$tempfile" 20 60
    rm -f "$tempfile"
}