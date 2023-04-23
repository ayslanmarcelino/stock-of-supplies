FactoryBot.define do
  factory(:user_role, class: 'User::Role') do
    user { create(:user, :with_person) }
    kind_cd { :admin_master }

    enterprise { user.person.enterprise }
  end
end
