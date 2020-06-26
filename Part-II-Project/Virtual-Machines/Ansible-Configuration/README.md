# Ansible Configuration
To use Ansible for IIS configuration, you'll need to store the public SSH key that's generated on the Ansible host on the two destination VM.s

# Instructions
1. Within the Ansible server, run `ssh-keygen` to generate a new SSH key
2. Copy the public SSH key to the `~/.ssh` path on the two destination VMs