user = FactoryBot.create(:user)
unit = FactoryBot.create(:unit, created_by: user)
user_person = FactoryBot.create(:person, unit: unit)

user.update(person: user_person, current_unit_id: unit.id)

admin_master = FactoryBot.create(:user, email: 'admin_master@gmail.com', password: 123456)
person = FactoryBot.create(:person, owner: admin_master, unit: unit)

admin_master.update(person: person, current_unit_id: unit.id)

FactoryBot.create(:user_role, kind: :admin_master, user: admin_master, unit: unit)
