#!/usr/bin/env bash
#
# deployAzureDShieldSensor.bash
# Using inputs provided, generate a custom .json template for a new Azure Resource Group
# and then deploy an Ubuntu 22.04 LTS minimal server installation into the new Resource Group.
# Finally, output the new Public IP address of the Virtual Server created in the Resource Group.
#.
source ../bin/VARS
/usr/bin/clear

templateFile=dshieldCollector.template

function yes_or_no {
    while true; do
	echo "Shall we continue?"
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;
            [Nn]*) echo "Aborted" ; exit  1 ;;
        esac
    done
}
echo !!!PLEASE READ ALL OF ME!!!
echo
echo "deployDShieldCollector.bash"
echo "Usage: $0 [customName] [customLocation] [privateIPAddress]"
echo
echo "You are executing $0 to create Resource Group ** $1 ** in location ** $2 ** with private IP address ** $3 **."
echo
echo "Please use command \"az account list-locations -o table\""
echo "if you need a list of available locations before proceeding."
echo
yes_or_no

/usr/bin/clear
echo
echo
echo
echo "Cool! Here we go."
echo "Copying template to new .json file..."
cp $templateFile $1.json
# Replace testDeployment in $1.json with name of Resource Group and Sensor
sed -i -e "s|testDeployment|$1|g" $1.json
# Replace eastus in $1.json with $2 matching Resource Group and Sensor
sed -i -e "s|eastus|$2|g" $1.json
# Replace the public key data in the template with our DShield key
sed -i -e "s/"keyData"^/$(sed 's:/:\\/:g' dshield-key.pub)/" $1.json
# Replace 10.0.0.4 privateIPAddress in template with user-provided IP via $3
sed -i -e "s|10.0.0.4|$3|g" $1.json

echo

echo "$1.json created ..."
echo
echo "Now deploying into Microsoft Azure Resource Group: $1 in Location $2 ..."
echo
# delete resource group and resources
echo "Deleting Resource Group $1 if present in Location $2"
echo "... (will throw error and continue if nonexistant in $2.)"
echo
az group delete --name $1 -y

# create the resource group
echo "Creating Resource Group"
az group create --name $1 --location $2

# create a group deployment into the resource group using custom .json template
echo "Creating deployment group for $1 resource group and launching..."
az deployment group create --resource-group $1 --template-file $1.json
publicIPAddress=$(az vm show -d -g $1 -n $1 --query publicIps -o tsv)

echo "Adding client (what ipinfo.io/ip tells me is YOUR) IP address to inbound Admin SSH allow rule."
clientIPAddress=$(wget -qO- ipinfo.io/ip)
az network nsg rule update --name SSH --nsg-name $1-nsg --resource-group $1 --source-address-prefixes $clientIPAddress/32

echo "To avoid \"System is booting up. Unprivileged users are not permitted to log in yet.\" errors"
echo "We will sleep for 15 seconds."

echo -ne '                          (00%)\r'
sleep 3
echo -ne '####                      (12%)\r'
sleep 3
echo -ne '#######                   (24%)\r'
sleep 3
echo -ne '#############             (50%)\r'
sleep 3
echo -ne '################          (74%)\r'
sleep 3
echo -ne '#####################     (86%)\r'
sleep 3
echo -ne '######################### (100%)\r'
echo -ne '\n'

#echo "Now updating Ubuntu and installing necessary packages..."
/usr/bin/ssh -o StrictHostKeyChecking=accept-new -i $sshKey $user@$publicIPAddress 'sudo apt install git unzip python3-pip nano tcpdump cron -y'
/usr/bin/ssh -o StrictHostKeyChecking=accept-new -i $sshKey $user@$publicIPAddress 'sudo apt update && sudo apt full-upgrade -y'

#mkdir $dshieldDirectory/logs/$1
#mkdir $dshieldDirectory/packets/$1
#mkdir $dshieldDirectory/archive/logs/$1
#mkdir $dshieldDirectory/archive/packets/$1

echo
echo "Don't forget to update your dns or /etc/hosts record!"
echo "Your new sensor's public IP address is:"
echo $publicIPAddress
echo
