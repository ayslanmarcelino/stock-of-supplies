ActiveAdmin.register(Person) do
  menu priority: 3

  permit_params Person.permitted_params,
                address_attributes: Address.permitted_params

  actions :index, :show, :new, :create, :edit, :update

  filter :document_number
  filter :cns_number
  filter :name
  filter :nickname
  filter :owner_type
  filter :identity_document_number
  filter :unit
  filter :created_at

  index do
    selectable_column
    id_column
    column :document_number
    column :cns_number
    column :name
    column :nickname
    column :owner_type
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table(title: 'Informações da pessoa') do
      row :name
      row :nickname
      row :cns_number
      row :birth_date
      row :marital_status_cd
    end

    attributes_table(title: 'Contatos') do
      row :telephone_number
      row :cell_number
    end

    attributes_table(title: 'Documentos') do
      row :document_number
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

    active_admin_comments
  end

  form do |f|
    f.inputs('Informações gerais') do
      f.input(:unit)
      f.input(:name)
      f.input(:nickname)
      f.input(:cns_number)
      f.input(:birth_date, as: :datepicker)
      f.input(:marital_status_cd, as: :select, collection: Person::MARITAL_STATUSES)
      f.input(:telephone_number)
      f.input(:cell_number)
      f.input(:owner_id, as: :select, collection: User.all.map { |user| ["#{user.person.name} | #{user.email}", user.id] })
      f.input(:owner_type, as: :select, collection: ['User'])
    end

    f.inputs('Documentos') do
      f.input(:document_number)
      f.input(:identity_document_type, as: :select, collection: Person::IDENTITY_DOCUMENT_TYPES)
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
end
