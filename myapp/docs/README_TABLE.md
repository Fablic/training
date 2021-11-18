t_login	
項目名(論理)	項目名(物理)	型
id	id	int(11)
login_id	login_id	varchar(10)
password	password	varchar(12)
name	name	varchar(20)
created	created	datetime
updated	updated	datetime
		
		
t_tasks		
項目名(論理)	項目名(物理)	型
id	id	int(11)
task_name	task_name	varchar(10)
description	description	varchar(12)
status	status	varchar(10)
priority	priority	int(4)
label	label	varchar(20)
start_date	start_date	datetime
end_date	end_date	datetime
deleted	deleted	char(1)
login_id	login_id	int(11)
created	created	datetime
updated	updated	datetime
