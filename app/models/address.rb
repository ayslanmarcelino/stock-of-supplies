# == Schema Information
#
# Table name: addresses
#
#  id           :bigint           not null, primary key
#  city         :string
#  complement   :string
#  country      :string
#  neighborhood :string
#  number       :integer
#  state        :string
#  street       :string
#  zip_code     :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Address < ApplicationRecord
  STATES = [:AC, :AL, :AM, :AP, :BA, :CE, :DF, :ES, :GO, :MA, :MG, :MS, :MT, :PA,
            :PB, :PE, :PI, :PR, :RJ, :RN, :RS, :RO, :RR, :SC, :SE, :SP, :TO].freeze
  COUNTRIES = [:Brasil].freeze

  def self.permitted_params
    [
      :id,
      :street,
      :number,
      :neighborhood,
      :city,
      :state,
      :zip_code,
      :country,
      :complement
    ]
  end
end
