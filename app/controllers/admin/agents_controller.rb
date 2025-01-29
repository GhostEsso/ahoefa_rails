module Admin
  class AgentsController < BaseController
    before_action :set_agent, only: [:show, :block, :unblock, :destroy]

    def index
      @agents = User.agent.order(created_at: :desc)
    end

    def show
      @properties = @agent.properties.includes(:photos_attachments).order(created_at: :desc)
    end

    def block
      duration = params[:duration].to_i.days
      if @agent.block!(duration)
        redirect_to admin_agents_path, notice: "L'agent a été bloqué pour #{params[:duration]} jours."
      else
        redirect_to admin_agents_path, alert: "Impossible de bloquer l'agent."
      end
    end

    def unblock
      if @agent.unblock!
        redirect_to admin_agents_path, notice: "L'agent a été débloqué."
      else
        redirect_to admin_agents_path, alert: "Impossible de débloquer l'agent."
      end
    end

    def destroy
      if @agent.destroy
        redirect_to admin_agents_path, notice: "L'agent a été supprimé."
      else
        redirect_to admin_agents_path, alert: "Impossible de supprimer l'agent."
      end
    end

    private

    def set_agent
      @agent = User.agent.find(params[:id])
    end
  end
end 