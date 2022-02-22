# Sample 3tier app


Instructions to provision the all environemnt.

# GCP setup 


* [Create a project](https://cloud.google.com/resource-manager/docs/creating-managing-projects) (top3tier-1)
* Login innto GCP console and [link the new project with a biling account](https://cloud.google.com/billing/docs/how-to/manage-billing-account).
* [Create a service account](https://cloud.google.com/iam/docs/service-accounts) to manage the resources. (top3tier@top3tier-1.iam.gserviceaccount.com)
* [In the IAM page](https://console.cloud.google.com/iam-admin/iam) Assing this SA the role of *editor*: roles/editor
* [Generate and download a json key](https://cloud.google.com/iam/docs/creating-managing-service-account-keys#iam-service-account-keys-create-console) for that service account (top3tier-1-8a979d4c79d6.json)


# GCloud SDK
* [Install and setup](https://cloud.google.com/sdk/docs/install) your development environment
* [Login on your local computer impersonating that service account](https://cloud.google.com/container-registry/docs/advanced-authentication#gcloud-helper)

`gcloud auth activate-service-account  top3tier@top3tier-1.iam.gserviceaccount.com  --key-file=<absolute/path/to/top3tier-1-8a979d4c79d6.json`
* Set the project you will work on

`gcloud config set project top3tier-1`

# Backend for Terraform state files 

* Create a bucket to store the state files

`gsutil mb -b on -l us-central1 gs://3tier-tfstate/`
    
        -link to docs
    - Link biling account
        - Link to docs
    - Enable APIS
        - list gcloud commmands
        - 1
        - 2 <<<<<<<<<<<<<>>>>>>>>>>>>>
        - 3



# GCLOUD SDK
    - install


# Terraform
    - Provision a managed Postgress databse form Cloud SQL and an instance of GKE
        Be Aware of know issues. Link to the other README <<<<<<<<<>>>>>>>>>

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