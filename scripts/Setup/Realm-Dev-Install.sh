#!/bin/bash

### TRINITYCORE INSTALL SCRIPT
### TESTED WITH UBUNTU ONLY

. /TSWoW-Auto-Installer/configs/root-config
. /TSWoW-Auto-Installer/configs/repo-config
. /TSWoW-Auto-Installer/configs/auth-config
. /TSWoW-Auto-Installer/configs/realm-dev-config

if [ $USER != "$SETUP_REALM_USER" ]; then

echo "You must run this script under the $SETUP_REALM_USER user!"

else

## LETS START
echo ""
echo "##########################################################"
echo "## DEV REALM INSTALL SCRIPT (TSWOW) STARTING...."
echo "##########################################################"
echo ""
NUM=0
export DEBIAN_FRONTEND=noninteractive

if [ "$1" = "" ]; then
echo ""
echo "## No option selected, see list below"
echo ""
echo "- [all] : Run Full Script"
echo ""
echo ""
((NUM++)); echo "- [$NUM] : Download 3.3.5a Client"
((NUM++)); echo "- [$NUM] : Setup MySQL Database & Users"
((NUM++)); echo "- [$NUM] : Setup TSWoW"
((NUM++)); echo "- [$NUM] : Setup TSWoW Configs"
echo ""

else


((NUM++))
if [ "$1" = "all" ] || [ "$1" = "$NUM" ]; then
echo ""
echo "##########################################################"
echo "## $NUM.Download 3.3.5a Client"
echo "##########################################################"
echo ""
URL="https://btground.tk/chmi/ChromieCraft_3.3.5a.zip"
FILENAME="${URL##*/}"
cd /home/
if [ -f "$FILENAME" ]; then
    while true; do
        read -p "$FILENAME already exists. Redownload? (y/n): " file_choice
        if [[ "$file_choice" =~ ^[Yy]$ ]]; then
            rm "$FILENAME" && sudo wget $URL && break
        elif [[ "$file_choice" =~ ^[Nn]$ ]]; then
            echo "Skipping download." && break
        else
            echo "Please answer y (yes) or n (no)."
        fi
    done
else
	sudo wget $URL
fi
if [ -d "/home/WoW335" ]; then
    while true; do
        read -p "WoW335 Folder already exists. Reextract? (y/n): " folder_choice
        if [[ "$folder_choice" =~ ^[Yy]$ ]]; then
            sudo unzip "$FILENAME" && break
        elif [[ "$folder_choice" =~ ^[Nn]$ ]]; then
            echo "Skipping extraction." && break
        else
            echo "Please answer y (yes) or n (no)."
        fi
    done
else
	sudo unzip "$FILENAME"
fi
if [ -d "/home/ChromieCraft_3.3.5a" ]; then
	sudo mv -f /home/ChromieCraft_3.3.5a /home/WoW335
fi
if [ -d "/home/WoW335" ]; then
	sudo chmod -R 777 /home/WoW335
fi
if [ -f "/home/$FILENAME" ]; then
    while true; do
        read -p "Would you like to delete the 3.3.5a client zip folder to save folder space? (y/n): " folder_choice
        if [[ "$folder_choice" =~ ^[Yy]$ ]]; then
            sudo rm $FILENAME && break
        elif [[ "$folder_choice" =~ ^[Nn]$ ]]; then
            echo "Skipping deletion." && break
        else
            echo "Please answer y (yes) or n (no)."
        fi
    done
fi
fi

((NUM++))
if [ "$1" = "all" ] || [ "$1" = "$NUM" ]; then
echo ""
echo "##########################################################"
echo "## $NUM.Setup MySQL Database & Users"
echo "##########################################################"
echo ""

# World Database Setup
echo "Checking if the database '${REALM_DB_USER}_world' exists..."
if ! mysql -u "$ROOT_USER" -p"$ROOT_PASS" -e "SHOW DATABASES LIKE '${REALM_DB_USER}_world';" | grep -q "${REALM_DB_USER}_world"; then
    mysql -u "$ROOT_USER" -p"$ROOT_PASS" -e "CREATE DATABASE ${REALM_DB_USER}_world DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
    if [[ $? -eq 0 ]]; then
        echo "Database '${REALM_DB_USER}_world' created."
    else
        echo "Failed to create database '${REALM_DB_USER}_world'."
        exit 1
    fi
else
    echo "Database '${REALM_DB_USER}_world' already exists."
fi

echo "Checking if the database '${REALM_DB_USER}_character' exists..."
if ! mysql -u "$ROOT_USER" -p"$ROOT_PASS" -e "SHOW DATABASES LIKE '${REALM_DB_USER}_character';" | grep -q "${REALM_DB_USER}_character"; then
    mysql -u "$ROOT_USER" -p"$ROOT_PASS" -e "CREATE DATABASE ${REALM_DB_USER}_character DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
    if [[ $? -eq 0 ]]; then
        echo "Database '${REALM_DB_USER}_character' created."
    else
        echo "Failed to create database '${REALM_DB_USER}_character'."
        exit 1
    fi
else
    echo "Database '${REALM_DB_USER}_character' already exists."
fi

