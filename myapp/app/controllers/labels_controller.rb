class LabelsController < ApplicationController
  def index
    @labels = Label.all.eager_load(:tasks)
  end
end
