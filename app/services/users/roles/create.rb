module Users
  module Roles
    class Create < ApplicationService
      def initialize(params:, unit:)
        @params = params
        @unit = unit
      end

      def call
        create!
      end

      private

      def create!
        person
        user
        create_user_role!
      end

      def person
        @person ||= People::Create.call(params: @params, unit: @unit)
      end

      def user
        @user ||= Users::Create.call(params: @params, person: @person, unit: @unit)
      end

      def create_user_role!
        @role ||= User::Role.create(
          kind_cd: :coordinator,
          unit_id: @unit.id,
          user_id: @user.id
        )

        @role.save
      end
    end
  end
end
