#!/bin/bash
# /// U S E R  F U N C T I O N S ///

function create_user() {
  echo "Enter the username: "
  read username
  if [[ -z "$username" ]]; then
    echo "You must enter something."
  else
    if id "$username" >/dev/null 2>&1; then
      echo "The user $username already exists."
    else
      useradd "$username" >/dev/null 2>&1
      echo "The user $username has been created."
    fi
  fi
}

function delete_user() {
  echo "Enter the username to delete: "
  read username
  if id "$username" >/dev/null 2>&1; then
    userdel -f -r "$username" >/dev/null 2>&1
    echo "The user $username has been deleted."
  else
    echo "The user $username does not exist."
  fi
}

function change_password() {
  echo "Enter the username: "
  read username
  if id "$username" >/dev/null 2>&1; then
    echo "Enter the new password: "
    read -s new_password
    echo "$username:$new_password" | sudo chpasswd
    echo "Password successfully changed for the user $username."
  else
    echo "The user $username does not exist."
  fi
}

function list_users() {
  echo "Listing system users:"
  cut -d: -f1 /etc/passwd
}

# /// G R O U P  F U N C T I O N S ///

function create_group() {
  echo "Enter the group name: "
  read group_name
  if [[ -z "$group_name" ]]; then
    echo "You must enter something."
  else
    if grep -q "^$group_name:" /etc/group; then
      echo "The group $group_name already exists."
    else
      groupadd "$group_name"
      echo "The group $group_name has been created."
    fi
  fi
}

function delete_group() {
  echo "Enter the group name to delete: "
  read group_name
  if grep -q "^$group_name:" /etc/group; then
    groupdel -f "$group_name"
    echo "The group $group_name has been deleted."
  else
    echo "The group $group_name does not exist."
  fi
}

function add_user_to_group() {
  echo "Enter the username: "
  read username

  echo "Enter the group name: "
  read group_name
  if id "$username" >/dev/null 2>&1; then
    if grep -q "^$group_name:" /etc/group; then
      sudo usermod -a -G "$group_name" "$username"
      echo "The user $username has been added to the group $group_name."
    else
      echo "The group $group_name does not exist."
    fi
  else
    echo "The user $username does not exist."
  fi
}

function remove_user_from_group() {
  echo "Enter the group name: "
  read -r group_name
  if grep -q "$group_name:" /etc/group; then
    echo "Enter the username to remove from the group: "
    read -r username
    if grep -q "^$username:" /etc/group && grep -q "$group_name:" /etc/group; then
      sudo gpasswd -d "$username" "$group_name" >/dev/null 2>&1
      echo "The user $username has been removed from the group $group_name."
    else
      echo "The user $username does not belong to the group $group_name."
    fi
    else
    echo "The group $group_name does not exist."
    fi
    }

function show_users_in_group() {
        echo "Enter the group name: "
        read group_name
        if grep -q "^$group_name:" /etc/group; then
          echo "Users in the group $group_name:"
            members=$(grep "^$group_name:" /etc/group | cut -d: -f4)
          echo "$members"
        else
            echo "The group $group_name does not exist."
        fi
        }

function list_groups() {
        echo "Listing existing groups in the system:"
        cut -d: -f1 /etc/group
        }

# /// U S E R I N T E R F A C E ///
while true; do
clear
    echo " M A I N M E N U"
    echo ""
    echo "1. User Management"
    echo "2. Group Management"
    echo "3. Exit"
        
    echo ""
    read -p "Choose an option: " menu_option

    case $menu_option in
    1)
    while true; do
    clear
    echo " U S E R M E N U"
    echo ""
    echo "1. Create a user"
    echo "2. Delete a user"
    echo "3. Change user password"
    echo "4. List system users"
    echo "5. Back to main menu"
    echo ""
    read -p "Choose an option: " user_option
        case $user_option in
      1)
        create_user
        ;;
      2)
        delete_user
        ;;
      3)
        change_password
        ;;
      4)
        list_users
        ;;
      5)
        break
        ;;
      *)
        echo "Error 208, choose a valid option."
        ;;
    esac

    read -p "Press Enter to continue..."
  done
  ;;

2)
  while true; do
    clear
    echo "      G R O U P    M E N U"
    echo ""
    echo "1. Create a group"
    echo "2. Delete a group"
    echo "3. Add user to a group"
    echo "4. Remove user from a group"
    echo "5. Show users in a group"
    echo "6. List existing groups in the system"
    echo "7. Back to main menu"
    echo ""
    read -p "Choose an option: " group_option

    case $group_option in
      1)
        create_group
        ;;
      2)
        delete_group
        ;;
      3)
        add_user_to_group
        ;;
      4)
        remove_user_from_group
        ;;
      5)
        show_users_in_group
        ;;
      6)
        list_groups
        ;;
      7)
        break
        ;;
      *)
        echo "Error 208, choose a valid option."
        ;;
    esac

    read -p "Press Enter to continue..."
  done
  ;;

3)
  echo "Thank you for using this program, developed by alacranscorpion"
  echo ""
  echo "
 __   _
 | \  |
 |  \_|"
  echo ""
  echo ""
 
break
  ;;

*)
  echo "Error 208, choose a valid option."
  ;;
esac

read -n1 -p "Press Enter to continue..."
done
