class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :properties, dependent: :destroy
  has_one_attached :avatar
  has_one_attached :identity_card

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone_number, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: %w[user agent admin] }
  validates :plan, presence: true, inclusion: { in: %w[basic standard premium] }, if: :agent?

  # Scopes
  scope :active, -> { where(blocked_until: nil) }
  scope :blocked, -> { where("blocked_until > ?", Time.current) }
  scope :agent, -> { where(role: "agent") }
  scope :admin, -> { where(role: "admin") }

  # KYC statuses
  enum :kyc_status, {
    pending: 'pending',
    submitted: 'submitted',
    approved: 'approved',
    rejected: 'rejected'
  }, default: :pending

  # Scopes pour le KYC
  scope :pending_approval, -> { where(kyc_status: "submitted") }
  scope :rejected, -> { where(kyc_status: "rejected") }
  scope :approved, -> { where(kyc_status: "approved") }

  # Callbacks
  # before_create :generate_activation_code
  # after_create :send_activation_code

  def blocked?
    blocked_until.present? && blocked_until > Time.current
  end

  def active?
    !blocked?
  end

  def admin?
    role == "admin"
  end

  def agent?
    role == "agent"
  end

  def block!(duration)
    update(blocked_until: Time.current + duration)
  end

  def unblock!
    update(blocked_until: nil)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  # KYC methods
  def kyc_submitted?
    kyc_status == "submitted" || kyc_status == "approved"
  end

  def kyc_approved?
    kyc_status == "approved"
  end

  def kyc_rejected?
    kyc_status == "rejected"
  end

  def kyc_pending?
    kyc_status == "pending" || kyc_status == "submitted"
  end

  def submit_kyc!
    return false unless avatar.attached? && identity_card.attached?
    
    update(
      kyc_status: "submitted",
      kyc_submitted_at: Time.current
    )
  end

  def approve_kyc!(admin_user)
    return false unless admin_user.admin?
    
    update(
      kyc_status: "approved",
      kyc_approved_at: Time.current,
      approved: true
    )
  end

  def reject_kyc!(admin_user, reason)
    return false unless admin_user.admin?
    
    update(
      kyc_status: "rejected",
      kyc_rejection_reason: reason,
      approved: false
    )
  end

  def activated?
    # activated_at.present?
    true # Retourne toujours true pour permettre l'accès direct
  end

  # def activate!
  #   update(activated_at: Time.current)
  # end

  # def activation_code_valid?
  #   activation_code_sent_at.present? && activation_code_sent_at > 30.minutes.ago
  # end

  # def verify_activation_code(code)
  #   if activation_code == code && activation_code_valid?
  #     activate!
  #     true
  #   else
  #     false
  #   end
  # end

  # def generate_activation_code
  #   self.activation_code = SecureRandom.random_number(100000..999999).to_s
  #   self.activation_code_sent_at = Time.current
  # end

  # def send_activation_code
  #   UserMailer.activation_code(self).deliver_later
  # end
end
