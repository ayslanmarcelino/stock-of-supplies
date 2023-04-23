ActiveAdmin.register(Enterprise) do
  menu priority: 2

  permit_params Enterprise.permitted_params,
                address_attributes: Address.permitted_params

  actions :index, :show, :new, :create, :edit, :update

  filter :email
  filter :document_number
  filter :name
  filter :trade_name
  filter :representative_name
  filter :representative_document_number
  filter :created_at

  scope('Todos', :all)
  scope('Ativa', default: true) { |enterprise| enterprise.where(active: true) }
  scope('Desativadas') { |enterprise| enterprise.where(active: false) }

  index do
    selectable_column
    id_column
    column :document_number
    column :name
    column :trade_name
    column :opening_date
    column :active
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs('Informações gerais') do
      f.input(:email)
      f.input(:document_number, input_html: { class: 'input-cnpj' })
      f.input(:name)
      f.input(:trade_name)
      f.input(:opening_date, as: :datepicker)
    end

    f.inputs('Representante') do
      f.input(:representative_name)
      f.input(:representative_document_number, input_html: { class: 'input-cpf' })
      f.input(:birth_date, as: :datepicker)
      f.input(:cell_number, input_html: { class: 'input-cell-number' })
      f.input(:telephone_number, input_html: { class: 'input-telephone-number' })
      f.input(:identity_document_type, as: :select, collection: Enterprise::IDENTITY_DOCUMENT_TYPES)
      f.input(:identity_document_issuing_agency)
      f.input(:identity_document_number)
    end

    f.inputs('Endereço', for: [:address, resource.address || resource.build_address]) do |address|
      address.input(:zip_code, input_html: { class: 'input-zip-code' })
      address.input(:street)
      address.input(:number)
      address.input(:complement)
      address.input(:neighborhood)
      address.input(:city)
      address.input(:state, as: :select, collection: Address::STATES)
      address.input(:country, as: :select, collection: Address::COUNTRIES)
    end

    f.actions
  end

  show do
    attributes_table(title: 'Informações da empresa') do
      row :email
      row :document_number
      row :name
      row :trade_name
      row :opening_date
      row :created_at
      row :updated_at
    end

    attributes_table(title: 'Representante da empresa') do
      row :representative_name
      row :representative_document_number
      row :birth_date
      row :cell_number
      row :telephone_number
      row :identity_document_type
      row :identity_document_number
      row :identity_document_issuing_agency
    end

    panel 'Endereço' do
      attributes_table_for(resource.address) do
        row :zip_code
        row :street
        row :number
        row :complement
        row :neighborhood
        row :city
        row :state
        row :country
      end
    end

    attributes_table(title: 'Usuários') do
      paginated_collection(
        User.includes(:person)
            .where(
              person: {
                enterprise: resource
              }
            )
            .page(params[:page])
            .per(10),
        download_links: true
      ) do
        table_for(collection) do
          column(:id) { |user| auto_link(user, user.id) }
          column(:name)
          column(:email)
        end
      end
    end

    active_admin_comments
  end

  member_action_button :disable,
                       'Desativar',
                       confirm: 'Tem certeza que deseja DESATIVAR esta empresa?',
                       only: :show,
                       if: -> { resource.active? && current_user.roles.map(&:enterprise).exclude?(resource) } do
    disable!(resource)
    flash[:notice] = 'Empresa desativada com sucesso.'
    redirect_to(admin_enterprises_path)
  end

  member_action_button :activate,
                       'Ativar',
                       confirm: 'Tem certeza que deseja ATIVAR esta empresa?',
                       only: :show,
                       if: -> { disabled?(resource) } do
    activate!(resource)
    flash[:notice] = 'Empresa ativada com sucesso.'
    redirect_to(admin_enterprises_path)
  end

  controller do
    def create
      super

      Users::Roles::Create.call(params: representative_params, enterprise: resource) if resource.persisted?
    end

    private

    def representative_params
      params.require(:enterprise)
            .permit(
              Enterprise.permitted_params,
              address_attributes: Address.permitted_params
            )
    end
  end
end
