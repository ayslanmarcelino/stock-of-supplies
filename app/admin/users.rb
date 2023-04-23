ActiveAdmin.register(User, as: 'all_users') do
  menu priority: 3

  permit_params User.permitted_params,
                person_attributes: [
                  Person.permitted_params,
                  {
                    address_attributes: Address.permitted_params
                  }
                ]

  actions :index, :show, :new, :create, :edit, :update

  scope('Todos', :all)
  scope('Ativos', default: true) { |user| user.where(active: true) }
  scope('Desativados') { |user| user.where(active: false) }

  filter :email
  filter :person
  filter :created_at

  index do
    selectable_column
    id_column
    column :email
    column :active
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table(title: 'Informações do usuário') do
      row :email
      row :active
      row :enterprise do |user|
        user.person.enterprise
      end
      row :person
      row :created_at
      row :updated_at
    end

    attributes_table(title: 'Regras de usuário') do
      paginated_collection(resource.roles.page(params[:page]).per(10), download_links: true) do
        table_for(collection) do
          column(:id) { |role| auto_link(role, role.id) }
          column(:kind_cd)
          column(:enterprise)
        end
      end
    end

    active_admin_comments
  end

  form do |f|
    f.inputs('Informações gerais') do
      f.input(:email)
      f.input(:password)
      f.input(:password_confirmation)
      f.input(:person)
      f.input(:current_enterprise)
    end

    f.actions
  end

  member_action_button :disable,
                       'Desativar',
                       confirm: 'Tem certeza que deseja DESATIVAR este usuário?',
                       only: :show,
                       if: -> { resource.active? && resource != current_user } do
    disable!(resource)
    flash[:notice] = 'Usuário desativado com sucesso.'
    redirect_to(admin_all_users_path)
  end

  member_action_button :activate,
                       'Ativar',
                       confirm: 'Tem certeza que deseja ATIVAR este usuário?',
                       only: :show,
                       if: -> { disabled?(resource) } do
    activate!(resource)
    flash[:notice] = 'Usuário ativado com sucesso.'
    redirect_to(admin_all_users_path)
  end
end
