class SubscriptionsController < ApplicationController
  include Devise::Controllers::Helpers

  def index
    @plans = {
      'basic' => { 
        price: 5000, 
        features: ['2 photos par annonce', 'Support par email']
      },
      'standard' => { 
        price: 10000, 
        features: ['5 photos par annonce', 'Support prioritaire', 'Statistiques de base']
      },
      'premium' => { 
        price: 20000, 
        features: ['15 photos par annonce', 'Support téléphonique 24/7', 'Statistiques avancées', 'Annonces en vedette']
      }
    }
  end

  def select_plan
    unless ['basic', 'standard', 'premium'].include?(params[:plan])
      redirect_to subscriptions_path, alert: "Veuillez sélectionner un plan valide"
      return
    end

    redirect_to new_agent_registration_path(plan: params[:plan])
  end
end 