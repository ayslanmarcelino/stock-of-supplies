module Users
  class Find < ApplicationService
    def initialize(email:)
      @email = email
    end

    def call
      find
    end

    private

    def find
      User.find_by(email: @email)
    end
  end
end
