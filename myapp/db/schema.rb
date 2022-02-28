# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_220_210_065_045) do
  create_table 'boards', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4', force: :cascade do |t|
    t.string 'title'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'boards_users', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4', force: :cascade do |t|
    t.integer 'permissions'
    t.integer 'board_id'
    t.integer 'user_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'priorities', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4', force: :cascade do |t|
    t.string 'title'
    t.integer 'sort'
    t.string 'color'
    t.integer 'board_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'statuses', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4', force: :cascade do |t|
    t.string 'title'
    t.integer 'sort'
    t.integer 'board_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'tags', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4', force: :cascade do |t|
    t.string 'tag'
    t.integer 'board_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'tags_tasks', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4', force: :cascade do |t|
    t.integer 'board_id'
    t.integer 'tag_id'
    t.integer 'task_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'tasks', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4', force: :cascade do |t|
    t.integer 'board_id'
    t.integer 'user_id'
    t.string 'title'
    t.text 'contents'
    t.integer 'status_id'
    t.integer 'priority_id'
    t.datetime 'due_date'
    t.datetime 'modified_at'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end
end
