module People
  class Find < ApplicationService
    def initialize(document_number:)
      @document_number = document_number
    end

    def call
      find
    end

    private

    def find
      Person.find_by(
        document_number: @document_number
      )
    end
  end
end
