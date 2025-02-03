module Agent
  class PropertiesController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_agent!
    before_action :ensure_kyc_approved!
    before_action :set_property, only: [ :show, :edit, :update, :destroy ]

    def index
      @properties = current_user.properties.order(created_at: :desc)
    end

    def show
    end

    def new
      @property = current_user.properties.build
    end

    def create
      @property = current_user.properties.build(property_params)

      if @property.save
        redirect_to agent_property_path(@property), notice: "Propriété créée avec succès."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @property.update(property_params)
        redirect_to agent_property_path(@property), notice: "Propriété mise à jour avec succès."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @property.destroy
      redirect_to agent_properties_path, notice: "Propriété supprimée avec succès."
    end

    private

    def set_property
      @property = current_user.properties.find(params[:id])
    end

    def property_params
      params.require(:property).permit(
        :title, :description, :property_type, :status,
        :price, :surface_area, :bedrooms, :bathrooms,
        :address, :city, :postal_code, :country,
        photos: []
      )
    end

    def ensure_agent!
      unless current_user.agent?
        redirect_to root_path, alert: "Accès non autorisé. Cette section est réservée aux agents immobiliers."
      end
    end

    def ensure_kyc_approved!
      unless current_user.kyc_approved?
        redirect_to new_kyc_path, alert: "Vous devez d'abord faire valider votre KYC pour accéder à cette section."
      end
    end
  end
end
