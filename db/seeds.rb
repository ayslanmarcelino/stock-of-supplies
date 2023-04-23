enterprise = FactoryBot.create(:enterprise)

admin_master = FactoryBot.create(:user, :with_person, email: 'admin_master@gmail.com', password: 123456)
owner = FactoryBot.create(:user, :with_person, email: 'proprietario@gmail.com', password: 123456)
viewer = FactoryBot.create(:user, :with_person, email: 'visualizador@gmail.com', password: 123456)

[admin_master, owner, viewer].each do |user|
  user.update(current_enterprise: enterprise)
  user.person.update(enterprise: enterprise)
end

FactoryBot.create(:user_role, kind: :admin_master, user: admin_master, enterprise: enterprise)
FactoryBot.create(:user_role, kind: :owner, user: owner, enterprise: enterprise)
FactoryBot.create(:user_role, kind: :viewer, user: viewer, enterprise: enterprise)
