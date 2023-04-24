ActiveAdmin.register(Supply) do
  menu priority: 6

  permit_params Supply.permitted_params

  actions :index, :show, :new, :create, :edit, :update
end
