## Target Issue
https://github.com/Fablic/training/tree/stakahashi-d/myapp/docs

## Todos Application
It is a todos app that does following key features

- Create Task
- Set due date to task
- Set status to task
- Delete task
- Search task by title or description, and status
- sort tasks by due_date


## Table Schema
### users

|  column  |  type  |
| ---- | ---- |
|  id  |  int  |
|  name  |  string  |
|  password  |  string  |
|  email  |  string  |
|  admin_flg | int |

### tasks

|  column  |  type  |
| ---- | ---- |
|  id  |  int  |
|  user_id  |  int  |
|  name  |  string  |
|  description  |  string  |
|  status  |  int  |
|  priority  |  int  |
|  due_date  |  datetime  |
|  created_at | datetime |
|  updated_at | datetime |

### task_labels

|  colum  |  type  |
| ---- | ---- |
|  id  |  int  |
|  task_id | int |
|  label_id | int |

### labels

|  colum  |  type  |
| ---- | ---- |
|  id  |  int  |
|  name  |  string  |


## how to run
* use following command to up appication

```
docker-compose up --build
```

* you can dive into docker machine by following command

```
docker-compose exec api /bin/bash
docker-compose exec db /bin/bash
```

* Please access the following URL with your browser
  * http://localhost:3001/

## how to set maintenance mode
* you can start maintenance mode by following command

```
rake maintenance:start
```

if you get following response, maintenance mode is starting

```
Started mentenance mode
```

* you can stop maintenance mode by following command

```
rake maintenance:stop
```

if you get following response, maintenance mode is stopped

```
Stopped maintenance mode
```
