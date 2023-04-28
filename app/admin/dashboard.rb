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
            column :name do |user|
              user.person&.name
            end
            column :cns_number do |user|
              user.person&.cns_number
            end
            column :email
            column :created_at
          end
        end
      end
    end

    columns do
      column do
        panel 'Suprimentos nas unidades' do
          pie_chart(Batch.joins(:supply).group('supplies.name').sum(:remaining), donut: true)
        end
      end
      column do
        panel 'Quantidade de suprimentos à vencer nos próximos 12 meses' do
          column_chart(
            Batch.joins(:supply)
                 .group("identifier || ' - ' || supplies.name")
                 .where('expiration_date >= ? AND expiration_date <= ?', Date.current, Date.current + 1.year)
                 .group_by_month(:expiration_date, format: :chart)
                 .sum(:remaining)
          )
        end
      end
    end
  end
end
