class TasksController < ApplicationController
   def index
   end

   def new
      @task = Task.new
   end
end
