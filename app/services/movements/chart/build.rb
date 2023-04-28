module Movements
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
        supplies_by_movement.each do |supply|
          @labels << supply.name
          @values << input_amount(supply.id) - output_amount(supply.id)
        end
      end

      def output_amount(supply_id)
        output_values[supply_id]&.sum(&:amount) || 0
      end

      def input_amount(supply_id)
        input_values[supply_id]&.sum(&:amount) || 0
      end

      def supplies_by_movement
        @supplies_by_movement ||= Supply.where(id: unit_movement.pluck(:supply_id).uniq).order(:name)
      end

      def output_values
        @output_values ||= unit_movement.kind_outputs.group_by(&:supply_id)
      end

      def input_values
        @input_values ||= unit_movement.kind_inputs.group_by(&:supply_id)
      end

      def unit_movement
        @unit_movement ||= Movement.where(unit: @user.current_unit)
      end
    end
  end
end
