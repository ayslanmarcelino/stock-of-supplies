ActiveAdmin.register(Supply) do
  menu parent: 'Estoque', priority: 0

  includes :created_by

  permit_params Supply.permitted_params

  actions :index, :show, :new, :create, :edit, :update
end
