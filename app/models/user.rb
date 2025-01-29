class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :properties, dependent: :destroy
  has_one_attached :avatar

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
end
