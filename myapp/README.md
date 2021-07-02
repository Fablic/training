# README

### Requirements:
* Docker

### To run app:
1. Install docker
2. go to `cd myapp`
3. execute `docker-compose up --build`
   
    it should create 3 containers as `api_1`, `db_1` and `chrome_1`
    if it runs successfully you should see something like 
    ```
    api_1     | => Booting Puma
    api_1     | => Rails 6.0.3.7 application starting in development
    api_1     | => Run `rails server --help` for more startup options
    api_1     | Puma starting in single mode...
    api_1     | * Version 4.3.8 (ruby 2.6.7-p197), codename: Mysterious Traveller
    api_1     | * Min threads: 5, max threads: 5
    api_1     | * Environment: development
    api_1     | * Listening on tcp://0.0.0.0:3000
    api_1     | Use Ctrl-C to stop
   ```
4. then access `localhost:3001`

### How to run the test suite 
* to run rspec (or any other rails related commands)
   1. inside docker container execute `rspec`
   2. directly `docker exec -it myapp_api_1 bundle exec rspec`
    

### Other errors
* there might some errors caused by yarn.lock, 
  i already added it to .gitignore but to be sure please check if it exists before docker-compose and it does please remove it
    
