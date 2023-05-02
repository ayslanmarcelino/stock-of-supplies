# == Schema Information
#
# Table name: user_roles
#
#  id         :bigint           not null, primary key
#  kind_cd    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  unit_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_user_roles_on_unit_id  (unit_id)
#  index_user_roles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (unit_id => units.id)
#  fk_rails_...  (user_id => users.id)
#
class User::Role < ApplicationRecord
  ADMIN_KINDS = [:admin_master, :admin_support].freeze
  USER_KINDS = [:coordinator, :viewer].freeze
  KINDS = ADMIN_KINDS + USER_KINDS

  ADMIN_ROLES = [
    [I18n.t('activerecord.attributes.user/role.kinds.admin_master'), 'admin_master'],
    [I18n.t('activerecord.attributes.user/role.kinds.admin_support'), 'admin_support']
  ].freeze

  USER_ROLES = [
    [I18n.t('activerecord.attributes.user/role.kinds.coordinator'), 'coordinator'],
    [I18n.t('activerecord.attributes.user/role.kinds.viewer'), 'viewer']
  ].sort.freeze

  ROLES = USER_ROLES + ADMIN_ROLES

  belongs_to :unit
  belongs_to :user

  as_enum :kind, KINDS, prefix: true, map: :string

  validates :kind_cd, presence: true
  validates :kind_cd, uniqueness: { scope: [:user_id, :unit_id] }

  def self.permitted_params
    [
      :id,
      :kind_cd,
      :user_id,
      :unit_id
    ]
  end

  def translated_kind
    translated = I18n.t("activerecord.attributes.user/role.kinds.#{kind}")

    translated.downcase
  end
end
