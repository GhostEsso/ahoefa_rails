class PropertiesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :ensure_agent!, only: [:new, :create, :edit, :update, :destroy, :my_properties]
  before_action :ensure_kyc_approved!, only: [:new, :create, :edit, :update]
  before_action :set_property, only: [:show, :edit, :update, :destroy]
  before_action :ensure_property_owner!, only: [:edit, :update, :destroy]

  def index
    @properties = Property.includes(:user)
                         .with_attached_photos
                         .order(created_at: :desc)

    # Filtres
    if params[:transaction_type].present?
      @properties = @properties.where(transaction_type: params[:transaction_type])
    end

    if params[:property_type].present?
      @properties = @properties.where(property_type: params[:property_type])
    end

    if params[:city].present?
      @properties = @properties.where(city: params[:city])
    end

    # Pagination
    @properties = @properties.page(params[:page]).per(9)
  end

  def my_properties
    @properties = current_user.properties.with_attached_photos.order(created_at: :desc)
  end

  def show
    @similar_properties = Property.with_attached_photos
                                .includes(:user)
                                .where(city: @property.city)
                                .where.not(id: @property.id)
                                .limit(3)
  end

  def new
    @property = current_user.properties.build
    @property.property_type = params[:property_type] if params[:property_type].present?

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "property_fields",
          partial: "properties/property_fields",
          locals: { f: params[:f], property: @property }
        )
      end
    end
  end

  def create
    @property = current_user.properties.build(property_params)

    # Mettre à zéro les chambres et salles de bain pour les terrains
    if @property.land?
      @property.bedrooms = 0
      @property.bathrooms = 0
    end

    if @property.save
      if params[:property][:photos].present?
        @property.photos.attach(params[:property][:photos])
      end
      redirect_to my_properties_path, notice: "Annonce créée avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    # Mettre à zéro les chambres et salles de bain pour les terrains
    if property_params[:property_type] == "land"
      params[:property][:bedrooms] = 0
      params[:property][:bathrooms] = 0
    end

    if @property.update(property_params)
      if params[:property][:photos].present?
        @property.photos.attach(params[:property][:photos])
      end
      redirect_to my_properties_path, notice: "Annonce mise à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @property.destroy
    redirect_to my_properties_path, notice: "Annonce supprimée avec succès."
  end

  private

  def set_property
    @property = Property.with_attached_photos.includes(:user).find(params[:id])
  end

  def property_params
    params.require(:property).permit(
      :title, :description, :price, :address, :city,
      :property_type, :transaction_type, :bedrooms, :bathrooms, :surface,
      photos: []
    )
  end

  def ensure_agent!
    unless current_user&.role == "agent"
      redirect_to root_path, alert: "Cette section est réservée aux agents immobiliers."
    end
  end

  def ensure_kyc_approved!
    unless current_user.kyc_approved?
      if current_user.kyc_pending?
        redirect_to root_path, alert: "Veuillez patienter pendant que nous vérifions vos documents KYC. Vous pourrez créer des annonces une fois votre KYC approuvé."
      elsif current_user.kyc_rejected?
        redirect_to new_kyc_path, alert: "Votre KYC a été rejeté. Veuillez soumettre à nouveau vos documents."
      else
        redirect_to new_kyc_path, alert: "Vous devez d'abord soumettre vos documents KYC pour pouvoir gérer des annonces."
      end
    end
  end

  def ensure_property_owner!
    unless @property.user == current_user
      redirect_to root_path, alert: "Vous n'êtes pas autorisé à modifier cette annonce."
    end
  end
end
