# Sample 3tier app

This Terraform modules will create the infrastructure necessary in GCP.

TODO: Replace hard coded values to variables and organize folders to allow multi environments builds.


* Know Issues:
    - Script will fail after network and before DB provisioning. Root cause is unclear, but re running the script again will complete the task succesfully.
    - Issue provisioning user for Postgres. Works fine for MySQL. Bug?
        ```
Error: Provider produced inconsistent result after apply
│ 
│ When applying changes to module.database.google_sql_user.users, provider "provider[\"registry.terraform.io/hashicorp/google\"]" produced an unexpected new value: Root resource
│ was present, but now absent.
│ 
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
```




```
Error: Error, failed to create instance because the network doesn't have at least 1 private services connection. Please see https://cloud.google.com/sql/docs/mysql/private-ip#network_requirements for how to create this connection.
│ 
│   with module.database.google_sql_database_instance.postgres,
│   on modules/db/sql-instance.tf line 1, in resource "google_sql_database_instance" "postgres":
│    1: resource "google_sql_database_instance" "postgres" {
│ 
╵
```