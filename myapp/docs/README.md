## Table Schema
### users

|  column  |  type  |
| ---- | ---- |
|  id  |  int  |
|  first_name  |  string  |
|  last_name  |  string  |
|  password  |  string  |
|  email  |  string  |
|  username  |  string  |
|  is_admin | bool |
|  date_of_birth | string |


### tasks

|  column  |  type  |
| ---- | ---- |
|  id  |  int  |
|  user_id  |  int  |
|  title  |  string  |
|  description  |  string  |
|  status  |  int  |
|  priority  |  int  |
|  due_date  |  datetime  |
|  assign_user_id  |  int  |
|  created_at | datetime |
|  updated_at | datetime |

### tasks_labels

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
|  description  |  string  |
