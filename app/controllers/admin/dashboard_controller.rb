module Admin
  class DashboardController < Admin::ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin

    def index
      @total_users = User.count
      @total_properties = Property.count
      @total_agents = User.where(role: "agent").count

      # Compter les agents par type d'abonnement
      @basic_agents = User.where(role: "agent", plan: "basic").count
      @standard_agents = User.where(role: "agent", plan: "standard").count
      @premium_agents = User.where(role: "agent", plan: "premium").count
      @active_agents = User.agent.active.count
      @blocked_agents = User.agent.blocked.count
      @agents_by_plan = User.agent.group(:plan).count
      @properties_by_type = Property.group(:property_type).count
      @properties_by_city = Property.group(:city).count.sort_by { |_, count| -count }.first(9)
      @recent_properties = Property.includes(:user).order(created_at: :desc).limit(5)
    end

    private

    def ensure_admin
      unless current_user&.admin?
        redirect_to root_path, alert: "Accès non autorisé"
      end
    end
  end
end
