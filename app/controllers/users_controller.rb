class UsersController < ApplicationController
  include Pagy::Backend

  def index
    @q = User.ransack(params[:q])
    @pagy, @users = pagy(@q.result(distinct: true).includes(:user_detail, :user_communities, :communities).order(created_at: :desc))
  end

  def my_communities
    redirect_to root_path, alert: "Please sign in to view your communities." unless Current.user

    @q = Current.user.communities.ransack(params[:q])
    @pagy, @my_communities = pagy(@q.result(distinct: true).order(created_at: :desc))
  end
end
