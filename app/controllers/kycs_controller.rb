class KycsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_agent!
  before_action :redirect_if_approved, only: [ :new, :create ]

  def new
  end

  def create
    if kyc_params[:avatar].present? && kyc_params[:identity_card_front].present? && kyc_params[:identity_card_back].present?
      current_user.avatar.attach(kyc_params[:avatar])
      current_user.identity_card_front.attach(kyc_params[:identity_card_front])
      current_user.identity_card_back.attach(kyc_params[:identity_card_back])

      if current_user.submit_kyc!
        redirect_to root_path, notice: "Vos documents KYC ont été soumis avec succès et sont en attente de validation."
      else
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Veuillez fournir tous les documents requis (photo de profil, recto et verso de la carte d'identité)."
      render :new, status: :unprocessable_entity
    end
  end

  def show
    redirect_to new_kyc_path unless current_user.kyc_submitted?
  end

  def pending
    redirect_to new_kyc_path unless current_user.kyc_pending?
  end

  def rejected
    redirect_to new_kyc_path unless current_user.kyc_rejected?
  end

  private

  def kyc_params
    params.require(:user).permit(:avatar, :identity_card_front, :identity_card_back)
  end

  def ensure_agent!
    unless current_user.agent?
      redirect_to root_path, alert: "Cette section est réservée aux agents immobiliers."
    end
  end

  def redirect_if_approved
    if current_user.kyc_approved?
      redirect_to root_path, notice: "Votre KYC est déjà approuvé."
    end
  end
end
