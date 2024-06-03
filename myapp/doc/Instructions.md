### How to run this application
1. Install git, Docker Desktop and prepare a web browser
2. Clone a certain branch
    ```sh
    git clone -b <ShihaoXu0420-stepxx> https://github.com/Fablic/training.git
    ```
3. Go inside myapp
    ```sh
    cd myapp
    ```
4. Build docker file
    ```sh
    docker-compose up --build
    ```
    - If successful, you should see below
      ```sh
      api_1     | * Min threads: 5, max threads: 5
      api_1     | * Environment: development
      api_1     | * Listening on tcp://0.0.0.0:3000
      api_1     | Use Ctrl-C to stop
      ```
5. See the page by accessing `localhost:3001`

### How to run rspec tests
- To run rspec system tests
  ```sh
  docker compose exec api bundle exec rspec spec/system/ -fd
  ```
- To run rspec model tests
  ```sh
  docker compose exec api bundle exec rspec spec/models/ -fd
  ```

