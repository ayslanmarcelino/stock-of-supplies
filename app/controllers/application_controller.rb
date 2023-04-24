# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :active_unit?
  before_action :active_user?

  helper_method :disabled?

  rescue_from CanCan::AccessDenied, with: :access_denied

  def active_unit?
    if current_user.present? && disabled?(current_user.person.unit)
      sign_out(current_user)
      redirect_to(new_user_session_path,
                  alert: 'Sua unidade está desativada. Para mais informações, entre em contato com o administrador do sistema.')
    end
  end

  def active_user?
    if current_user.present? && disabled?(current_user)
      sign_out(current_user)
      redirect_to(
        new_user_session_path,
        alert: 'Seu usuário está desativado. Para mais informações, entre em contato com o seu gestor.'
      )
    end
  end

  def access_denied(exception)
    redirect_to(root_path)
    flash[:danger] = exception.message
  end

  def disable!(resource)
    resource.update!(active: false)
  end

  def activate!(resource)
    resource.update!(active: true)
  end

  def disabled?(resource)
    !resource.active?
  end
end
