# frozen_string_literal: true

ActiveAdmin.register_page("Dashboard") do
  menu priority: 1

  content do
    columns do
      column do
        panel 'Últimas empresas cadastradas' do
          table_for Enterprise.order(created_at: :desc).limit(5) do
            column :name
            column :trade_name
            column :email
            column :created_at
          end
        end
      end

      column do
        panel 'Últimos usuários cadastrados' do
          table_for User.order(created_at: :desc).limit(5) do
            column :name
            column :email
            column :created_at
          end
        end
      end
    end

    columns do
      column do
        panel 'Criação de novas empresas' do
          line_chart(Enterprise.group_by_month(:created_at, format: :chart).count)
        end
      end
    end
  end
end
