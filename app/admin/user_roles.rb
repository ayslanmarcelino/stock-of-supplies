ActiveAdmin.register(User::Role) do
  menu priority: 5

  includes :unit

  permit_params User::Role.permitted_params

  filter :user
  filter :unit
  filter :kind_cd, as: :select, collection: User::Role::ROLES
  filter :created_at

  form do |f|
    f.inputs('Informações gerais') do
      f.input(:unit)
      f.input(:user, as: :select, collection: User.all.map { |user| ["#{user.person.name} | #{user.email}", user.id] }.sort)
      f.input(:kind_cd, as: :select, collection: User::Role::ROLES)
    end

    f.actions
  end
end
