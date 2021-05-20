# myapp

## How to run?

You can check this program with this command:

```console
$ docker-compose --file docker-compose.prod.yml --project-name myapp-prod build
$ docker-compose --file docker-compose.prod.yml --project-name myapp-prod up -d db
$ docker-compose --file docker-compose.prod.yml --project-name myapp-prod run --rm api bundle exec rails db:setup
$ docker-compose --file docker-compose.prod.yml --project-name myapp-prod up -d
```

After successfuly running, you can check on http://localhost:3002/

## Models

Before implementing, I surmised these models might be required.

* `User`
    - is responsible for detecting who are you
    - is used for authentication and authorization
    - possible attributes: `id`, `name`, `password`, `role`
* `Task`
    - is responsible for storing **Task**
    - belongs to `User`
    - possible attributes: `id`, `name`, `description`, `due_date`, `priority`, `status`
* `Label`
    - is responsible for storing **Label**
    - associates with `Tasks` as Many to Many
    - possible attributes: `id`, `name`, `color`

```
+------+         +------+        +-------+
| User |-------->| Task |<------>| Label |
+------|         +------+        +-------+
```
