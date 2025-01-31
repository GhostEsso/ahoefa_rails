class KycController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_agent!, only: [:new, :create]
  before_action :set_user, only: [:show]

  def new
    redirect_to root_path, notice: "Votre KYC est déjà approuvé." if current_user.kyc_approved?
  end

  def create
    if kyc_params[:avatar].present? && kyc_params[:identity_card].present?
      current_user.avatar.attach(kyc_params[:avatar])
      current_user.identity_card.attach(kyc_params[:identity_card])
      
      if current_user.submit_kyc!
        redirect_to root_path, notice: "Vos documents KYC ont été soumis avec succès et sont en attente de validation."
      else
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Veuillez fournir tous les documents requis."
      render :new, status: :unprocessable_entity
    end
  end

  def show
    unless current_user.admin? || current_user == @user
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end

  private

  def kyc_params
    params.require(:user).permit(:avatar, :identity_card)
  end

  def ensure_agent!
    unless current_user.agent?
      redirect_to root_path, alert: "Cette section est réservée aux agents immobiliers."
    end
  end

  def set_user
    @user = User.find(params[:id])
  end
end 