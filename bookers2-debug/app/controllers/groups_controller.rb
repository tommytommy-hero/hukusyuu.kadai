class GroupsController < ApplicationController

  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      redirect_to groups_path
    else
      render 'new'
    end
  end

  def show
    @book = Book.new
    @user = current_user
    @group = Group.find(params[:id])
  end

  def index
    @book = Book.new
    @user = current_user
    @groups=Group.all
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path(@group)
    else
      render "edit"
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end

end
