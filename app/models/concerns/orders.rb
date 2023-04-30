module Orders
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm do
      state :pending, initial: true
      state :approved
      state :rejected
      state :delivered
      state :finished

      event :approve, if: :available_stock? do
        transitions from: :pending, to: :approved
      end

      event :reject do
        transitions from: :pending, to: :rejected
      end

      event :deliver, if: :available_stock? do
        transitions from: :approved, to: :delivered
      end

      event :finish, if: :available_stock? do
        transitions from: :delivered, to: :finished
      end
    end
  end

  private

  def available_stock?
    stock.remaining > amount
  end
end