# Create the realm user if it does not already exist
echo "Checking if the realm user '${REALM_DB_USER}' exists..."
if ! mysql -u "$ROOT_USER" -p"$ROOT_PASS" -e "SELECT User FROM mysql.user WHERE User = '${REALM_DB_USER}' AND Host = 'localhost';" | grep -q "${REALM_DB_USER}"; then
    mysql -u "$ROOT_USER" -p"$ROOT_PASS" -e "CREATE USER '${REALM_DB_USER}'@'localhost' IDENTIFIED BY '$REALM_DB_PASS';"
    if [[ $? -eq 0 ]]; then
        echo "Realm DB user '${REALM_DB_USER}' created."
    else
        echo "Failed to create realm DB user '${REALM_DB_USER}'."
        exit 1
    fi
else
    echo "Realm DB user '${REALM_DB_USER}' already exists."
fi

# Grant privileges
echo "Granting privileges on '${REALM_DB_USER}_world' to '${REALM_DB_USER}'..."
if mysql -u "$ROOT_USER" -p"$ROOT_PASS" -e "GRANT ALL PRIVILEGES ON ${REALM_DB_USER}_world.* TO '${REALM_DB_USER}'@'localhost';"; then
    echo "Granted all privileges on '${REALM_DB_USER}_world' to '${REALM_DB_USER}'."
else
    echo "Failed to grant privileges on '${REALM_DB_USER}_world' to '${REALM_DB_USER}'."
    exit 1
fi

echo "Granting privileges on '${REALM_DB_USER}_character' to '${REALM_DB_USER}'..."
if mysql -u "$ROOT_USER" -p"$ROOT_PASS" -e "GRANT ALL PRIVILEGES ON ${REALM_DB_USER}_character.* TO '${REALM_DB_USER}'@'localhost';"; then
    echo "Granted all privileges on '${REALM_DB_USER}_character' to '${REALM_DB_USER}'."
else
    echo "Failed to grant privileges on '${REALM_DB_USER}_character' to '${REALM_DB_USER}'."
    exit 1
fi

# Flush privileges
mysql -u "$ROOT_USER" -p"$ROOT_PASS" -e "FLUSH PRIVILEGES;"
echo "Flushed privileges."
echo "Setup World DB Account completed."
fi


((NUM++))
if [ "$1" = "all" ] || [ "$1" = "update" ] || [ "$1" = "$NUM" ]; then
echo ""
echo "##########################################################"
echo "## $NUM.Pulling TSWoW Source"
echo "##########################################################"
echo ""
cd /home/$SETUP_REALM_USER/
mkdir /home/$SETUP_REALM_USER/tswow-build/
mkdir /home/$SETUP_REALM_USER/tswow-install/
## Source install
if [[ "$TS_REPO_URL" == *.zip ]]; then
    FILENAME="${TS_REPO_URL##*/}"           # Get the filename from the URL
    FILENAME_NO_ZIP="${FILENAME%.zip}"
    FOLDERNAME="tswow"
    #echo "FOLDERNAME="tswow""
    if [ -f "/home/$SETUP_REALM_USER/$FILENAME" ]; then
        while true; do
            read -p "$FOLDERNAME already exists. Redownload? (y/n): " file_choice
            if [[ "$file_choice" =~ ^[Yy]$ ]]; then
                rm -f "/home/$SETUP_REALM_USER/$FILENAME"
                rm -rf "/home/$SETUP_REALM_USER/$FOLDERNAME"
                sudo wget "$TS_REPO_URL"
                #echo "sudo wget -O "$TS_REPO_URL""
                break
            elif [[ "$file_choice" =~ ^[Nn]$ ]]; then
                echo "Skipping download." && break
            else
                echo "Please answer y (yes) or n (no)."
            fi
        done
    else
        sudo wget "$TS_REPO_URL"
    fi

    # Ensure the file exists before extracting
    if [ -f "/home/$SETUP_REALM_USER/$FILENAME" ]; then
        unzip -qd "/home/$SETUP_REALM_USER" "$FILENAME"
        mv "/home/$SETUP_REALM_USER/$FOLDERNAME-$FILENAME_NO_ZIP" /home/$SETUP_REALM_USER/$FOLDERNAME
    fi
else
    git clone "$TS_REPO_URL"
    mv "/home/$SETUP_REALM_USER/TSWoW" /home/$SETUP_REALM_USER/$FOLDERNAME
fi
fi


((NUM++))
if [ "$1" = "all" ] || [ "$1" = "$NUM" ]; then
echo ""
echo "##########################################################"
echo "## $NUM.Setup TSWoW"
echo "##########################################################"
echo ""
echo "Install NPM"
sudo apt remove clang clang-19 -y
sudo apt install nodejs npm clang-19 -y
sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-19 100
echo "Running NPM install"
cd /home/$SETUP_REALM_USER/tswow/
npm i
echo "Running NPM setup"
npm run build
echo "Building full setup"
build full
mv build.default.conf build.conf
fi


((NUM++))
if [ "$1" = "all" ] || [ "$1" = "$NUM" ]; then
echo ""
echo "##########################################################"
echo "## $NUM.Setup TSWoW Configs"
echo "##########################################################"
echo ""
cd /home/$SETUP_REALM_USER/tswow-install/
## Changing Config values
echo "Changing Node Config values"
## Misc Edits
sed -i 's/tswow;password/'${REALM_DB_USER}';'${REALM_DB_PASS}'/g' node.conf
fi


echo ""
echo "##########################################################"
echo "## DEV REALM INSTALLED AND FINISHED!"
echo "##########################################################"
echo ""


fi
fi
