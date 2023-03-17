class TagsController < ApplicationController
  before_action :require_login
  before_action :fetch_tag, only: [:show, :edit, :update, :destroy]

  def index
    @tags = @current_user.tags.page(params[:page])
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = @current_user.tags.new(tag_params)
    if @tag.save
      flash[:success] = I18n.t('flash.tag.create.success')
      return redirect_to @tag
    end

    flash.now[:danger] = I18n.t('flash.tag.create.failure')
    render 'new', status: :unprocessable_entity
  end

  def show
  end

  def edit
  end

  def update
    if @tag.update(tag_params)
      flash[:success] = I18n.t('flash.tag.update.success')
      return redirect_to @tag
    end

    flash.now[:danger] = I18n.t('flash.tag.update.failure')
    render 'edit', status: :unprocessable_entity
  end

  def destroy
    if @tag.destroy
      flash[:success] = I18n.t('flash.tag.delete.success')
    else
      flash.now[:danger] = I18n.t('flash.tag.delete.failure')
    end
    redirect_to tags_url
  end

  private

  def fetch_tag
    @tag = @current_user.tags.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name, :description, :status, :deadline_at)
  end
end
