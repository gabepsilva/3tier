# Sample 3tier app
This repo contains code for a Node.js multi-tier application.

The application overview is as follows

```
web <=> api <=> db
```

The folders `web` and `api` respectively describe how to install and run each app.


TODO: *recommended

    - Split frontend and backend in different repositories
    - Create a third repository for IAC and files not related to app development 


# Development environment 

## Requirements

 - Modern version of NodeJS
 - Git
 - Google Cloud SDK
 - Terraform
 - Docker

## Access

 - Google CLoud 
    - Cloud SQL
    - Cloud Run
    - Cloud Storage
 
 - GitHub (for container registry)
    - Org access
    

RECOMMENDATION: Create Docker Composer file

# Running web app on Docker 
```shell
#checkout this project 
cd Gabriel-da-Silva/web
docker build -t web .
docker run\
    --name web \
    --rm\
    -d\
    -e PORT=8081\
    -e API_HOST="http://172.17.0.3:8182"\
    -p 8081:8081\
    web
```

# Running api app on Docker 
```shell
#checkout this project 
cd Gabriel-da-Silva/api
docker build -t api .
docker run \
    --name api\
    --rm\
    -d\
    -e PORT=8182\
    -e DB=postgres\
    -e DBUSER=postgres\
    -e DBPASS=postgres\
    -e DBHOST=my.db.com\
    -e DBPORT=5432\
    -e env=development\
    -p 8182:8182\
    api
```

# Running a database on Docker

```shell 
 docker run\
    -d\
    --rm\
    --name postgres\
    -e POSTGRES_PASSWORD=root\
    -e POSTGRES_USER=root\
    -p 5432:5432\
    postgres
```


# Debug tips

    - Most processes used to create this project 



    - useful commands
    ```shell
    # watch app logs 
    kubectl logs -l app=web  --all-containers -f

    # jump inside a running container
    kubectl exec -it <POD> --container <container> -- ash

    # test DB connectivity
    apk add postgress
    psql -h <dbhostname> -p 5432 -d postgres -U postgres
    ```