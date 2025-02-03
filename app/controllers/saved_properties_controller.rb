class SavedPropertiesController < ApplicationController
  before_action :authenticate_user!

  def index
    @saved_properties = current_user.saved_properties_list
                                  .includes(:user, photos_attachments: :blob)
                                  .order(created_at: :desc)
                                  .page(params[:page])
                                  .per(9)
  end

  def create
    @property = Property.find(params[:property_id])
    current_user.saved_properties.create(property: @property)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path, notice: "Annonce sauvegardée.") }
      format.turbo_stream { render turbo_stream: turbo_stream.replace("save_button_#{@property.id}", partial: "properties/save_button", locals: { property: @property }) }
    end
  end

  def destroy
    @saved_property = current_user.saved_properties.find_by(property_id: params[:property_id])
    @property = @saved_property.property
    @saved_property.destroy
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path, notice: "Annonce retirée des sauvegardes.") }
      format.turbo_stream { render turbo_stream: turbo_stream.replace("save_button_#{@property.id}", partial: "properties/save_button", locals: { property: @property }) }
    end
  end
end
