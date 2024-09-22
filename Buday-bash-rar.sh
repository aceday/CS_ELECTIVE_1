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
    By Buday <@aceday>
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
rar_compress="-m3"      # Rar initial compress
rar_cmd=""              # Rar default command
rar_recovery=""         # Rar recovery record
rar_solid=""            # Rar solid archive
rar_split=""            # Rar split archive
# START PROGRAM

# Enters in while loop to recall the '$screen' variable to display the menu
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
            screen=2
            while [ $screen -gt 1 ]; do
            logo
            read -p "Name of new RAR Arcive: " rar_name

            # Check if the RAR Archive already exists
            if [ -e "$rar_name" ]; then
                echo ""
                echo "$rar_name already exists!"
                pause_nul
            # Check if the RAR Archive name is empty
            elif [ -z "$rar_name" ]; then
                echo ""
                echo "Invalid RAR Archive name!"
                pause_nul
            # After doesnt meet 2 condition then else GO
            else
                rar_cmd="rar a $rar_name "       # Overwrite the default command
                screen=1
            fi

            done

            screen=2

            # Listing the files in the queue
            while [ $screen -gt 1 ]; do
                logo
                echo "Queue Files/Folders"
                for i in "${!queue_files[@]}"; do
                    echo "[$i] ${queue_files[$i]}"
                done
                echo ""
                echo "M: $rar_compress | P: $rar_passwd | R: $rar_recovery | SO: $rar_solid | SI: $rar_split"
                echo "[D] Done | [S#] Remove from queue | [B] Back"
                echo "[M] Compression Level | [P] Password | [C] Clear Queue"
                echo "[R] Recovery Record | [SO] Solid Archive | [SI] Split Archive"
                read -p "Input filename or directory to append: " object_name
                case $object_name in
                    'SI')
                        read -p "Enter the size of the split archive (e.g. 10M): " rar_split

                        # Check if the split archive size is valid using regular expression
                        if [[ $rar_split =~ ^[0-9]+[KMG]$ ]]; then
                            # Example: 10M -> -v10M
                            # Example: 15G -> -v15G
                            rar_split="-v$rar_split"
                        else
                            echo ""
                            echo "Invalid split archive size!"
                            pause_nul
                        fi
                        rar_cmd+="-v$rar_split "
                        ;;
                    'SO')
                        read -p "Solid Archive (Y/N): " rar_solid

                        # Check if the user input is 'Y' or 'N'

                        # If the user input is 'Y' or 'y' then set the solid archive to '-s'
                        if [ $rar_solid = 'Y' ] || [ $rar_solid = 'y' ]; then
                            rar_solid="-s"

                        # If the user input is 'N' or 'n' then set the solid archive to ''
                        elif [ $rar_solid = 'N' ] || [ $rar_solid = 'n' ]; then
                            rar_solid=""
                        else
                            echo ""
                            echo "Invalid solid archive!"
                            pause_nul

                        fi
                        rar_solid="-s"
                        ;;
                    'R')
                        read -p "Enter recovery record percentage (0-10): " rar_recovery
                        if [ $rar_recovery -ge 0 ] && [ $rar_recovery -le 10 ]; then
                            rar_recovery="-rr$rar_recovery%"
                        elif [ $rar_recovery -eq 0 ]; then
                            rar_recovery=""
                        else
                            echo ""
                            echo "Invalid recovery record percentage!"
                            pause_nul
                        fi
                        ;;
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


            # If the queue is not empty and the object name says 'D' then create the RAR Archive
            if [ $object_name = 'D' ] && [ ${#queue_files[@]} -gt 0 ]; then

                # Configuration to make rar archive

                # Password
                if [ ! -z "$rar_passwd" ]; then
                    rar_cmd+="-p$rar_passwd "
                    # rar a "$rar_name" $rar_compress "${queue_files[@]}"
                fi
                
                # Compression level
                rar_cmd+="$rar_compress "       # Append the compression level

                # Recovery Record
                # If not empty then append the recovery record
                if [ ! -z "$rar_recovery" ]; then
                    rar_cmd+="$rar_recovery "
                fi

                # Solid Archive
                # If not empty then append the solid archive
                if [ ! -z "$rar_solid" ]; then
                    rar_cmd+="$rar_solid "
                fi
                
                # Split Archive
                # If not empty then append the split archive
                if [ ! -z "$rar_split" ]; then
                    rar_cmd+="$rar_split "
                fi

                # EXECUTE THE RAR COMMAND
                eval $rar_cmd "${queue_files[@]}"

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
