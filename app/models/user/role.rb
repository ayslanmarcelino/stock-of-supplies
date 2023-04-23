# == Schema Information
#
# Table name: user_roles
#
#  id            :bigint           not null, primary key
#  kind_cd       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  enterprise_id :bigint
#  user_id       :bigint
#
# Indexes
#
#  index_user_roles_on_enterprise_id  (enterprise_id)
#  index_user_roles_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (enterprise_id => enterprises.id)
#  fk_rails_...  (user_id => users.id)
#
class User::Role < ApplicationRecord
  ADMIN_KINDS = [:admin_master].freeze
  USER_KINDS = [:owner, :viewer].freeze
  KINDS = ADMIN_KINDS + USER_KINDS

  ADMIN_ROLES = [
    [I18n.t('activerecord.attributes.user/role.kinds.admin_master'), 'admin_master']
  ].freeze

  USER_ROLES = [
    [I18n.t('activerecord.attributes.user/role.kinds.owner'), 'owner'],
    [I18n.t('activerecord.attributes.user/role.kinds.viewer'), 'viewer']
  ].sort.freeze

  ROLES = USER_ROLES + ADMIN_ROLES

  belongs_to :enterprise
  belongs_to :user

  as_enum :kind, KINDS, prefix: true, map: :string

  validates :kind_cd, presence: true
  validates :kind_cd, uniqueness: { scope: [:user_id, :enterprise_id] }

  def self.permitted_params
    [
      :id,
      :kind_cd,
      :user_id,
      :enterprise_id
    ]
  end

  def translated_kind
    translated = I18n.t("activerecord.attributes.user/role.kinds.#{kind}")

    translated.downcase
  end
end
