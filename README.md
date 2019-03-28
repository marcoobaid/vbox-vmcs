## VirtualBox Virtual Machine Creation Scripts (VBox-VMCS)

The intent of these scripts is to expedite the creation of virtual machines by leveraging the commandline functionality of VirtualBox. While the scripts were tested only on Linux, it is possible that they will work on Mac and Windows with slight modification.

For an average user, creating a virtual machine using VirtualBox graphical interface requires a series of steps, including defining the VM specs and attaching the boot media. This process may be too slow for heavy VirtualBox users who have the need to create VMs frequently, or large number of VMs (i.e. Beta-testers).It may also be desired to script the VM creation.

This page provides three scripts that should help accomplish the stated objective. The scenarios that these scripts cover are as follows:
1. Single VM creation
  * Create VM and start the VM - *(10-create-single-autostart-vm-vbox)*
  * Create VM only *(do not start VM)* - *(10-create-single-noautostart-vm-vbox)*
2.  Multiple VMs Creation - *(20-create-multiple-vm-vbox)* the script will target a folder that has all the iso media files.

The scripts default to ArchLinux 64-bit as the desired guest operating system. The "ostype" parameter can be tweaked to your liking. To change this parameter, find your desired value by running this command:

```
# VBoxManage list ostypes
```
*For a comprehensive details on the commandline interface of VirtualBox, refer to [VirtualBox Manual](https://www.virtualbox.org/manual/ch08.html#vboxmanage-createvm).*

___

## Single VM Creation
The script will ask the user for a name for the virtual machine. It will then create the virtual machine based on the pre-defined machine specs specified within the script. The default specs are:
- 2 CPUs
- 4GB RAM
- 128MB video memory
- vboxvga display driver.

## Multiple VMs Creation

This script will look into a designated folder that contains all the installation (*.iso) media. It will then use this list to generate the names of the virtual machines to be created. The naming convention will be the iso file name without the extention (.iso). Before running the script:

- Designate a folder for your ISOs; for example, ~/Downloads/ISOs/
- Download all your ISOs to this folder.
- Run "*20-create-multiple-vm-vbox*" script
- For each iso you have in your ISOs folder, the script will create a matching VM with the pre-defined VM specs in the script. You can modify these specs to your likings.
The default specs are:
   - 2 CPUs
   - 4GB RAM
   - 128MB video memory
   - vboxvga display driver.

- The script will also auto-mount the respective iso.
- Now you can start the VMs manually.
- If you want to auto-start the VMs after creation, there is a line towards the end of the script that you need
to uncomment. However, I don't suggest doing that because you could accidently overload your host machine.
 You can create as many VMs (based on the number of ISOs in your folder) in seconds.
