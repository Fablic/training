# README
## Ruby version
- 2.7.4

## Configuration
- bundle install --path vendor/bundle

## Database creation
- bin/rails db:create
- bin/rails db:migrate

## Database initialization
- bin/rails db:seed

## How to run the test suite
- bundle exec rspec

## Database schema
- tasks

| Name        | Type         | NULL     | Desc                           | 
| ----------- | ------------ | -------- | ------------------------------ | 
| id          | INTEGER      | NOT NULL | 主キー                         | 
| user_id     | INTEGER      | NOTNULL  | 外部キー,userがない場合、id=0  | 
| name        | VARCHAR(255) | NOTNULL  |                                | 
| description | VARCHAR(255) |          |                                | 
| due_at      | DATETIME     | NOTNULL  |                                | 
| priority    | INTEGER      | NOTNULL  | low(0)/normal(1)/high(2)       | 
| progress    | INTEGER      | NOTNULL  | Todo(0)/InProgress(1)/Done(2)  | 
| created_at  | DATETIME     | NOTNULL  |                                | 
| updated_at  | DATETIME     | NOTNULL  |                                | 

- users

| Name         | Type         | NULL    | Desc   | 
| ------------ | ------------ | ------- | ------ | 
| id           | INTEGER      | NOTNULL | 主キー | 
| name         | VARCHAR(255) | NOTNULL | 主キー | 
| email | INTEGER      | NOTNULL |        | 
| password     | VARCHAR(255) | NOTNULL |        | 
| is_admin     | Boolean      | NOTNULL | Default(false)       | 
| created_at   | DATETIME     | NOTNULL |        | 
| updated_at   | DATETIME     | NOTNULL |        | 
