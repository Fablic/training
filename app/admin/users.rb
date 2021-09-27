ActiveAdmin.register User do
  permit_params :email, :name, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :name
    actions
  end

  filter :email
  filter :name

  show do
    attributes_table do
      row :name
      row :email
      row :created_at
      row :updated_at
    end

    table_for user.tasks do
      column :id
      column :name
      column :description
      column :status
      column :priority
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end
    end
    f.actions
  end
end
