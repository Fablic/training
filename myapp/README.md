## Todos Application
It is a Task Management app that does following key features

## A USER
- can login/logout (not completed yet)
- can change task status (not completed yet)
- can see tasks assigned to him by admin (not completed yet)

## A USER (as Admin)
- can Create/Update/Delete/List USERS or ADMIN (not completed yet)
- can Create/Update/Delete/List Tasks
- can Set due date to task
- Set status to task
- Delete task
- add labels (not completed yet)
- Assign/Unassign user to task (not completed yet)

## For structural elaboration follow this link below
https://github.com/Fablic/training/tree/m-alamin/myapp/docs

### Requirements:
* Docker
* Browser

### To run app:
1. Install docker & your favorite browser
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
   
   * If you are using the port `3001` for another application you may change the port on `api:` in the `docker-compose.yml` file 
   from `3001` -> `3030` or whatever is free on your device. 

5. **If you are running the application for the first time, then there is a high possibility to get an error while adding new task because creating `User` is required for `Task`.**
      * In that case we have prepared a seeder to prepend `User` in the db. 
      Please run `docker-compose exec api rails db:seed`

### How to run the test suite
* to run rspec (or any other rails related commands)
  1. inside docker container `docker-compose exec api /bin/bash` and execute `RAILS_ENV=test bundle exec rspec spec/`
  2. or directly from outside of the container `docker exec -it alamin-training-api-1 bundle exec rspec`
    
