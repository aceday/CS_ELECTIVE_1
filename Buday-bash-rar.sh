#!/bin/bash

# Requires root if you want to archive system files :)

logo() {
    clear
    echo -e "\e[1;32m
    ██████   █████  ██████        ███████ ████████ ██    ██ ██████  ██  ██████  
    ██   ██ ██   ██ ██   ██       ██         ██    ██    ██ ██   ██ ██ ██    ██ 
    ██████  ███████ ██████  █████ ███████    ██    ██    ██ ██   ██ ██ ██    ██ 
    ██   ██ ██   ██ ██   ██            ██    ██    ██    ██ ██   ██ ██ ██    ██ 
    ██   ██ ██   ██ ██   ██       ███████    ██     ██████  ██████  ██  ██████                                                                          
    \e[0m"
}

pause(){
    read -p "Press [Enter] key to continue..." fackEnterKey
}

pause_nul() {
    read -n 1 -s -r -p ""
}
# Initial Variables
screen=1
queue_files=()
queue_files_text=""


while [ $screen -gt 0 ]; do
    logo
    echo "SELECTIONS"
    echo "[1] Add files to RAR Archive"
    echo "[2] Extract files from RAR Archive"
    echo "[3] List files in RAR Archive"
    echo "[4] Test RAR Archive"
    echo "[5] Exit"

    read -p "Enter your selection: " main_choice

    case $main_choice in
        1)
            logo
            read -p "Name of new RAR Arcive: " rar_name

            screen=2

            # Listing the files in the queue
            while [ $screen -gt 1 ]; do
                logo
                echo "Queue Files/Folders"
                for i in "${!queue_files[@]}"; do
                    echo "[$i] ${queue_files[$i]}"
                done
                echo ""
                echo "[D] Done | [S#] Remove from queue | [B] Back"
                read -p "Input filename or directory to append: " object_name
                case $object_name in
                    'D')
                        screen=1
                        ;;
                    'B')
                        screen=1
                        ;;
                    'S'*)
                        index=${object_name:1}
                        unset queue_files[$index]
                        ;;
                    *)
                        # In this part condition to checking the file or directory is exist or not
                        if [ -e "$object_name" ]; then
                            queue_files+=("$object_name")
                        else
                            echo ""
                            echo "$object_name not exists!"
                            pause_nul
                        fi
                        ;;
                esac
            done
            # Create the RAR Archive
            # And this part condition 
            if [ $object_name -eq 'D' ] && [ ${#queue_files[@]} -gt 0 ]; then
                rar a "$rar_name" "${queue_files[@]}"
                screen=1
            fi
            pause
            ;;
        2)
            logo
            read -p "Enter the name of the RAR Archive: " rar_name
            read -p "Enter the name of the file to extract: " file_name
            rar x $rar_name $file_name
            pause
            ;;
        3)
            logo
            read -p "Enter the name of the RAR Archive: " rar_name
            rar l $rar_name
            pause
            ;;
        4)
            logo
            read -p "Enter the name of the RAR Archive: " rar_name
            rar t $rar_name
            pause
            ;;
        5)
            logo
            echo "Goodbye!"
            exit 0
            ;;
        *)
            logo
            echo "Invalid selection!"
            pause
            ;;
    esac
done
