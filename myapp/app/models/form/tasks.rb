class Form::Task < Task
  REGISTRABLE_ATTRIBUTES = %i[name,description,status,due_date]
end
