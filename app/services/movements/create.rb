module Movements
  class Create < ApplicationService
    def initialize(params:, reason:, kind:, batch:, current_user:, amount: nil, arrived_date: nil)
      @params = params
      @reason = reason
      @kind = kind
      @batch = batch
      @current_user = current_user
      @amount = amount
      @arrived_date = arrived_date
    end

    def call
      create!
    end

    private

    def create!
      return if amount.to_i <= 0

      Movement.create!(
        created_by: @current_user,
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
