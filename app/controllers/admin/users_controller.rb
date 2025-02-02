class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :block, :unblock]
  USERS_PER_PAGE = 8

  def index
    @total_users = User.where(role: "user").count
    @total_pages = (@total_users.to_f / USERS_PER_PAGE).ceil
    @current_page = [params[:page].to_i, 1].max
    
    @users = User.where(role: "user")
                 .includes(avatar_attachment: :blob)
                 .order(created_at: :desc)
                 .offset((@current_page - 1) * USERS_PER_PAGE)
                 .limit(USERS_PER_PAGE)
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "L'utilisateur a été mis à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "L'utilisateur a été supprimé avec succès."
  end

  def block
    duration = params[:duration].to_i.days
    @user.block!(duration)
    redirect_to admin_user_path(@user), notice: "L'utilisateur a été bloqué pour #{params[:duration]} jours."
  end

  def unblock
    @user.unblock!
    redirect_to admin_user_path(@user), notice: "L'utilisateur a été débloqué."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_number)
  end
end 