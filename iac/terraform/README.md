# Sample 3tier app

This Terraform modules will create the infrastructure necessary in GCP.

TODO: Replace hard coded values to variables and organize folders to allow multi environments builds.


# Module Description

## Compute
Provision one preemptable virtual machine to be used as proxy to access the internal network. There are Ansible scripts to automate the servers configurations; those scripts must be copied to the server and run agains localhost.

TODO: Use startup scripts feature of Virtual machines to prepare remote access to virtual machines on creation.

## Database
Provisions one CloudSQL instance and limits its access to the listed IP addresses. The server specs also are also configurable. 
There will be one user created and its password must be set manualy. This password also must be set in the Kuberneted cluster. There is a helper script for that. `iac/k8s-config/bin/api-config`


## K8s
Provision a Kubernetes cluster in the same network and region as the Database and the proxy VPS. For cost effectiviness the cluster is composed by preemptable virtual machines.


## Network
This module is designed for a future state. It will create a private network with a NAT to route egress traffic. Possible load balancers with external ip adresses are planed.


## Stati IP
This module will reserve three static IPs to be allocated 
    - one in the proxy server
    - two for the K8s cluster, being 
        - one fir the frontend apps
        - one the the backend apps

## Main
This script gules everthing together.