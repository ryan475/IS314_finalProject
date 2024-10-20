class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  enum role: { user: 0, admin: 1, super_admin: 2 }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  before_create :set_default_role

  def set_default_role
    self.role ||= 'user'
  end
  
  def admin?
    role == 'admin'
  end

  def super_admin?
    role == 'super_admin'
  end

  def user?
    role == 'user'
  end

end
