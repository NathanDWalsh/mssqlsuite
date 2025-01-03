if ! [[ "18.04 20.04 22.04 23.04 24.04" == *"$(lsb_release -rs)"* ]];
then
    echo "Ubuntu $(lsb_release -rs) is not currently supported.";
    exit;
fi

# Add the signature to trust the Microsoft repo
# For Ubuntu versions < 24.04
if [[ "18.04 20.04 22.04 23.04" == *"$(lsb_release -rs)"* ]];
then
    curl https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc
fi
# For Ubuntu versions >= 24.04

if [[ "24.04" == *"$(lsb_release -rs)"* ]];
then
    curl https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg
fi

# Add repo to apt sources
curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list

# Install the driver
sudo apt-get update
sudo apt-get remove -y msodbcsql

# Below error when trying to install msodbcsql17
# E: Unable to locate package msodbcsql17
# sudo ACCEPT_EULA=Y apt-get install -y msodbcsql17
sudo ACCEPT_EULA=Y apt-get install -y msodbcsql18 mssql-tools18
