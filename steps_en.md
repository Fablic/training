# Rails Training

## About this curriculum

This is a curriculum for new employees designed to acquire the fundamentals of Ruby on Rails and its surrounding technologies, necessary for working at Rakuma.

It primarily targets beginners in Rails. Please consider your own prior experience and discuss with your mentor to determine feasibility and proceed accordingly. If you have already worked with Rails, you may not need to go through this curriculum.

## License

This curriculum is under [Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.en)

[![creative commons license](https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png)](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.en)

## System requirements

In this curriculum, you have to develop "task management system" as an assignment.
the requirement should be like this.

- Want to post your tasks easily
- Want to set an expiration date for a task
- Want to prioritize tasks
- Want to manage the status (not started / started / completed)
- Want to narrow down tasks by status
- Want to search for a task by task name / task description
- Want to list the tasks. I want to sort on the list screen (based on priority, expiration date, etc.)
- Want to label tasks and classify them
- Want to register as a user so that I can see only the tasks I registered
- User Admin Tool
- Want to be able to carry out maintenance

You can skip implementing some features in consultation with your mentor.

## Supported browser

- Supported browser is suppose to be the latest version of macOS / Chrome

## Application server arrangement

I would like you to build using the following languages and middleware (both are the latest stable versions).

- Ruby
- Ruby on Rails
- MySQL
- Docker Compose

**Performance requirements and security requirements are not specified, but please make with general quality. If the site you made is too slow, we would ask you to fix it.**

## Goals

At the end of this curriculum, you'll be able to reach following levels.

- Being able to implement basic web applications using Rails
- Being able to publish your application in a Rails application using a common environment
- Being able to add features and maintain data for developed Rails applications
- Learn the flow of PR and merging on GitHub. Also, learn the Git commands required for it.
  - Being able to commit with proper commit size
  - Being able to write a proper PR description
  - Being able to respond to reviews and fix errors
- Being able to ask questions to team members and related parties (this time I will be a mentor) verbally or chat at the right time

---

## Assignment steps

### Step 0: Install the Chrome Extension

The training is based on materials created by Manyo Corporation, and there have been instances where pull requests were mistakenly directed to the original repository. To prevent this, please install a Chrome extension that automatically redirects pages.

#### 0-1: Clone the Chrome Extension

`git clone git@github.com:Fablic/fablic-chrome-extension.git`

#### 0-2: Install the Chrome Extension

Open chrome://extensions/, enable Developer mode at the top right, and install the extension by dragging and dropping the RKGithubSupportTool.

#### 0-3: Start the Training, Appreciating Manyo Corporation

