# Sample 3tier app


Instructions to provision the all environemnt.\
**Before you read the page, check the Architecture diagram.**


## GCP setup 


* [Create a project](https://cloud.google.com/resource-manager/docs/creating-managing-projects) (top3tier-1)
* Login innto GCP console and [link the new project with a biling account](https://cloud.google.com/billing/docs/how-to/manage-billing-account).
* [Create a service account](https://cloud.google.com/iam/docs/service-accounts) to manage the resources. (top3tier@top3tier-1.iam.gserviceaccount.com)
* [In the IAM page](https://console.cloud.google.com/iam-admin/iam) Assing this SA the role of *editor*: roles/editor
* [Generate and download a json key](https://cloud.google.com/iam/docs/creating-managing-service-account-keys#iam-service-account-keys-create-console) for that service account (top3tier-1-8a979d4c79d6.json)


## GCloud SDK
* [Install and setup](https://cloud.google.com/sdk/docs/install) your development environment
* [Login on your local computer impersonating that service account](https://cloud.google.com/container-registry/docs/advanced-authentication#gcloud-helper)

```bash
gcloud auth activate-service-account  top3tier@top3tier-1.iam.gserviceaccount.com  --key-file=<absolute/path/to/top3tier-1-8a979d4c79d6.json
```

* **Set the project with gcloud or else you will keep getting 'unathorized errors'**

`gcloud config set project top3tier-1`

 * You will nedd to enable a few apis:

Checke the api name and description of all apis available:\
`gcloud services list --available`

```bash
gcloud services enable cloudresourcemanager.googleapis.com 
gcloud services enable cloudbilling.googleapis.com
gcloud services enable iam.googleapis.com  
gcloud services enable compute.googleapis.com 
gcloud services enable sqladmin.googleapis.com 
gcloud services enable container.googleapis.com
gcloud services enable networkmanagement.googleapis.com 
```

* Setup a few variables
[How to set envivariables for Terraform](https://www.terraform.io/language/values/variables#environment-variables)
```bash
export TF_VAR_gcp_project_id='top3tier-1'
export GOOGLE_APPLICATION_CREDENTIALS='/home/gabriel/top3tier.json'
```

## Backend for Terraform state files 
A safe way to store the state files and still make it easy to share is to store it in a GCP storage bucket.
* Create a bucket to store the state files

**Make sure your bucket name machets the Terraform script**\
https://github.com/gasilva-clgx/3tier/blob/6de68a670604f5b2034afddcec5da544d7a0bc00/iac/terraform/main.tf#L3

```bash
gsutil mb -b on -l us-central1 gs://3tier-tfstate/
```
    

## Start provisioning with Terraform
    
**Make sure your json key matches the location in the scripts**\
https://github.com/gasilva-clgx/3tier/blob/7963118504c83652b957f3ef1c48501c6eb56fe6/iac/terraform/main.tf#L4


```bash
cd iac/terraform
terraform init
terraform apply

```

This will provision a Kubernetes cluster, Clous SQL instance and a virtual machine which will be our proxy


### Initialize your local kubectl
For convinience, get kubectl on your local computer by executing:\
`gcloud container clusters get-credentials top3tier-cluster --region us-central1 --project top3tier-1`


## Coping Secrets to GKE Cluster

**RECOMMENDATION:**\
The scripts below will deal with secrets.\
You can host them in a Jenkins (or similar) job and protect it against non sysadmins. Jenkins will keep a record of who and when these tasks were executed.

<sub>*some adjusts might be required.</sub>


## Set up a container registry credential in your cluster
Execute the script `./iac/k8s-config/bin/cr-config` and follow the instructions.

Notice that the script will pause and ask you to do a `docker login <container-register.com/user>`.
If you haven't done it yet. Abort and do it before continuing.

It is setup Githubs CR in a secret configmap


## Database password for 3 Tier APP in the cluster
If you want to create or update this password. Run the script `iac/k8s-config/bin/api-config` and follow the instructions. It will ensure a descent password. and set as a config map in the cluster.


# Setting up the app domain, CDN, DNS, proxy and static IPs

**First we will setup the ap[plication with no proxy and database open to the internet. After we confirm that everyting works we are gong to setup this last piece.**

### Requirements:
* Get a free or paid domain from https://www.freenom.com  or https://www.namecheap.com (domain)
* Get a free or paid account on https://www.cloudflare.com (CDN and DNS management)
* Set up Claudflare asn the domain resolver of youe domain. [Documentation](/support/knowledgebase/article.aspx/9607/2210/how-to-set-up-dns-records-for-your-domain-in-cloudflare-account/)


## Setting up Static IPS.
[In GCP](https://console.cloud.google.com/networking/addresses/list), notice that the terraform scripts have reserved 2 statis IPs and did not attached them anywhere.
Get respective frontend (FE) and backend (BE) IPs and update the deployment.yaml of the applications.\
FE\
BE  <<<< GET PERMA LINKS >>>>

## Setting up DNS
Create records to the frontend, backend and database ips
example:

| IP              | DNS            |
|-----------------|----------------|
| 35.202.48.153   | 3tier.tk       | 
| 35.202.48.153   | fe-lb.3tier.tk |
| 35.188.20.148   | be-lb.3tier.tk |
| 34.122.250.242  | database.3tier.tk  |

**Make sure your backend deployment.yml is using the correct DNS for the database host**


## Deploying the 3 Tier App

**RECOMMENDATION:**\
Organize GKE cluster(s) and namespaces to support DEV, UAT and PROD environments accros multiple applications teams.


Run the First deployment in your CLuster:
```bash
# Deploying FE
kubectl apply -f web/k8s/develop/deployment.yaml
# Deploying BE
kubectl apply -f api/k8s/develop/deployment.yaml
```

## Congratulations
By now the app should be working ... but now lets set the proxy and CDN


### Throubleshooting

* ensure the database password is correct in the cluster configmap. This terraform script sets initial random password.

* Double check all IPs and DNS names. 
    * Load balancers
    * Cluster IP
    * Reserved static passwords
    * DNS names



## Lets now ste the Proxy up

- Enable ssh from your local to the proxy server by adding your public SSH key here 
https://console.cloud.google.com/compute/metadata?tab=sshkeys

- Now try logging in using the public IP

```bash
    ssh gabrielpe@34.136.168.55
```

## Ansible
- Copy and run Ansible on the proxy server to have it almost fully configured.

**Manually**
- Update accordly the IPs and or DNS names in `/etc/haproxy/haproxy.cfg`



**RECOMMENDATION**\
A LOT of the above can be automated.


## One last thing: Observability


Observability should be a straightforward step. For this project we are using New Relic for monitoring.

Installation:

    - Install the components in your jenkins cluster. Wait until the outputs starts appearing the the console

```bash
helm repo add newrelic https://helm-charts.newrelic.com && helm repo update && \
kubectl create namespace newrelic ; helm upgrade --install newrelic-bundle newrelic/nri-bundle \
 --set global.licenseKey=531262cd47dbbf18db48c925d2efae63a85fNRAL \
 --set global.cluster=c1 \
 --namespace=newrelic \
 --set newrelic-infrastructure.privileged=true \
 --set global.lowDataMode=true \
 --set ksm.enabled=true \
 --set kubeEvents.enabled=true 
```




## Observations

Wha happens when we access the system directly via IP?
- the client will loose the benefif of CDN, and error handling, since both are
done by the proxy and Cloudflare

- Databse will still be secure .. only requests from the proxy are accepted.