ActiveAdmin.register(User::Role) do
  menu parent: 'Usuários', priority: 1

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
      if current_user.roles.kind_admin_masters.any?
        f.input(:kind_cd, as: :select, collection: User::Role::ROLES)
      else
        f.input(:kind_cd, as: :select, collection: User::Role::USER_KINDS)
      end
    end

    f.actions
  end
end
