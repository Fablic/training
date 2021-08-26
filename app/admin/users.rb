ActiveAdmin.register User do
  permit_params :name, :email, :password

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
