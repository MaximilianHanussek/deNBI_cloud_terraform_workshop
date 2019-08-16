# Login to jumphost, enter password
ssh -i /Path/to/key centos@193.196.20.75

#------------------------------------------------------------------------------

# Perform following two steps on all your machines (in the end 3 times) 
# Login to your cluster VMs (master, compute), enter password 
ssh -i .ssh/workshop_key centos@192.168.19.xxx

# Download private key
wget https://s3.denbi.uni-tuebingen.de/max/terraform_workshop/workshop_key

# Change permissions
chmod 600 workshop_key

# Make key passwordless
ssh-keygen -p -P PASSWORD -N "" -f workshop_key

# Check for volumes
lsblk

# Create filesystem on volumes
sudo mkfs.xfs /dev/vdb

# Mount Cinder volume
sudo mount /dev/vdb /mnt/

# Check if volume is mounted
df -h

# Change permissions
sudo chmod 777 /mnt

# Try to write a file to the volume
touch /mnt/test.txt

# Check if file is created
ll /mnt/

# Remove file
rm /mnt/test.txt

# Go back to jumphost
exit

#--------------------------------------------------------------------------------

# Login to master
ssh -i .ssh/workshop_key centos@192.168.19.xxx

# Edit beeond node file, make sure it is YOUR VM and your IP !!!
vim beeond_nodefile
#master_IP
#compute_0_IP
#compute_1_IP

# Create shared file system director
# Already done in the step of image creation

# Need to add some custom files 
sudo wget https://s3.denbi.uni-tuebingen.de/max/terraform_workshop/beeond -O /opt/beegfs/sbin/beeond
sudo chmod 777 /opt/beegfs/sbin/beeond
sudo wget https://s3.denbi.uni-tuebingen.de/max/terraform_workshop/beegfs-ondemand-stoplocal -O /opt/beegfs/lib/beegfs-ondemand-stoplocal
sudo chmod 777 /opt/beegfs/lib/beegfs-ondemand-stoplocal

# Start beeond
beeond start -n /home/centos/beeond_nodefile -d /mnt/ -c /beeond/ -a /home/centos/workshop_key -z centos

#Stop beeond
beeond stop -n /home/centos/beeond_nodefile -L -d -a /home/centos/workshop_key -z centos