[Original repository](https://github.com/everyleaf/el-training)

### Step 1: Set Up the Development Environment

#### 1-1. Install Docker

- Create an account on Docker's official site, log in, and download and install from DockerHub.
    - https://hub.docker.com/editions/community/docker-ce-desktop-mac


#### 1-2.  Install Git

- Install Git locally.
  - For macOS, you can install it using brew.
    - Although macOS comes with Git pre-installed, it is recommended to install the latest version.
  - Register your username and email address using `gitconfig`.

### Step 2: Initialize the Repository

- Create a new branch.
  - Create a branch with your account name based on the master branch.
    - `git checkout -b github_account_name origin/master`
  - After creating the branch, push it.

### Step 3: Create a Rails Project

- Move to the working directory.
    ```sh
    cd myapp
    ```
- Add your name to `myapp/.env`
    ```yml
    COMPOSE_PROJECT_NAME=〇〇-training # Replace '〇〇' with your name
    # ex) COMPOSE_PROJECT_NAME=Taro-training
    ```
- 下Use the following command to create the minimum required directories and files for the application.
    ```sh
    docker compose run api bundle exec rails new . --force --database=mysql -G
    ```
    - For Mac M1, M2, M3 chips:
        Specify the following under `api:` and `db:` in `compose.yml`
        ```yml
        platform: linux/amd64
        ```
        under `chrome:`
        ```yml
        image: seleniarm/standalone-chromium
        ```

- Create a `docs` directory directly under the project directory (app directory created with `rails new`) and commit this document file.
  - This is to keep the application specifications under control and accessible at any time.
-  In Rails 7.1, the default auto-generated Dockerfile is for the production environment, so change it to the development environment.
  ```yml
  ENV RAILS_ENV="development" \
      BUNDLE_DEPLOYMENT="1" \
      BUNDLE_PATH="/usr/local/bundle"
  ```

- Modify `config/database.yml` as follows to allow the application to connect:
    ```yml
    default: &default
      adapter: mysql2
      encoding: utf8mb4
      charset: utf8mb4 
      collation: utf8mb4_general_ci 
      pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
      database: <%= ENV['DB_NAME'] %> # from compose.yml
      username: <%= ENV['DB_USER'] %> # from compose.yml
      password: <%= ENV['DB_PASSWORD'] %> # from compose.yml
      host: <%= ENV['DB_HOST'] %> # from compose.yml
    ```
    - Other parts can remain unchanged.
- Use the following command to build Docker and launch the application:
    ```sh
    docker compose up --build
    ```
    - For Mac M1 chip:
      if
      ```sh
      Function not implemented - Failed to initialize inotify (Errno::ENOSYS)
      ```
      Edit `config/environments/development.rb`as follows:
      ```
      - config.file_watcher = ActiveSupport::EventedFileUpdateChecker
      + config.file_watcher = ActiveSupport::FileUpdateChecker
      ```
    - If using sassc 2.4.0 and bundle install takes too long (more than 1000s), it is usually safe to wait. For more information, see:
      - [Rails: Why is bundle install frozen up by sassc 2.4.0](https://stackoverflow.com/questions/62720043/rails-why-is-bundle-install-frozen-up-by-sassc-2-4-0)
    - If the application starts up normally, the following will be displayed:
      ```sh
      api_1  | => Booting Puma
      api_1  | => Rails 6.0.0 application starting in development
      api_1  | => Run `rails server --help` for more startup options
      api_1  | Puma starting in single mode...
      api_1  | * Version 3.12.1 (ruby 2.6.4-p104), codename: Llamas in Pajamas
      api_1  | * Min threads: 5, max threads: 5
      api_1  | * Environment: development
      api_1  | * Listening on tcp://0.0.0.0:3000
      api_1  | Use Ctrl-C to stop
      ```
    - Try accessing `localhost:3001`
- Push the created app to the branch created on GitHub.
  - It is recommended to set up gitignore before pushing: [【Rails】.gitignoreの設定について](https://qiita.com/nozonozo/items/011308bf8f903977ac1a)

### step4: Get Familiar with Docker

The Docker Compose commands you'll use during development are as follows. Try executing them to get familiar.

- Start the application
    - `docker compose up`
        - This starts MySQL and Rails, making it accessible from the browser.
        - You can also connect to the DB using tools like SequelPro. Check `compose.yml` for port and user info.
    - `docker compose up -d`
        - This starts the application as a daemon. Use this if you want it always running.
        - stop with `docker compose down`
- Execute Rails commands:
    - `docker compose exec api xxx`
        - `docker compose exec`allows you to execute commands inside a running container.
        - Use `api` to specify the container, referring to the service name defined in `compose.yml`.
        - Replace `xxx` with any Rails command, such as `rails c`, `rails db:migrate:status`, or `rails generate xxx`.
    - For the rest of the documentation, the prefix `docker compose exec api` may be omitted from commands, so adapt as necessary.
- Additional Tips:
    - `docker compose exec api /bin/bash`
        - This command opens a shell inside the container.
    - `docker compose exec api tail -f log/development.log`
        - This command allows you to tail the development log without entering the container.
- Understanding what Docker does:
    - Dockerfile: Defines the processes for setting up Docker, copying necessary files, and installing Rails.
    - compose.yml: Defines the processes for starting MySQL and the Rails application together.
        - This file includes steps like `rails db:create`, so Rails starts automatically when Docker is launched.
    - You can connect to MySQL locally using the command: `mysql -h 127.0.0.1 -u root -p -P 3316`
        - Tools like Sequel Pro can also connect using the above settings.
- Regarding development:
    - Changes made to local files are automatically reflected in the files on the Docker side, so you can use any editor to develop.
    - Plugins are available for editors like vim and RubyMine that support Docker. If you want to run tests within the IDE, install the necessary plugins.


### Step 5: Conceptualize the Application You Want to Build

- Before advancing with design, think about what the final application might look like (together with your mentor). Paper prototyping for screen design is recommended.
- Read the system requirements and consider the necessary data structures.
  - What models (tables) might be necessary?
  - What information should be included in these tables?
- Once you have thought about the data structure, create a model diagram by hand.
  - After completing the diagram, take a picture and include it in the repository.
  -Include the table schema in the `README.md`  (model names, column names, data types). 

* Note: At this stage, you do not need to create a perfect model diagram. Consider it as your current understanding and expect to refine it in later steps.

### Step 6: Create the Task Model

Create CRUD (Create, Read, Update, Delete) functionality for managing tasks.
Start with a simple configuration where only the task name and details can be registered.

- Use the`rails generate` command to create the model class required for task CRUD.
- Create migrations and use them to create tables.
  - It is important to ensure that migrations can be rolled back to a previous state! Make a habit of checking using redo.
- Confirm that you can connect to the database via the model using the rails c command.
  - At this time, try creating a record using ActiveRecord.
- Create a pull request on GitHub and have it reviewed.
  - Respond to any comments. Once you get two LGTMs (Looks Good To Me), merge into the main branch.

### Step 7: Implement Task Registration, Update, and Deletion

- Create the task list, create, detail, and edit views.
  - Use the `rails generate` command to create the necessary controllers and views.
  - Add the necessary implementation to the controllers and views.
  - Display flash messages on the screen after creating, updating, or deleting a task.
- Edit `routes.rb` so that the task list view is displayed at `http://localhost:3000/`.
- Install RuboCop (a Ruby static code analysis tool) or fablicop via the Gemfile. Check the README for settings and command execution methods.
- Create a pull request on GitHub and have it reviewed.
  - If it seems that the pull request will be large, consider splitting it into two or more pull requests.

## step 8: Write Tests (System Specs)
- First make sure that these gems are exist in Gemfile
  ```
  group :test do
    gem 'capybara', '>= 2.15'
    gem 'selenium-webdriver'
  end
  ```
  **Note**: Remove the `webdrivers` gem from your Gemfile. If `webdrivers` is present, it will attempt to  find Chrome in your application’s container.
  As Chrome isn’t installed  in the Dockerfile, the spec will fail.

- Before start testing we need to register a new driver with Capybara that is configured to use the Selenium container, add the below codes to
  `spec/rails_helper.rb`
  ```
  Capybara.register_driver :remote_chrome do |app|
    hub_url = 'https://chrome:4444/wd/hub'
    chrome_capabilities = ::Selenium::WebDriver::Remote::Capabilities.chrome(
      'goog:chromeOptions' => {
        'args' => %w[no-sandbox headless disable-gpu window-size=1680,1050],
      },
    )
    Capybara::Selenium::Driver.new(app, browser: :remote, url: hub_url, desired_capabilities: chrome_capabilities)
  end

  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :remote_chrome
    Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
    Capybara.server_port = 3000
    Capybara.app_host = "https://#{Capybara.server_host}:#{Capybara.server_port}"
  end
  ```
- Prepare for writing specs.
  - Set up`spec/spec_helper.rb` 、 `spec/rails_helper.rb`
- Write system specs for the task functionality.
  - Since Rails 5.1, system tests have been introduced.
    - [英語](https://rossta.net/blog/why-rails-system-tests-matter.html)
  - When conducting training using Docker, the following settings are necessary:
    1. [Dockerfile](https://qiita.com/ngron/items/f61b8635b4d67f666d75#failed-to-read-the-sessionstorage-property-from-window-storage-is-disabled-inside-data-urls)
    2. [spec/rails_helper.rb](https://commis.hatenablog.com/entry/2018/11/16/171608)

  - feature specですと `database_cleaner` という gemは必要でしたが、 system specに変更することで `database_cleaner` の導入が要らなくなった
- Introduce CI tools such as CircleCI and set them up to notify Slack.
  - If conducting PR exchanges within Fablic/training, introducing CI tools is optional. CircleCI cannot be executed as admin privileges are unavailable, even if .circleci/config.yml is set up.
- Reference book：https://leanpub.com/everydayrailsrspec-jp

### Step 9: Configure Various Application Settings

- Centralize Japanese text
  - Use Rails' i18n feature to centralize Japanese resources.
  - Note: Centralizing with i18n will make displaying messages easier in later steps.
- Set the time zone
  - Set the Rails time zone to Japan (Tokyo).
- Set up error pages
  - Replace Rails' default error pages with custom-made pages.
  - Set up appropriate error pages as needed.
  - At a minimum, you must set up 404 and 500 status code pages.

### Step 10: Sort the Task List by Creation Date ★ Optional

- Currently, tasks are sorted by ID. Change this to sort by the creation date in descending order.
- Write system specs to confirm that sorting is working correctly.

### step 11: Set Up Validations

- Set up validations.
  - Consider which columns require which validations.
  - Create a migration to set up corresponding database constraints.
  - Use the rails generate command to create only the migration files.
- Display validation error messages on the screen.
- Write model tests for validations.
- Create a pull request on GitHub and have it reviewed.

### Step 12: Add a Due Date to Tasks ★ Optional

- Enable tasks to have a due date.
- Allow sorting by the due date on the task list view.
- Expand the specs.
- After creating a pull request and having it reviewed, release it.

### Step 13: Add Status and Enable Search by Status

- Add status (Not Started, In Progress, Completed).
  - *Optional requirement: If you are not a beginner, consider using a gem for managing state.
- Enable searching by title, description, and status on the task list view.
  - *Optional requirement: If you are not a beginner, consider using a gem like ransack to simplify search implementation.
- When filtering, review the log to see the changes in the executed SQL.
  - Make a habit of checking this when necessary in subsequent steps.
- Add search indexes.
- Add model specs for search functionality (also expand system specs).

### Step 14: Add Pagination

- Use the Kaminari gem to add pagination to the task list view.

### Step 15: Apply Design ★ Optional
- Introduce Bootstrap and apply design to the application created so far.
  - *Optional requirement: Write custom CSS for the design.

### Step 16: Enable Multi-user Support (User Implementation)

- Create a user model.
- Use seed data to create the first user.
- Associate users with tasks.
  - Add indexes for relationships.
  - Introduce measures to avoid N+1 problems.
    - Introduce bullet to automatically detect N+1 queries (Reference Article).（(https://fablic.qiita.com/craftcat/items/b181b67ddae0c7d0702a)）

### Step 17: Implement Login/Logout Functionality

- Implement without using additional gems.
  - Avoid using Devise or similar gems to deepen understanding of HTTP Cookies, Rails Sessions, and general authentication concepts (like handling passwords).
- Implement a login view.
- Ensure users cannot access the task management page without logging in.
- Display only tasks created by the logged-in user.
- Implement logout functionality.

### Step 18: Implement User Management Screen ★ Optional
- Add an admin menu on the screen.
- Ensure that the management screen always starts with /admin in the URL.
  - Before adding to routes.rb, design and consider URLs and routing names (which will become *_path).
- Implement user list, creation, update, and deletion functionalities.
- When a user is deleted, delete the tasks associated with that user.
- On the user list view, display the number of tasks each user has.
- Enable viewing of a list of tasks created by each user.

### Step 19: Add Roles to Users ★ Optional

- Differentiate between admin users and regular users.
- Ensure that only admin users can accessAllow roles to be selectable on the user management page.
- Allow users to select roles in the user management page.
- Prevent deletion of the last admin user.
- *Note: Using or not using a gem is up to you.

### Step 20: Enable Task Labeling

- Allow multiple labels to be assigned to tasks.
- Enable searching by labels.

### Step 21: Implement Maintenance Functionality

- Create a batch to start and end maintenance.
- Redirect users accessing the site during maintenance to a maintenance page.
- Implement this without using additional gems.

## Closing Remarks

Congratulations on completing the training curriculum!

Since you've successfully built an application, consider presenting it at a company-wide LT event like Makitani Night. It could be a great opportunity to share your work.

While this curriculum may not cover everything, the following topics will likely become important in the future. Continue to learn about these areas, often through working on projects:

- Deepen your understanding of basic web applications
  - Understand HTTP and HTTPS
- Learn more advanced uses of Rails
  - Logging
  - Explicit transactions
  - Asynchronous processing
  - Asset pipeline (more related to release topics)
- Gain a more advanced understanding of frontend technologies like JavaScript and CSS
- Deepen your understanding of databases
  - SQL
  - Construct queries with a focus on performance
  - Deepen understanding of indexes
- Gain more knowledge about server environments
  - Linux OS
  - Web server settings (e.g., Nginx)
  - Application server settings (e.g., Unicorn)
  - Understanding of MySQL configuration
- Understand release-related tools
  - Capistrano
  - Ansible

## Optional Requirements

In addition to the mandatory requirements, optional requirements for the task management system are listed below. Consider implementing them as needed, in consultation with your mentor.

### Optional Requirement 1: Alert for Near-Deadline or Overdue Tasks

- When logging in, display tasks that are near their deadline or overdue somewhere.
- Consider marking tasks as read or similar for better visibility.

### Optional Requirement 2: Enable Task Sharing Among Users

- Allow multiple users to refer to and edit the same task.
  - Example: Sharing tasks between a mentor and mentee.
- Display the task creator.

### Optional Requirement 3: Allow Group Settings

- Continuation of Optional Requirement 2
- Enable setting up groups, allowing task reference only within the group.

### Optional Requirement 4: Allow Attachment of Files to Tasks

- Enable file attachments to tasks.
- If using Heroku, manage uploaded attachments using an S3 bucket.
- Choose and use appropriate gems.

### Optional Requirement 5: Allow Users to Set Profile Pictures

- Allow users to set a profile picture.
- Since the uploaded image will be used as an icon, create a thumbnail to prevent slowdowns.
- Choose and use appropriate gems or libraries.

### Optional Requirement 6: Implement a Task Calendar

- Visualize deadlines by displaying tasks in a calendar based on their due dates.
- Use or avoid libraries as desired.

### Optional Requirement 7: Enable Drag-and-Drop Sorting of Tasks

- Implement drag-and-drop sorting on the task list view.

### Optional Requirement 8: Visualize Label Usage Frequency with Graphs

- Introduce graphs to visualize statistical information.
- Propose the most readable types of graphs.

### Optional Requirement 9: Send Email Notifications for Near-Deadline Tasks

- Send email notifications for tasks that are near their deadline, running in the background.
- Use cloud services for email delivery.
  - Use SendGrid for Heroku
  - Use Amazon SES for AWS
- Set it to send once daily via a batch job.
  - Use Heroku Scheduler (add-on) for Heroku
  - Set up cron jobs for AWS

### Optional Requirement 10: Set Up an Environment on AWS and Deploy

- Set up and deploy the environment on AWS.
- Recommend Nginx+Unicorn as the middleware configuration.
- Refer to server requirements for EC2 instance settings.

### Optional Requirement 11: Use JavaScript for Asynchronous Label Retrieval

- Continuation of Step 20
- When registering a task, initially hide the labels (do not fetch label data).
- Instead, provide a button to add labels, and retrieve and display label data upon clicking the button.
- Write tests as well.
