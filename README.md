# TSWoW-Auto-Installer

**TSWoW-Auto-Installer** is tool that helps you set up **TSWoW 3.3.5a** servers on **Debian 12**. With this installer, you can quickly configure your server environment so you can focus on your custom creations.

## Feature Highlights

- **Install Requirements**: Quickly installs all necessary software to run TrinityCore on Linux.
- **Source Code Management**: Downloads the TSWoW source code and sets up both the Auth server and World server.
- **Client Data Generation**: Downloads the 3.3.5a Client and Extract DBC/Maps/VMaps/MMAPs automatically.
- **MySQL Setup**: Automatically installs and configures MySQL, including random password generation and enabling remote access.
- **Database Configuration**: Creates the required MySQL databases and user accounts.
- **Safety Measures**: Configures a firewall and installs **Fail2Ban** for enhanced security against bruteforce.

## Installation

To install **TSWoW-Auto-Installer**, run the following commands as the root user:

```bash
cd / && rm -rf TSWoW-Auto-Installer && apt-get install git sudo -y && git clone https://github.com/CableguyWoW/TSWoW-Auto-Installer/ TSWoW-Auto-Installer && cd TSWoW-Auto-Installer && chmod +x Init.sh && ./Init.sh all
```

## Script Functions

### Root Functions
The following tasks are handled by the Root user:

- **Install Prerequisites**: Install all necessary libraries and dependencies.
- **Update Script Permissions**: Ensure the script has the correct permissions to execute.
- **Install MySQL APT**: Install the MySQL APT repository to manage MySQL installations.
- **Randomize Passwords**: Generate secure, random passwords for MySQL users and services.
- **Setup Commands**: Prepare and configure system commands needed for the setup.
- **Install TrinityCore Requirements**: Install all requirements necessary to run TrinityCore.
- **Install and Setup MySQL**: Complete installation and configuration of MySQL server.
- **Create Remote MySQL User**: Set up a MySQL user that can connect remotely.
- **Setup Firewall**: Configure firewall settings to secure the server.
- **Setup Linux Users**: Create necessary Linux users for server operations.
- **Install Fail2Ban**: Install Fail2Ban to enhance security by blocking suspicious activity.
- **Show Command List**: Display the available commands or functionalities of the script.

### Realm Server Functions
The following tasks are related to the Realm server setup:

- **Setup MySQL Database & Users**: Create databases and user accounts for the Realm server.
- **Pull and Setup Source**: Download and configure the source code for the World server.
- **Setup Worldserver Config**: Configure the settings for the World server.
- **Pull and Setup Database**: Download and configure the database for the World server.
- **Download 3.3.5a Client**: Fetch the necessary client files for version 3.3.5a.
- **Setup Client Tools**: Prepare tools necessary for managing the client.
- **Run Map/DBC Extractor**: Extract Map and DBC files for use in the game world.
- **Run VMap Extractor**: Extract VMap files for navigation and environment mapping.
- **Run Mmaps Extractor**: Extract MMap files for advanced pathfinding.


