ActiveAdmin.register(Order) do
  menu priority: 11

  includes :created_by, :stock, :requesting_unit

  actions :index, :show

  filter :stock, as: :select, collection: Stock.all.map(&:identifier)
  filter :requesting_unit
  filter :created_by, as: :select, collection: User.all.map { |user| ["#{user.person&.name} | #{user.email}", user.id] }
  filter :aasm_state, as: :select, collection: Order::TRANSLATED_STATES
  filter :reason, as: :select, collection: Order.all.map(&:reason).compact
  filter :amount
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column :amount
    column :aasm_state do |resource|
      I18n.t("activerecord.attributes.order.aasm_state_list.#{resource.aasm_state}")
    end
    column :reason
    column :stock do |resource|
      link_to(resource.stock.identifier, admin_stock_path(resource.stock))
    end
    column :requesting_unit
    column :created_by
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table(title: 'Informações do pedido') do
      row :id
      row :aasm_state do |resource|
        I18n.t("activerecord.attributes.order.aasm_state_list.#{resource.state}")
      end
      row :reason
      row :requesting_unit
      row :created_by
    end

    attributes_table(title: 'Suprimento') do
      row :supply do |resource|
        resource.stock.supply.name
      end
      row :stock do |resource|
        resource.stock.identifier
      end
      row :amount
    end

    attributes_table(title: 'Histórico') do
      paginated_collection(resource.versions.page(params[:page]).per(10), download_links: true) do
        table_for(collection) do
          column(:aasm_state) do |resource|
            I18n.t("activerecord.attributes.order.aasm_state_list.#{resource.aasm_state}")
          end
          column(:reason)
          column(:responsible)
          column(:created_at)
        end
      end
    end

    active_admin_comments
  end
end
