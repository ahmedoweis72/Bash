#!/bin/bash

Creat_TA(){

 TBName=$(whiptail --title "Create Table" --inputbox "Enter Table Name:" 10 60 3>&1 1>&2 2>&3)

    if [[ -z "$TBName" ]]; then
        whiptail --title "Error" --msgbox "Operation canceled or no name entered." 10 60
        return
    fi
        if [[ -e $TBName ]]
        then
                echo "Table is Already Existed"
                cd DataBase
        else
                # read -p "Please Enter Columns numbers" colNum
                colNum=$(whiptail --title "Create Table" --inputbox "Please Enter Columns numbers:" 10 60 3>&1 1>&2 2>&3)
                if [[ -z "$colNum" ]]; then
                        whiptail --title "Error" --msgbox "Operation canceled or no Numbers entered." 10 60
                        return
                fi
                flag=0
                for ((i=0;i<$colNum;i++))
                do
                        line=""
                        
                        # read -p "Please Enter name of Column number $(($i+1)): " colName
                        colName=$(whiptail --title "Create Table" --inputbox "Please Enter name of Column number$(($i+1)):" 10 60 3>&1 1>&2 2>&3)
                        if [[ -z "$colName" ]]; then
                                whiptail --title "Error" --msgbox "Operation canceled or no Name entered." 10 60
                                return
                        fi
                        declare -a columns
                        columns+=("$colName")
                
                        line+=$colName:


                        # read -p "Please Enter Column $colName datatype: " colDataType
                        colDataType=$(whiptail --title "Create Table" --inputbox "Please Enter Column $colName datatype:" 10 60 3>&1 1>&2 2>&3)
                        if [[ -z "$colDataType" ]]; then
                                whiptail --title "Error" --msgbox "Operation canceled or no type entered." 10 60
                                return
                        fi
                        
                
                        line+=$colDataType:
                        if [[ flag -eq 0 ]]
                        then
                        # read -p "Do you want to make this column a primary key ? (y/n)" check
                        check=$(whiptail --title "Create Table" --inputbox "Do you want to make this column a primary key ? (y/n):" 10 60 3>&1 1>&2 2>&3)
                        
                        if [[ -z "$check" ]]; then
                                whiptail --title "Error" --msgbox "Operation canceled or no choice entered." 10 60
                                return
                        fi
                
                                if [[ yes =~ $check ]]
                                then
                                        line+=pk
                                        flag=1
                                fi
                        fi
                        echo $line >> .$TBName-metadata
                done
                # Create table file with header
                # echo "$(IFS=:; echo "${columns[*]}")" > "$TBName"
                # whiptail --title "Success" --msgbox "Table '$TBName' created successfully!" 10 60
                touch $TBName
        fi
       
}

