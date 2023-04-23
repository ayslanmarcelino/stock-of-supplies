class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def formatted(document_number)
    case document_number.size
    when 11
      CPF.new(document_number).formatted
    when 14
      CNPJ.new(document_number).formatted
    end
  end
end
