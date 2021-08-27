ActiveAdmin.register User do
  permit_params :name, :email, :password

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
