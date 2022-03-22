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
|user_id|integer|
|status_id|integer|
<br>

### `user`
|column|type|
|---|---|
|user_id|integer|
|username|string|
|password|string|
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

### `task_label`
|column|type|
|---|---|
|id|integer|
|task_id|integer|
|label_id|integer|
<br>
