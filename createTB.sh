#!/bin/bash
 TBName=$(whiptail --title "Create Database" --inputbox "Enter Database Name:" 10 60 3>&1 1>&2 2>&3)

    if [[ $? -ne 0 || -z "$TBName" ]]; then
        whiptail --title "Error" --msgbox "Operation canceled or no name entered." 10 60
        return
    fi

        read -p "Please Enter Table Name: " TBName
        if [[ -e $TBName ]]
        then
                echo "Table is Already Exist"
        else
                read -p "Please Enter Columns numbers" colNum
                flag=0
                for ((i=0;i<$colNum;i++))
                do
                        line=""
                        read -p "Please Enter name of Column number $(($i+1)): " colName
                        line+=$colName:
                        read -p "Please Enter Column $colName datatype: " colDataType
                        line+=$colDataType:
                        if [[ flag -eq 0 ]]
                        then
                        read -p "Do you want to make this column a primary key ? (y/n)" check
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
        ;;
