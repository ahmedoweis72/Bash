#!/bin/bash

# delete_from_table() {
#     # List tables (non-hidden files)
#     tables=($(ls -p | grep -v / | grep -vE '^\.'))

#     if [ ${#tables[@]} -eq 0 ]; then
#         whiptail --title "Error" --msgbox "No tables found in current database." 10 60
#         return
#     fi

#     # Build table selection menu
#     menu_options=()
#     for i in "${!tables[@]}"; do
#         menu_options+=("$((i+1))" "${tables[$i]}")
#     done

#     # Select table
#     selected_index=$(whiptail --title "Delete Row" --menu "Choose a table:" 15 50 5 "${menu_options[@]}" 3>&1 1>&2 2>&3)
#     [ $? -ne 0 ] && return

#     table_name="${tables[$((selected_index-1))]}"

#     # Show table contents
#     tempfile=$(mktemp)
#     echo -e "=== Current Data in $table_name ===" > "$tempfile"
#     nl -w 3 -s '. ' "$table_name" >> "$tempfile"
#     whiptail --title "Table Contents" --scrolltext --textbox "$tempfile" 20 60
#     rm -f "$tempfile"

#     # Get row number
#     while true; do
#         row_number=$(whiptail --title "Delete Row" --inputbox "Enter row number to delete:" 10 60 3>&1 1>&2 2>&3)
#         [ -z "$row_number" ] && return

#         # Validate row number
#         total_rows=$(wc -l < "$table_name")
#         if [[ ! "$row_number" =~ ^[0-9]+$ ]] || [ "$row_number" -lt 1 ]; then
#             whiptail --title "Error" --msgbox "Invalid row number!\nMust be positive integer." 10 60
#             continue
#         fi

#         if [ "$row_number" -gt "$total_rows" ]; then
#             whiptail --title "Error" --msgbox "Row $row_number out of range!\nTable has $total_rows rows." 10 60
#             continue
#         fi

#         if [ "$row_number" -le 2 ]; then
#             whiptail --title "Error" --msgbox "Rows 1 and 2 cannot be deleted (reserved)." 10 60
#             continue
#         fi

#         break
#     done

#     # Show row preview
#     preview_row=$(sed -n "${row_number}p" "$table_name")
#     whiptail --title "Preview Row" --yesno "Delete this row?\n\n$preview_row" 12 60
#     if [ $? -eq 0 ]; then
#         # Delete row and preserve header
#         sed -i "${row_number}d" "$table_name"
#         whiptail --title "Success" --msgbox "Row $row_number deleted successfully!" 10 60
#     else
#         whiptail --title "Canceled" --msgbox "Deletion canceled." 10 60
#     fi
# }

delete_from_table() {
    # List tables (non-hidden files)
    tables=($(ls -p | grep -v / | grep -vE '^\.'))

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
    selected_index=$(whiptail --title "Delete Row" --menu "Choose a table:" 15 50 5 "${menu_options[@]}" 3>&1 1>&2 2>&3)
    [ $? -ne 0 ] && return

    table_name="${tables[$((selected_index-1))]}"

    # Check metadata
    if [ ! -f ".${table_name}-metadata" ]; then
        whiptail --title "Error" --msgbox "Metadata for $table_name not found!" 10 60
        return
    fi

    tempfile=$(mktemp)
    echo -e "=== Current Data in $table_name ===" > "$tempfile"
    cat "$table_name" >> "$tempfile"  # Remove .table extension
    whiptail --title "Table Contents" --scrolltext --textbox "$tempfile" 20 60
    rm -f "$tempfile"

    # Get primary key info
    pk_col=$(awk -F: '/:pk$/ {print $1}' ".${table_name}-metadata")
    pk_field=$(awk -F: '/:pk$/ {print NR}' ".${table_name}-metadata")
    if [ -z "$pk_col" ]; then
        whiptail --title "Error" --msgbox "Primary key not defined in metadata!" 10 60
        return
    fi

    # Get primary key value
    pk_value=$(whiptail --title "Delete Row" --inputbox "Enter $pk_col value:" 10 60 3>&1 1>&2 2>&3)
    [ -z "$pk_value" ] && return

    # Find matching row
    row=$(awk -F: -v pk="$pk_value" -v f="$pk_field" '$f == pk' "$table_name")
    if [ -z "$row" ]; then
        whiptail --title "Error" --msgbox "$pk_col '$pk_value' not found!" 10 60
        return
    fi

    # Confirm deletion
    whiptail --title "Confirm" --yesno "Delete this row?\n\n$row" 12 60
    if [ $? -eq 0 ]; then
        # Delete row and preserve others
        awk -F: -v pk="$pk_value" -v f="$pk_field" '$f != pk' "$table_name" > tmpfile && mv tmpfile "$table_name"
        whiptail --title "Success" --msgbox "Row deleted successfully!" 10 60
    else
        whiptail --title "Canceled" --msgbox "Deletion canceled." 10 60
    fi
}