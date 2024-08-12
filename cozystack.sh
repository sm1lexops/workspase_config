#!/bin/bash
DISK=$(lsblk -dn -o NAME,SIZE,TYPE -e 1,7,11,14,15 | sed -n 1p | awk '{print $1}')

echo "DISK=$DISK"

cd /tmp
wget https://github.com/aenix-io/cozystack/releases/latest/download/nocloud-amd64.raw.xz
xz -d -c /tmp/nocloud-amd64.raw.xz | dd of="/dev/$DISK" bs=4M oflag=sync

# resize gpt partition
sgdisk -e "/dev/$DISK"

# Create 20MB partition in the end of disk
end=$(sgdisk -E "/dev/$DISK")
sgdisk -n7:$(( $end - 40960 )):$end -t7:ef00 "/dev/$DISK"

# Create FAT filesystem for cloud-init and mount it
PARTITION=$(sfdisk -d "/dev/$DISK" | awk 'END{print $1}' | awk -F/ '{print $NF}')
mkfs.vfat -n CIDATA "/dev/$PARTITION"
mount  "/dev/$PARTITION" /mnt

INTERFACE_NAME=$(udevadm info -q property /sys/class/net/eth0 | grep "ID_NET_NAME_PATH=" | cut -d'=' -f2)
IP_CIDR=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}')
GATEWAY=$(ip route | grep default | awk '{print $3}')

echo "INTERFACE_NAME=$INTERFACE_NAME"
echo "IP_CIDR=$IP_CIDR"
echo "GATEWAY=$GATEWAY"

umount /mnt
sync
reboot
