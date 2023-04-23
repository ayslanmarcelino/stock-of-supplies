module People
  class Create < ApplicationService
    def initialize(params:, enterprise:)
      @params = params
      @enterprise = enterprise
    end

    def call
      person
      create!
    end

    private

    def create!
      return @person if @person.present?

      @person ||= Person.create(
        document_number: @params[:representative_document_number],
        name: @params[:representative_name],
        birth_date: @params[:birth_date],
        cell_number: @params[:cell_number],
        telephone_number: @params[:telephone_number],
        identity_document_issuing_agency: @params[:identity_document_issuing_agency],
        identity_document_number: @params[:identity_document_number],
        identity_document_type: @params[:identity_document_type],
        enterprise_id: @enterprise.id
      )

      @person.build_address
      @person.save
      @person
    end

    def person
      @person ||= People::Find.call(document_number: @params[:representative_document_number])
    end
  end
end
