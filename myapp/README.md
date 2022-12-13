# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Draft of images
  - https://officerakuten-my.sharepoint.com/:p:/g/personal/anne_ju_rakuten_com/EVCW0ukKm5BMqsaFkDJOF_EBfOlfXEAaGSfkLPTvwOx7nw?e=WMm8rQ

* Database creation
  - Model draft picture: https://officerakuten-my.sharepoint.com/:i:/g/personal/anne_ju_rakuten_com/EZ6wLQ423BlBl7cb5QXJw1ABw-11UP8nTCJW0rL_6qr7Ww?e=vSdTOz

  - User
    - id integer
    - name string
    - email string
    - password_digest string
    - is_admin boolean
    - created_at datetime
    - updated_at datetime

  - Task
    - id integer
    - title string
    - description string
    - due_date datetime
    - status integer
    - priority integer
    - user_id integer
    - created_at datetime
    - updated_at datetime

  - Visible_user
    - id integer
    - user_id integer
    - task_id integer
    - created_at datetime
    - updated_at datetime

  - Label
    - id integer
    - name string
    - created_at datetime
    - updated_at datetime

  - Task_label
    - id integer
    - task_id integer
    - label_id integer
    - created_at datetime
    - updated_at datetime

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
