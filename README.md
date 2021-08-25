# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

```
ruby 3.0.1p64 or later
```

- System dependencies

```
nodejs and npm are required
```

- Configuration

```
cd tasks_api/
bundle install
cd ../tasks_ui/
npm i
```

- Database creation

```
for DEV, database named "tasks_api_development" is required with "tasks_api_user" as a username and "tasks_api_user_passwd" as a password. See config/database.yml.
```

- Database initialization<br>
  in tasks_api/ directory run following command:

```
bundle install && rails db:migrate
```

- How to run the test suite<br>
  for backend API, run following command in tasks_api/

```
rspec
```

for UI, run following command in tasks_ui/

```
npm run test
```

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

```
cd tasks_api/
bundle install && rails db:migrate
ALLOW_ORIGIN=https://localhost:8080 rails s &
cd ../tasks_ui/
npm i
npm run start
```

- Maintenance

```
cd tasks_api/
# set maintenance mode
rails runner bin/maintenance.rb set <comment>
# check maintenance mode
rails runner bin/maintenance.rb show
# unset maintenance mode
rails runner bin/maintenance.rb unset
```
