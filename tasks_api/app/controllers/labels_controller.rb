# frozen_string_literal: true

class LabelsController < ApplicationController
  def index
    @labels = Label.all
  end
end
