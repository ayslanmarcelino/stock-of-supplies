# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    load_and_authorize_resource
    before_action :unit, only: [:show, :disable]
    before_action :user, only: [:edit, :update]
    before_action :verify_password, only: [:update]

    def index
      @query = User.includes(:person)
                   .joins(:roles)
                   .order(created_at: :desc)
                   .accessible_by(current_ability)
                   .page(params[:page])
                   .ransack(params[:q])

      @users = @query.result(distinct: true)
    end

    def show; end

    def new
      @user = User.new
      @user.build_person
      @user.person.build_address
    end

    def create
      @user = User.new(create_params)
      @user.person.owner = @user
      @user.person.unit_id = current_user.current_unit.id

      if @user.save
        UserMailer.with(user: @user).new_user.deliver_now

        redirect_success(path: admin_users_path, action: 'criado')
      else
        render(:new, status: :unprocessable_entity)
      end
    end

    def edit; end

    def update
      if @user.update(user_params.except(:email))
        redirect_success(path: admin_users_path, action: 'atualizado')
      else
        render(:edit, status: :unprocessable_entity)
      end
    end

    def disable
      if @user.active?
        disable!(@user)
        redirect_success(path: admin_users_path, action: 'desativado')
      else
        redirect_failed(path: admin_users_path, action: 'desativado')
      end
    end

    def enable
      if disabled?(@user)
        enable!(@user)
        redirect_success(path: admin_users_path, action: 'ativado')
      else
        redirect_failed(path: admin_users_path, action: 'ativado')
      end
    end

    def update_current_unit
      current_user.update(current_unit_id: params[:change_unit][:id])
      redirect_to(root_path)
      flash[:success] = "Agora você está acessando a unidade #{current_user.current_unit.name}."
    end

    private

    def user_params
      params.require(:user)
            .permit(
              User.permitted_params,
              person_attributes: [
                Person.permitted_params,
                { address_attributes: Address.permitted_params }
              ]
            )
    end

    def create_params
      user_params.except(
        :password,
        :password_confirmation
      ).merge(
        password: user_params[:email],
        password_confirmation: user_params[:email],
        created_by: current_user
      )
    end

    def redirect_success(path:, action:)
      redirect_to(path)
      flash[:success] = "Usuário(a) #{action}(a) com sucesso."
    end

    def unit
      @unit ||= Unit.where(id: current_user.roles.map(&:unit_id))
    end

    def user
      @user ||= User.find(params[:id])
    end

    def verify_password
      unless params[:user][:password].presence || params[:user][:password_confirmation].presence
        params[:user].extract!(:password, :password_confirmation)
      end
    end
  end
end
