module Stocks
  class Create < ApplicationService
    def initialize(params:, reason:, kind:, batch:, amount: nil, arrived_date: nil)
      @params = params
      @reason = reason
      @kind = kind
      @amount = amount
      @arrived_date = arrived_date
      @batch = batch
    end

    def call
      create!
    end

    private

    def create!
      Stock.create!(
        created_by: @params.created_by,
        supply: @params.supply,
        amount: amount,
        unit: @params.unit,
        expiration_date: @params.expiration_date,
        occurrence_date: occurrence_date,
        reason: @reason,
        kind: @kind,
        source: @params,
        batch: @batch
      )
    end

    def amount
      @amount.presence || @params.amount
    end

    def occurrence_date
      @arrived_date.presence || @params.arrived_date
    end
  end
end
