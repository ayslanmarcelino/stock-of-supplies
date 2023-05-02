# frozen_string_literal: true

ActiveAdmin.register_page("Dashboard") do
  menu priority: 1

  content do
    columns do
      column do
        panel 'Suprimentos nas unidades' do
          pie_chart(Stock.joins(:supply).group('supplies.name').sum(:remaining), donut: true)
        end
      end
      column do
        panel 'Quantidade de suprimentos utilizados' do
          column_chart(
            Movement.joins(:stock, :supply)
                    .kind_outputs
                    .where(reason: 'Utilizado em pacientes')
                    .group('supplies.name')
                    .group_by_month(:created_at, format: :chart)
                    .sum(:amount)
          )
        end
      end
    end

    columns do
      column do
        panel 'Lotes à vencer nos próximos 12 meses' do
          column_chart(
            Stock.joins(:supply)
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
