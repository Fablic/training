ActiveAdmin.register Label do
  permit_params :email, :name, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :name
    actions
  end

  filter :name

  show do
    attributes_table do
      row :name
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end
end
