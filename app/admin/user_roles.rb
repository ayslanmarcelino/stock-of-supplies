ActiveAdmin.register(User::Role) do
  menu priority: 5

  includes :enterprise, user: :person

  permit_params User::Role.permitted_params

  filter :enterprise
  filter :user
  filter :kind_cd, as: :select, collection: User::Role::ROLES
  filter :created_at

  form do |f|
    f.inputs('Informações gerais') do
      f.input(:enterprise)
      f.input(:user, as: :select, collection: User.all.map { |user| [user.person.name, user.id] })
      f.input(:kind_cd, as: :select, collection: User::Role::ROLES)
    end

    f.actions
  end
end
