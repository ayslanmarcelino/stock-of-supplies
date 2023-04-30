module Orders
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm do
      state :pending, initial: true
      state :approved
      state :rejected
      state :delivered

      event :approve do
        transitions from: :pending, to: :approved
      end

      event :reject do
        transitions from: :pending, to: :rejected
      end

      event :deliver do
        transitions from: :approved, to: :delivered
      end
    end
  end
end
