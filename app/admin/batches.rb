ActiveAdmin.register(Batch) do
  menu priority: 7

  permit_params Batch.permitted_params

  actions :index, :show, :new, :create, :edit, :update
end
