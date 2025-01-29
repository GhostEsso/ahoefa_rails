class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def edit
  end

  def update
    if params[:user][:password].blank?
      # Mise à jour du nom uniquement
      if current_user.update(user_params.except(:password, :password_confirmation))
        redirect_to root_path, notice: "Votre profil a été mis à jour avec succès."
      else
        render :edit, status: :unprocessable_entity
      end
    else
      # Mise à jour du nom et du mot de passe
      if current_user.update(user_params)
        bypass_sign_in(current_user)
        redirect_to root_path, notice: "Votre profil et mot de passe ont été mis à jour avec succès."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :password, :password_confirmation)
  end
end
