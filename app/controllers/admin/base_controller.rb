module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin!

    layout 'admin'

    private

    def ensure_admin!
      Rails.logger.debug "Current user: #{current_user.inspect}"
      Rails.logger.debug "Is admin? #{current_user&.admin?}"
      
      unless current_user&.admin?
        redirect_to root_path, alert: "Accès non autorisé."
      end
    end
  end
end 