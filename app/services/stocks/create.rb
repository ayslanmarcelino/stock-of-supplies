module Stocks
  class Create < ApplicationService
    def initialize(params:, unit:, reason:, kind:)
      @params = params
      @unit = unit
      @reason = reason
      @kind = kind
    end

    def call
      create!
    end

    private

    def create!
      Stock.create!(
        created_by: @params.created_by,
        supply: @params.supply,
        amount: @params.amount,
        unit: @unit,
        reason: @reason,
        kind: @kind
      )
    end
  end
end
