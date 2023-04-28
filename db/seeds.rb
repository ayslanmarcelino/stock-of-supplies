user = FactoryBot.create(:user)
unit = FactoryBot.create(:unit, created_by: user)
user_person = FactoryBot.create(:person, unit: unit)

user.update(person: user_person, current_unit_id: unit.id)

admin_master = FactoryBot.create(:user, email: 'admin_master@gmail.com', password: 123456)
admin_master_person = FactoryBot.create(:person, owner: admin_master, unit: unit)
coordinator = FactoryBot.create(:user, email: 'coordinator@gmail.com', password: 123456)
coordinator_person = FactoryBot.create(:person, owner: admin_master, unit: unit)

admin_master.update(person: admin_master_person, current_unit_id: unit.id)
coordinator.update(person: coordinator_person, current_unit_id: unit.id)

FactoryBot.create(:user_role, kind: :admin_master, user: admin_master, unit: unit)
FactoryBot.create(:user_role, kind: :coordinator, user: coordinator, unit: unit)
