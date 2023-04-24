# frozen_string_literal: true

ActiveAdmin.register_page("Dashboard") do
  menu priority: 1

  content do
    columns do
      column do
        panel 'Últimas unidades cadastradas' do
          table_for Unit.order(created_at: :desc).limit(5) do
            column :name
            column :cnes_number
            column :email
            column :created_at
          end
        end
      end

      column do
        panel 'Últimos usuários cadastrados' do
          table_for User.includes(:person).order(created_at: :desc).limit(5) do
            column :name
            column :cns_number do |user|
              user.person.cns_number
            end
            column :email
            column :created_at
          end
        end
      end
    end

    columns do
      column do
        panel 'Criação de novas unidades' do
          line_chart(Unit.group_by_month(:created_at, format: :chart).count)
        end
      end
    end
  end
end
