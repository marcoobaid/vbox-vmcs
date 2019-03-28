#!/bin/bash
set -e
##################################################################################################################
# Author: 	Marco Obaid
# GitHub:   https://github.com/abumasood
##################################################################################################################
#
#   Script to Batch-Create Multiple VirtualBox VMs
#  
##################################################################################################################
# This script will create a BATCH of "Arch Linux 64-bit" virtualbox machines. The script will check a designated
# "ISOs" folder that contains the installation ISOs, and will then generate a list of VMs to be created. 
# The name of each VM will match the name of its respective ISO, minus the .iso extention. 
# Each VM will be created as follows:
# 		- Location of VM is the default $HOME/VirtualBox VMs/ 
#		- Main Specs of the VM are as follows (parameters can be adjusted to your liking):
#					- 2 CPUs, 4GB RAM, 20GB Hard Drive
#					- vboxvga display controller with 128MB video memory
# 		- After the virtual machine is created, its respective iso will be attached and ready to boot.
##################################################################################################################

myisofolder="$HOME/Downloads/ISOs"				# Folder containing installation ISOs

# Check if ISO folder is empty
if [ "$(ls -A $myisofolder/*.iso 2>/dev/null)" ]; then
	echo "Found ISOs in $myisofolder"

	# Generate a List of VM Names to be Created
	ls $myisofolder/*.iso | xargs -n1 basename | sed 's/.iso//g' > /tmp/input.txt  # Generate a list of VM names

	# Read Input File and Assig a VM Name
	cat /tmp/input.txt | while read myvmname; do

	# Set basic VM specs. Adjust to your preference
	myvmhome="$HOME/VirtualBox VMs/$myvmname"		# Filesystem path where the VM is created
	myisopath="$myisofolder/$myvmname.iso"			# Path of the installation iso

	today=$(date)									# Today's date used to time-stamp VM creation
	cpu_num=2       								# Number of CPUs
	ram_size=4096   								# RAM size in MB
	hd_size=20480   								# Hard drive size in MB
	hd_variant="Standard"							# Choose either Standard (Dynamic) or Fixed
	vram_size=128   								# VRAM size in MB
	os_type="ArchLinux_64" 							# Arch Linux 64-bit
	graphics_ctl="vboxvga"							# Options: vboxvga, vboxsvga, or vmsvga. 

	# Create and register VM
	VBoxManage createvm --name $myvmname --ostype $os_type --register

	# Add Description
	VBoxManage modifyvm $myvmname --description "$myvmname created on $today"

	# Set RTC to UTC
	VBoxManage modifyvm $myvmname --rtcuseutc on

	# Set Bio Menu
	VBoxManage modifyvm $myvmname --biosbootmenu messageandmenu

	# Set Boot Order to DVD -> Disk
	VBoxManage modifyvm $myvmname --boot1 dvd --boot2 disk --boot3 none --boot4 none

	# Assign CPUs, Memory, Display, and Video Memory
	VBoxManage modifyvm $myvmname --graphicscontroller $graphics_ctl
	VBoxManage modifyvm $myvmname --cpus $cpu_num --memory $ram_size --vram $vram_size 
	VBoxManage modifyvm $myvmname --pae on
	VBoxManage modifyvm $myvmname --accelerate3d on

	# Assign Pointing Device
	VBoxManage modifyvm $myvmname --mouse usbtablet

	# Enable Audio
	VBoxManage modifyvm $myvmname --audiocodec ad1980
	VBoxManage modifyvm $myvmname --audioout on 

	# Enable Clipboard/Drag'n'Drop 
	VBoxManage modifyvm $myvmname --clipboard bidirectional
	VBoxManage modifyvm $myvmname --draganddrop bidirectional
 
	# Create CD/DVD IDE Controller
	VBoxManage storagectl $myvmname --name "IDE Controller" --add ide

	# Attach IDE Controller to CD/DVD Drive
	VBoxManage storageattach $myvmname --storagectl "IDE Controller" --port 1  --device 0 --type dvddrive --medium $myisopath

	# Create Disk File with Dynamic Allocation (Standard vs. Fixed). Standard means "Dynamic"
	VBoxManage createhd --filename "$myvmhome/$myvmname.vdi" --size $hd_size --variant $hd_variant 

	# Create Storage Controller for Disk and Make Bootable
	VBoxManage storagectl $myvmname --name "SATA Controller" --add sata --bootable on

	# Attach Disk to Controller
	VBoxManage storageattach $myvmname --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$myvmhome/$myvmname.vdi"

	# Turn on USB 2.0 Controller
	VBoxManage modifyvm $myvmname --usbehci on

	# Start VM (if needed) 
	#VBoxManage startvm $myvmname

	done

	# Clean up 
	rm -f /tmp/input.txt

	echo "#####################################################################################"
	echo "		All VMs have been successfully created"
	echo "#####################################################################################"

else
	echo "####################################################################################"
	echo "$myisofolder is Empty"
	echo "Place installation ISOs in this folder an re-run this script"
	echo "####################################################################################"
fi