DROP TABLE IF EXISTS TASK_LABELS;
DROP TABLE IF EXISTS TASKS;
DROP TABLE IF EXISTS LABELS;
DROP TABLE IF EXISTS GROUPS;
DROP TABLE IF EXISTS USER_PROJECTS;
DROP TABLE IF EXISTS USERS;
DROP TABLE IF EXISTS PROJECTS;

-- create users table
CREATE TABLE USERS(
  id INT NOT NULL AUTO_INCREMENT,
  nickname VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  encrypted_password VARCHAR(255) NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (id),
  UNIQUE(id),
  UNIQUE(email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- create projects table
CREATE TABLE PROJECTS(
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (id),
  UNIQUE(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE INDEX projects_name_idx ON PROJECTS (name);

-- create user_projects table, this table is middle table
CREATE TABLE USER_PROJECTS(
  user_id INT NOT NULL,
  project_id INT NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (user_id, project_id),
  FOREIGN KEY (project_id) REFERENCES PROJECTS(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES USERS(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- create GROUPS table
CREATE TABLE GROUPS(
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  sort_number INT NOT NULL, -- 画面でGROUPSの表示順番を決める
  project_id INT NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (id),
  UNIQUE(id),
  FOREIGN KEY (project_id) REFERENCES PROJECTS (id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- create labels table
CREATE TABLE LABELS(
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  project_id INT NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (id),
  UNIQUE(id),
  FOREIGN KEY (project_id) REFERENCES PROJECTS (id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- create tasks table
CREATE TABLE TASKS(
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  priority INT NOT NULL, -- Maganement as ENUM(HIGH: 1, MIDDLE: 2, LOW: 3)
  end_period_at DATETIME NULL,
  group_id INT NOT NULL,
  creator_name VARCHAR(255) NULL,
  creator_user_id int NULL,
  assignee_name VARCHAR(255) NULL,
  assignee_user_id int NULL,
  label_id INT NULL,
  description TEXT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (id),
  UNIQUE(id),
  FOREIGN KEY (group_id) REFERENCES GROUPS (id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (label_id) REFERENCES LABELS (id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- create task_labels table, this table is middle table
CREATE TABLE TASK_LABELS(
  task_id INT NOT NULL,
  label_id INT NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (task_id, label_id),
  FOREIGN KEY (task_id) REFERENCES TASKS(id) ON DELETE CASCADE,
  FOREIGN KEY (label_id) REFERENCES LABELS(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

