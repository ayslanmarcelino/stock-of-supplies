class User::RolesController < ApplicationController
  load_and_authorize_resource

  before_action :role, only: [:edit, :destroy]
  before_action :units, only: [:new, :create, :edit]
  before_action :users, only: [:new, :create, :edit]

  def index
    @query = User::Role.includes(user: :person)
                       .order(created_at: :desc)
                       .accessible_by(current_ability)
                       .page(params[:page])
                       .ransack(params[:q])

    @user_roles = @query.result(distinct: false)
  end

  def new
    @role = User::Role.new
  end

  def create
    @role = User::Role.new(role_params)
    @role.unit_id = unit_id if role.unit_id.blank?

    if @role.save
      @role.user.update(current_unit_id: @role.unit_id)

      redirect_success(path: user_roles_path, action: 'criada')
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def edit; end

  def update
    if @role.update(role_params)
      redirect_success(path: user_roles_path, action: 'atualizada')
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  def destroy
    if @role.destroy
      redirect_success(path: user_roles_path, action: 'excluída')
    else
      render(:index, status: :unprocessable_entity)
    end
  end

  private

  def role
    @role ||= User::Role.find(params[:id])
  end

  def units
    @units ||= Unit.where(id: current_user.current_unit)
  end

  def users
    @users ||= User.includes(:person).where(person: { unit_id: current_user.person.unit_id })
  end

  def role_params
    params.require(:user_role)
          .permit(User::Role.permitted_params)
  end

  def unit_id
    params[:user_role][:unit_id].presence || current_user.current_unit.id
  end

  def redirect_success(path:, action:)
    redirect_to(path)
    flash[:success] = "Regra de usuário #{action} com sucesso."
  end
end
