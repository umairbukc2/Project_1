#!/bin/bash

create_user() {
    echo "Enter name for username:"
    read username

    echo "Enter password for $username:"
    read -s password
    echo

    if id "$username" &>/dev/null; then
        echo "$username already exists"
    else
        useradd -m -s /bin/bash "$username"
        echo "$username:$password" | chpasswd

        if [[ $? -eq 0 ]]; then 
            echo "$username created successfully"
        else
            echo "Failed to create $username"
        fi
    fi
}

delete_user() {
    echo "Enter the username you want to delete:"
    read username

    if id "$username" &>/dev/null; then
        userdel -r "$username"
        if [[ $? -eq 0 ]]; then
            echo "$username deleted successfully"
        else
            echo "Failed to delete $username"
        fi
    else
        echo "$username doesn't exist"
    fi
}

modify_user() {
    echo "Enter the username you want to modify:"
    read username

    if id "$username" &>/dev/null; then
        echo "Enter the new shell for user:"
        read shell
        echo "Enter the new home directory for user:"
        read homedir

        usermod -s "$shell" -d "$homedir" "$username"
        if [[ $? -eq 0 ]]; then
            echo "$username modified successfully"
        else
            echo "Failed to modify $username"
        fi
    else
        echo "$username doesn't exist."
    fi
}

add_user_to_group() {
    echo "Enter the username to add to a group:"
    read username
    echo "Enter the group name:"
    read group

    if id "$username" &>/dev/null && getent group "$group" &>/dev/null; then
        usermod -aG "$group" "$username"
        if [[ $? -eq 0 ]]; then
            echo "User $username successfully added to group $group"
        else
            echo "Failed to add user $username to group $group"
        fi
    else
        echo "User $username or group $group does not exist."
    fi
}

remove_user_from_group() {
    echo "Enter the username to remove from a group:"
    read username
    echo "Enter the group name:"
    read group

    if id "$username" &>/dev/null && getent group "$group" &>/dev/null; then
        gpasswd -d "$username" "$group"
        if [[ $? -eq 0 ]]; then
            echo "User $username removed from group $group successfully."
        else
            echo "Failed to remove user $username from group $group."
        fi
    else
        echo "User $username or group $group does not exist."
    fi
}

change_password() {
    echo "Enter the username you want to change password:"
    read username

    if id "$username" &>/dev/null; then
        echo "Enter the new password for user $username:"
        read -s new_password
        echo

        echo "$username:$new_password" | chpasswd

        if [[ $? -eq 0 ]]; then
            echo "Password changed successfully"
        else
            echo "Failed to change the password"
        fi
    else
        echo "User $username doesn't exist"
    fi
}

# ================== Main Menu ==================

echo "User Management System"

while true; do
    echo "===================================="
    echo "User Management Script"
    echo "===================================="
    echo "1. Create User"
    echo "2. Delete User"
    echo "3. Modify User"
    echo "4. Add User to Group"
    echo "5. Remove User from Group"
    echo "6. Change User Password"
    echo "7. Exit"
    echo "===================================="
    echo -n "Select an option (1-7): "
    read option

    case $option in
        1) create_user ;;
        2) delete_user ;;
        3) modify_user ;;
        4) add_user_to_group ;;
        5) remove_user_from_group ;;
        6) change_password ;;
        7) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done
