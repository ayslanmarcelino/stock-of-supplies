ActiveAdmin.register(Batch) do
  menu priority: 7

  includes :supply, :created_by

  permit_params Batch.permitted_params

  actions :index, :show, :new, :create, :edit, :update

  form do |f|
    f.inputs('Informações gerais') do
      f.input(:identifier)
      f.input(:supply)
      f.input(:amount)
      f.input(:arrived_date)
      f.input(:expiration_date)
      f.input(:created_by, as: :select, collection: User.all.map { |user| ["#{user.person.name} | #{user.email}", user.id] })
    end

    f.actions
  end

  controller do
    def create
      super

      if resource.persisted?
        resource.update(remaining: resource.amount)
        create_input_stock!
      end
    end

    private

    def create_input_stock!
      Stocks::Create.call(
        current_user: current_user,
        params: @batch,
        batch: @batch,
        reason: 'Recebido pelo Estado',
        kind: :input
      )
    end
  end
end
