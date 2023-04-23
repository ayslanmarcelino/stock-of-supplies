# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  active                 :boolean          default(TRUE)
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  current_enterprise_id  :bigint
#  person_id              :bigint
#
# Indexes
#
#  index_users_on_current_enterprise_id  (current_enterprise_id)
#  index_users_on_email                  (email) UNIQUE
#  index_users_on_person_id              (person_id)
#  index_users_on_reset_password_token   (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (current_enterprise_id => enterprises.id)
#  fk_rails_...  (person_id => people.id)
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  delegate :name, to: :person

  belongs_to :person, dependent: :destroy, optional: true
  belongs_to :current_enterprise, class_name: 'Enterprise', optional: true

  has_many :roles, dependent: :destroy

  accepts_nested_attributes_for :person

  def self.permitted_params
    [
      :id,
      :active,
      :email,
      :password,
      :password_confirmation,
      :person_id,
      :current_enterprise_id
    ]
  end

  def all_roles
    roles.map(&:kind).sort
  end

  def translated_roles
    I18n.t(all_roles, scope: 'activerecord.attributes.user/role.kinds').join(', ')
  end
end
