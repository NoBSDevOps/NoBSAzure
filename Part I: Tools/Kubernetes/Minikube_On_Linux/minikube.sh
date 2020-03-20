# Pull Google repo down for Minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube

# Change permissions for standard user to have access to Minikube
sudo mkdir -p /usr/local/bin/

# Install Mnikube
sudo install minikube /usr/local/bin/