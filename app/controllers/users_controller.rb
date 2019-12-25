class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :show, :edit, :update, :profile_update]
  before_action :set_user, only: [:show, :edit]
  require "date"
  def index
    if current_user.umbrella
      search_date = Date.today
      @users = User.where(updated_at: search_date.in_time_zone.all_day())
      @q = @users.ransack(params[:q])
      @users = @q.result(distinct: true)
      @matchings = Matching.all
    else
      redirect_to starts_path
    end
  end

  def show
  end

  def edit
    if current_user.id != @user.id
      redirect_to users_path
    end
  end

  def update
  end

  def profile_update
    if current_user.profile
      current_user.profile.update(profile_params)
    else
      profile_info = current_user.build_profile(profile_params)
      profile_info.save
    end
    redirect_to users_path
  end

  def confirm_request
    if current_user.umbrella
      #@users = User.where(created_at: Date.yesterday.beginning_of_day..Date.today)
      @matchings = Matching.all
      @conversations = Conversation.all
    else
      redirect_to starts_path
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :gender, :age, :introduction)
  end

  def set_user
    @user = User.find(params[:id])
  end

end
