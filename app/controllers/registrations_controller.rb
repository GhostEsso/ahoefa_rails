class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  def new
    build_resource({})
    resource.role = 'user'
    resource.plan = 'basic'
    respond_with resource
  end

  def new_agent
    build_resource({})
    resource.role = 'agent'
    
    # Vérifier que le plan est valide
    unless ['basic', 'standard', 'premium'].include?(params[:plan])
      redirect_to subscriptions_path, alert: "Veuillez sélectionner un plan valide"
      return
    end

    @plans = {
      'basic' => { price: 5000, features: ['2 photos par annonce', 'Support par email'] },
      'standard' => { price: 10000, features: ['5 photos par annonce', 'Support prioritaire', 'Statistiques de base'] },
      'premium' => { price: 20000, features: ['15 photos par annonce', 'Support téléphonique 24/7', 'Statistiques avancées', 'Annonces en vedette'] }
    }

    resource.plan = params[:plan]
    @selected_plan = params[:plan]
    @selected_price = @plans[@selected_plan][:price]

    render :new_agent
  end

  def create
    if sign_up_params[:role] == 'agent'
      unless ['basic', 'standard', 'premium'].include?(sign_up_params[:plan])
        flash[:error] = "Veuillez sélectionner un plan valide"
        redirect_to new_agent_registration_path(plan: sign_up_params[:plan])
        return
      end
    end

    super
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone_number, :role, :plan, :annual, :price])
  end

  def after_sign_up_path_for(resource)
    if resource.role == 'agent'
      my_properties_path
    else
      root_path
    end
  end
end 