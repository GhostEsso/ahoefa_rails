module Admin
  class KycValidationsController < Admin::ApplicationController
    before_action :set_user, only: [:show, :approve, :reject]

    def index
      @pending_users = User.pending_approval.includes(avatar_attachment: :blob, identity_card_attachment: :blob)
      @rejected_users = User.rejected.includes(avatar_attachment: :blob, identity_card_attachment: :blob)
    end

    def show
    end

    def approve
      if @user.approve_kyc!(current_user)
        redirect_to admin_kyc_validations_path, notice: "Le compte de l'agent a été approuvé avec succès."
      else
        redirect_to admin_kyc_validations_path, alert: "Une erreur est survenue lors de l'approbation."
      end
    end

    def reject
      if @user.reject_kyc!(current_user, params[:reason])
        redirect_to admin_kyc_validations_path, notice: "Le compte de l'agent a été rejeté."
      else
        redirect_to admin_kyc_validations_path, alert: "Une erreur est survenue lors du rejet."
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end
  end
end 