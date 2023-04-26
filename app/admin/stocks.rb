ActiveAdmin.register(Stock) do
  menu priority: 8

  includes :supply, :unit, :created_by

  actions :index

  filter :kind_cd, as: :select, collection: Stock::KINDS
  filter :reason, as: :select, collection: Stock.all.map(&:reason).uniq.sort
  filter :supply
  filter :unit
  filter :created_by, as: :select, collection: User.all.map { |user| ["#{user.person.name} | #{user.email}", user.id] }
  filter :created_at

  index do
    selectable_column
    id_column
    column :amount
    column :translated_kind
    column :reason
    column :supply
    column :unit
    column :created_by
    column :created_at
  end
end
