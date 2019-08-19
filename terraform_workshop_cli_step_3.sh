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

Output
INFO: Using status information file: /tmp/beeond.tmp
INFO: Checking reachability of host 192.168.19.8
INFO: Checking reachability of host 192.168.19.5
INFO: Checking reachability of host 192.168.19.10
INFO: Number of storage servers automatically set to 3
INFO: Starting beegfs-mgmtd processes
INFO: Management daemon log: /var/log/beegfs-mgmtd_20190819-131437.log
INFO: Starting beegfs-mgmtd on host: 192.168.19.8

INFO: Starting beegfs-storage processes
INFO: Storage server log: /var/log/beegfs-storage_20190819-131437.log
INFO: Starting beegfs-storage on host: 192.168.19.8
INFO: Starting beegfs-storage on host: 192.168.19.5
INFO: Starting beegfs-storage on host: 192.168.19.10

INFO: Starting beegfs-meta processes
INFO: Metadata server log: /var/log/beegfs-meta_20190819-131437.log
INFO: Starting beegfs-meta on host: 192.168.19.8

INFO: Starting beegfs-client processes
INFO: Client log: /var/log/beegfs-client_20190819-131437.log
INFO: Starting beegfs-client on host: 192.168.19.8
INFO: Starting beegfs-client on host: 192.168.19.5
INFO: Starting beegfs-client on host: 192.168.19.10


#Create file in shared filesystem and check on other node
echo "Hello World" > /beeond/hello_world.txt

#Delete Hello World file
rm -f /beeond/hello_world.txt


### Create Batch system (TORQUE) ###

# Print out hostnames
echo $HOSTNAME OR hostname

#Edit host file
vim /etc/hosts

#master_IP master_hostname
#compute_0_IP compute_0_hostname
#compute_1_IP compite_1_hostname

#Distribute to both compute nodes (so do this 2 times)
scp -i workshop_key /etc/hosts centos@compute_IP:/etc/hosts

#Set hostname of master node for TORQUE, do this for all nodes (so do this 3 times)
sudo su -
echo "mhanussek-workshop-vm-master.novalocal" > /var/spool/torque/server_name

#Enable and start pbs_server systemd service
sudo systemctl enable pbs_server
sudo systemctl start pbs_server

#Enable and start trqauthd systemd service
sudo systemctl enable trqauthd
sudo systemctl start trqauthd

#Start pbs_sched
sudo env "PATH=$PATH" pbs_sched

#Set compute nodes for TORQUE (so do this 2 times)
sudo env "PATH=$PATH" qmgr -c "create node compute_host_name"


#Start client components on both compute nodes
ssh -n -o StrictHostKeyChecking=no -i workshop_key centos@host_ip sudo systemctl enable pbs_mom
ssh -n -o StrictHostKeyChecking=no -i workshop_key centos@host_ip sudo systemctl start pbs_mom

sudo env "PATH=$PATH" qmgr -c "set server auto_node_np = True"
















