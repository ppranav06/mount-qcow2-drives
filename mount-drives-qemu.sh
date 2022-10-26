#!/bin/bash
# Script to mount and unmount .qcow2 images
# Prerequisites: qemu and nbd drivers 

# Check for root
check_root(){
    if [[ $(whoami) != "root" ]]; then echo "Execute as root!"; exit 1; fi
}

# $1 = Path, $2 = drive number

syntax(){
    printf "\nMOUNT .qcow2 IMAGES AS DRIVES\n\n"
    printf "Usage: $0 [path_to_file] [drive number] \n\n"
    printf "\t path_to_file: Absolute path to the .qcow2 drive file\n\t drive number: number to mount between 0 to 15\n\n"
}

check_empty(){
    if [[ $1 == "" ]]; then echo "Enter a path to the file!" ; fi
    if [[ $2 == "" ]]; then echo "Enter the drive number to be mounted at!"; fi
    if [[ $1 == "" ]] && [[ $2 == "" ]]; then syntax #COMPLETE THE FUNCTION HERE!!
    fi
}

drive_ltr(){
case $1 in 
    0) echo "/dev/nbd0" ;;
    1) echo "/dev/nbd1" ;;
    2) echo "/dev/nbd2" ;;
    3) echo "/dev/nbd3" ;;
    4) echo "/dev/nbd4" ;;
    5) echo "/dev/nbd5" ;;
    6) echo "/dev/nbd6" ;;
    7) echo "/dev/nbd7" ;;
    8) echo "/dev/nbd8" ;;
    9) echo "/dev/nbd9" ;;
    10) echo "/dev/nbd10" ;;
    11) echo "/dev/nbd11" ;;
    12) echo "/dev/nbd12" ;;
    13) echo "/dev/nbd13" ;;
    14) echo "/dev/nbd14" ;;
    15) echo "/dev/nbd15" ;;
esac
}

connect(){
    path=$1
    num=$2      #Assigning function arguments (not args of script) to $path and $num
    # Note: args to script are given as function args
    drive=$(drive_ltr $num)
    qemu-nbd -c $drive $path
    echo "Connected $1 at $drive"
}

disconnect(){
    num=$1 #first argument to the "disconnect()" function, not script
    drive=$(drive_ltr $num)

    qemu-nbd -d $drive
    echo "Disconnected $drive"
}


main(){
    # EXECUTING FUNCTION
    check_root
    check_empty $1 $2       # Script arguments as function arguments

    modprobe nbd

    while true;
    do
        read -p "1. Mount \
        2. Disconnect \
        3. Exit \
        Enter your choice: " choice
        
        case $choice in
        1) connect $1 $2 ;;         # Connects path at $1 to drive number at $2
        2) disconnect $2 ;;         # Disconnects $2 (drive number)
        3) rmmod nbd; exit 0 ;;     # Removes nbd and exits
        esac
    done

}

main $1 $2