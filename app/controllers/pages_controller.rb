class PagesController < ApplicationController
  def home
    @premium_properties = Property.with_attached_photos
                                .includes(:user)
                                .joins(:user)
                                .where(users: { plan: "premium" })
                                .order(created_at: :desc)
                                .limit(3)

    @standard_property = Property.with_attached_photos
                               .includes(:user)
                               .joins(:user)
                               .where(users: { plan: "standard" })
                               .order(created_at: :desc)
                               .first
  end
end
