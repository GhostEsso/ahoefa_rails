class AccountActivationsController < ApplicationController
  def new
    @user = User.find_by(email: params[:email])
    redirect_to new_user_session_path, alert: "Email invalide" unless @user
  end

  def create
    @user = User.find_by(email: params[:email])

    if @user&.verify_activation_code(params[:activation_code])
      redirect_to new_user_session_path, notice: "Votre compte a été activé avec succès. Vous pouvez maintenant vous connecter."
    else
      flash.now[:alert] = "Code d'activation invalide ou expiré"
      render :new, status: :unprocessable_entity
    end
  end

  def resend
    @user = User.find_by(email: params[:email])

    if @user && !@user.activated?
      @user.send(:generate_activation_code)
      @user.save
      @user.send(:send_activation_code)
      redirect_to new_account_activation_path(email: @user.email), notice: "Un nouveau code d'activation a été envoyé à votre adresse email"
    else
      redirect_to new_user_session_path, alert: "Une erreur est survenue"
    end
  end
end
