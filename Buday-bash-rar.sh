#!/bin/bash

# Requires root if you want to archive system files :)
# NOTE: Only works on some distros, not working to termux
#       so it unrar only works for all distros.

# Execute if 'rar' is not installed on the system
if ! command -v rar &> /dev/null; then
    echo "rar is not installed"
    echo ""
    echo "Install it by running the following command:"
    echo "sudo apt install rar -y"
    exit 1
fi

# Logo for the script
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

# Pause version
pause(){
    read -p "Press [Enter] key to continue..." fackEnterKey
}

# Pause but in null version
pause_nul() {
    read -n 1 -s -r -p ""
}

# Initial Variables
screen=1                # Screen number
queue_files=()          # Queue files in array type
queue_files_text=""     # Queue files in text file type
rar_passwd=""           # Rar initial password
rar_compress="-m3"         # Rar initial compress


# START PROGRAM

# Enters in while loop to recall the $screen variable to display the menu
while [ $screen -gt 0 ]; do
    logo
    echo "SELECTIONS"
    echo "[1] Add files to RAR Archive"
    echo "[2] Extract files from RAR Archive"
    echo "[3] List files in RAR Archive"
    echo "[4] Test RAR Archive"
    echo "[5] Exit"

    # Make a 'main_choice' variable to store the user's input
    read -p "Enter your selection: " main_choice

    # I choose 'case' statement so i can use to parse the condition
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
                echo "[M] Compression Level | [P] Password | [C] Clear Queue"
                read -p "Input filename or directory to append: " object_name
                case $object_name in
                    'M')
                        read -p "Enter compression level (0-5): " rar_compress
                        if [ $rar_compress -ge 0 ] && [ $rar_compress -le 5 ]; then
                            rar_compress="-m$rar_compress"
                        else
                            echo ""
                            echo "Invalid compression level!"
                            pause_nul
                        fi
                        ;;
                    'P')
                        read -p "Enter password: " rar_passwd
                        ;;
                    'C')
                        queue_files=()
                        ;;
                    'D')
                        screen=1
                        ;;
                    'B')
                        screen=1
                        break
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
            if [ $object_name = 'D' ] && [ ${#queue_files[@]} -gt 0 ]; then
                rar a "$rar_name" "${queue_files[@]}"
                pause_nul
                screen=1
            elif [ $object_name = 'B' ]; then
                screen=1
            else
                echo ""
                echo "No files added to the queue!"
                pause_nul
            fi
            ;;
        2)
            logo
            read -p "Enter rar archive path: " rar_name
            if [ -e "$rar_name" ]; then
                screen=2
                while [ $screen -gt 1 ]; do
                    logo
                    echo "Queue Files/Folders"
                done
                read -p "Enter the name of the file to extract: " file_name
                rar x $rar_name $file_name
            else
                echo ""
                echo "$rar_name not exists!"
                pause_nul
            fi
            # read -p "Enter the name of the RAR Archive: " rar_name
            # read -p "Enter the name of the file to extract: " file_name
            # rar x $rar_name $file_name
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
