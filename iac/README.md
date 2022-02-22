    # Sample 3tier app


Instructions for provisioning and deployment the all environemnt.


# GCLOUD SDK
    - install

# GCP
    - Create project
        -link to docs
    - Link biling account
        - Link to docs
    - Enable APIS
        - list gcloud commmands
        - 1
        - 2 <<<<<<<<<<<<<>>>>>>>>>>>>>
        - 3

# Terraform
    - Provision a managed Postgress databse form Cloud SQL, GKE and a GCE
        Be Aware of know issues. Link to the other README <<<<<<<<<>>>>>>>>>

# Ansible

    Login to google 
    - copy sseh key to the server
    - execute ansible to setup the ha proxy server

# DNS Setup 
    make sure your DNS records are pointing to the static IP reserved by the TF scripts

# Initialize your local kubectl
    `./iac/k8s-config/bin/fetch.kube-config`


# Coping Secrets to GKE Cluster

    RECOMMENDATION: Host the steps below in a Jenkins (or similar) job and protect it against non sysadmins
    Besides security, Jenkins will keep a record of who and when these tasks were executed.

    - Container Registry
        Execute the script `./iac/k8s-config/bin/cr-config` and follow the instructions

    - Database password for 3 Tier APP
        If you want to create or update this password. Run the script `iac/k8s-config/bin/api-config`
            and follow the instructions. It will ensure a descent password.
        
    
# Deploying the # Tier App

    RECOMMENDATION: Organize GKE cluster(s) and namespaces to support DEV, UAT and PROD environments 
    accros multiple teams.

    ```bash
    # Deploying FE
    kubectl apply -f web/k8s/develop/deployment.yaml
    # Deploying BE
    kubectl apply -f api/k8s/develop/deployment.yaml
    ```