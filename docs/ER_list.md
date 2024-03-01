# Task Managment App


## Database Task Schema 

###  User

Key         column         type

PK           user_id        bigint
             name           varchar
             email          varchar
             password       varchar


###  Tasks

Key           column        type

PK            task_id       bigint
              task_name     varchar
              description   varchar
              priority      varchar
              status        varchar
              duedate       datetime
              label         varchar
              created_at    datetime
              updated_at    datetime
FK            user_id       bigint


###  labels

Key            column        type

PK             label_id      bigint
               label_name    varchar


###   task_label table

Key             column       type

PK              id           bigint
FK              task_id      bigint
FK              label_id     bigint


