# Task Management App

## front design
### Login Page
![LoginPage](docs/LoginPage.png)
### Task List Page
![TaskListPage](docs/TaskListPage.png)
### Task Detail Page
![TaskDetailPage](docs/TaskDetailPage.png)
### Edit/Add Task Page
![AddTaskPage](docs/AddTaskPage.png)

## Database
### Task
| Name | Type | Description |
| -- | -- | -- |
| id | INT | PK |
| name | VARCHAR | |
| description | VARCHAR | |
| priority | INT | 1: low, 2: normal, 3: high |
| status | INT | 1: TODO, 2: IN PROGRESS, 3: DONE |
| limit | DATE | |
| user_id | INT | FK |
| created_at | DATETIME |

### Label
| Name | Type | Description |
| -- | -- | -- |
| id | INT | PK |
| name | VARCHAR | |

### Task_Label
| Name | Type | Description |
| -- | -- | -- |
| id | INT | PK |
| task_id | INT |　FK |
| label_id | INT | FK |

### User
| Name | Type | Description |
| -- | -- | -- |
| id | INT | PK |
| name | VARCHAR | |
| email | VARCHAR | |
| password | VARCHAR | |

### ER Diagram
![](docs/training.drawio.png)