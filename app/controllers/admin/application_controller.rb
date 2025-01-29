module Admin
  class ApplicationController < ::ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin!
    layout "admin"

    private

    def ensure_admin!
      unless current_user&.role == "admin"
        redirect_to root_path, alert: "Accès réservé aux administrateurs."
      end
    end
  end
end
