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
      f.input(:created_by)
    end

    f.actions
  end

  controller do
    def create
      super

      resource.update(remaining: resource.amount) if resource.persisted?
    end
  end
end
