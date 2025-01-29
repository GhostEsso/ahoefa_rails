class AgentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @agents = User.where(role: 'agent')
                  .where(blocked: false)
                  .includes(:properties)
                  .order(created_at: :desc)
    
    # Filtrer par plan si un filtre est spécifié
    if params[:filter].present?
      @agents = @agents.where(plan: params[:filter])
    end

    # Paginer les résultats (12 agents par page)
    @agents = @agents.page(params[:page]).per(12)
  end

  def show
    @agent = User.find(params[:id])
    redirect_to root_path, alert: "Cet agent n'est plus disponible." if @agent.blocked?
    
    @properties = @agent.properties
                       .with_attached_photos
                       .order(created_at: :desc)
  end
end 