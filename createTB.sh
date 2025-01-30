#!/bin/bash

Creat_TA(){

 TBName=$(whiptail --title "Create Table" --inputbox "Enter Table Name:" 10 60 3>&1 1>&2 2>&3)

    if [[ -z "$TBName" ]]; then
        whiptail --title "Error" --msgbox "Operation canceled or no name entered." 10 60
        cd DataBase
        return
    fi
        if [[ -e $TBName ]]
        then
                echo "Table is Already Exist"
                cd DataBase
        else
                # read -p "Please Enter Columns numbers" colNum
                colNum=$(whiptail --title "Create Table" --inputbox "Please Enter Columns numbers:" 10 60 3>&1 1>&2 2>&3)
                flag=0
                for ((i=0;i<$colNum;i++))
                do
                        line=""
                        
                        # read -p "Please Enter name of Column number $(($i+1)): " colName
                        colName=$(whiptail --title "Create Table" --inputbox "Please Enter name of Column number$(($i+1)):" 10 60 3>&1 1>&2 2>&3)
                
                        line+=$colName:
                        # read -p "Please Enter Column $colName datatype: " colDataType
                        colDataType=$(whiptail --title "Create Table" --inputbox "Please Enter Column $colName datatype:" 10 60 3>&1 1>&2 2>&3)
                
                        line+=$colDataType:
                        if [[ flag -eq 0 ]]
                        then
                        # read -p "Do you want to make this column a primary key ? (y/n)" check
                        check=$(whiptail --title "Create Table" --inputbox "Do you want to make this column a primary key ? (y/n):" 10 60 3>&1 1>&2 2>&3)
                
                                if [[ yes =~ $check ]]
                                then
                                        line+=pk
                                        flag=1
                                fi
                        fi
                        echo $line >> .$TBName-metadata
                done
                touch $TBName
        fi
       
}

