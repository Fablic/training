ActiveAdmin.register User do
  permit_params :name, :email, :password

  controller do
    def scoped_collection
      end_of_association_chain.includes(:tasks)
    end
  end

  index do
    selectable_column
    column :id
    column :name
    column :email
    column 'Task-Counts' do |user|
      user.tasks.size
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :email
      row :created_at
      row :updated_at
    end

    panel 'タスク一覧' do
      table_for user.tasks do
        column :name
        column :description
        column :status
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :name
      f.input :email
      if f.object.new_record?
        f.input :password
      end
    end
    f.actions
  end
end
