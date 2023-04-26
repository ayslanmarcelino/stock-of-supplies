module Stocks
  class Create < ApplicationService
    def initialize(params:, reason:, kind:)
      @params = params
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
        unit: @params.unit,
        expiration_date: @params.expiration_date,
        reason: @reason,
        kind: @kind,
        source: @params
      )
    end
  end
end
