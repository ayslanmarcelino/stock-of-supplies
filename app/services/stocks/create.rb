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
        expiration_date: @params.expiration_date,
        unit: @unit,
        reason: @reason,
        kind: @kind,
        source: @params
      )
    end
  end
end
