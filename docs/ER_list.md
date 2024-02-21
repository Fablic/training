# Task Managment App


## Database Task Schema 

###  User

Key         column         type

PK           user_id        varchar
             name           varchar
             email          varchar
             password       varchar


###  Tasks

Key           column        type

PK            task_id       varchar
              task_name     varchar
              description   varchar
              priority      varchar
              status        varchar
              duedate       datetime
              created_at    datetime
              updated_at    datetime
FK            user_id       varchar 


###  labels

Key            column        type

PK             label_id      varchar
               label_name    varchar


###   task_label table

Key             column       type

PK              id           varchar
FK              task_id      varchar
FK              label_id     varchar


