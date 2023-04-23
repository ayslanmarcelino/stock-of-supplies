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
require 'rails_helper'

RSpec.describe User::Role, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:enterprise) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:kind_cd) }
    it { is_expected.to validate_uniqueness_of(:kind_cd).scoped_to(:user_id, :enterprise_id) }
  end

  describe 'methods' do
    describe '#translated_kind' do
      let(:kinds) do
        [
          :admin_master,
          :owner,
          :viewer
        ]
      end

      it 'has all kinds to translate' do
        expect(User::Role::KINDS).to match_array(kinds)
        expect(I18n.t('activerecord.attributes.user/role.kinds').keys).to match_array(kinds)
      end

      User::Role::KINDS.each do |kind|
        context "when has user_role with kind #{kind}" do
          let!(:role) { create(:user_role, kind: kind) }

          it "returns the translated #{kind}" do
            expect(role.translated_kind).to eq(I18n.t("activerecord.attributes.user/role.kinds.#{kind}").downcase)
          end
        end
      end
    end
  end
end
