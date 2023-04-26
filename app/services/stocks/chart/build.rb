module Stocks
  module Chart
    class Build < ApplicationService
      def initialize(user:)
        @user = user
        @labels = []
        @values = []
      end

      def call
        build_data
      end

      private

      def build_data
        feed_arrays

        {
          labels: @labels,
          values: @values
        }
      end

      def feed_arrays
        supplies_by_stock.each do |supply|
          input_amount = input_values[supply.id]&.sum(&:amount) || 0
          output_amount = output_values[supply.id]&.sum(&:amount) || 0

          @labels << supply.name
          @values << input_amount - output_amount
        end
      end

      def supplies_by_stock
        @supplies_by_stock ||= Supply.where(id: unit_stock.pluck(:supply_id).uniq).order(:name)
      end

      def output_values
        @output_values ||= unit_stock.kind_outputs.group_by(&:supply_id)
      end

      def input_values
        @input_values ||= unit_stock.kind_inputs.group_by(&:supply_id)
      end

      def unit_stock
        @unit_stock ||= Stock.where(unit: @user.current_unit)
      end
    end
  end
end
