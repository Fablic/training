# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def maintenance
    render :layout => false
  end
end
