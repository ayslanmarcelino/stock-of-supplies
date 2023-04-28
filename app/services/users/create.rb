module Users
  class Create < ApplicationService
    def initialize(params:, person:, unit:)
      @params = params
      @person = person
      @unit = unit
    end

    def call
      find
      create!
      send_mail
      update_person!
      user
    end

    private

    def find
      @find ||= Users::Find.call(email: @params[:email])
    end

    def create!
      return @find if @find.present?

      @user ||= User.create(
        email: @params[:email],
        password: @params[:email],
        password_confirmation: @params[:email],
        person_id: @person.id,
        current_unit_id: @unit.id,
        created_by: @unit.created_by
      )
      @user.save
    end

    def send_mail
      return if @find.present?

      UserMailer.with(user: @user).new_user.deliver_later
    end

    def update_person!
      return if @find.present?

      @person.update(owner: @user)
    end

    def user
      @find.presence || @user
    end
  end
end
