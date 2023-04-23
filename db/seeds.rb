enterprise = FactoryBot.create(:enterprise)
admin_master = FactoryBot.create(:user, email: 'admin_master@gmail.com', password: 123456)
person = FactoryBot.create(:person, :person, owner: admin_master, enterprise: enterprise)

admin_master.update(person: person, current_enterprise_id: enterprise.id)

FactoryBot.create(:user_role, kind: :admin_master, user: admin_master, enterprise: enterprise)
