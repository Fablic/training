# README

## Table schema

### `task`
|column|type|
|---|---|
|task_id|integer|
|task_name|string|
|task_desc|text|
|due_date|date|
|priority|string|
<br>

### `status`
|column|type|
|---|---|
|status_id|integer|
|status_desc|string|
<br>

### `label`
|column|type|
|---|---|
|label_id|integer|
|label_desc|string|
<br>

### `user`
|column|type|
|---|---|
|user_id|integer|
|username|string|
|password|string|
<br>

### `task record`
|column|type|
|---|---|
|record_id|integer|
|task_id|integer|
|user_id|integer|
|status_id|integer|
|label_id|integer|
<br>
