module ApplicationHelper
  def active?(status)
    status ? 'success' : 'danger'
  end

  def swal_type(type)
    case type
    when 'success', 'notice' then 'success'
    when 'alert' then 'warning'
    when 'danger', 'error', 'denied' then 'error'
    when 'question' then 'question'
    else 'info'
    end
  end

  def units
    @units ||= current_user.roles.map(&:unit)
  end

  def abbreviation(word)
    word.split.map(&:first).join.upcase
  end

  def formatted(document_number)
    case document_number.size
    when 11
      CPF.new(document_number).formatted
    when 14
      CNPJ.new(document_number).formatted
    end
  end

  def not_persisted_action?
    ['new', 'create'].include?(action_name)
  end

  def users_collection
    users = []
    query = User.includes(:person).where(person: { unit: current_user.current_unit })

    query.each do |user|
      users << ["#{user.person.name} | #{user.email}", user.id]
    end

    users.sort
  end

  def kind_class(kind)
    case kind
    when :input
      'success'
    when :output
      'danger'
    end
  end

  def kind_icon(kind)
    case kind
    when :input
      'right'
    when :output
      'left'
    end
  end

  def status_class(status)
    status_map = {
      pending: 'warning',
      rejected: 'danger',
      approved: 'success',
      delivered: 'info',
      finished: 'primary'
    }

    status_map[status.to_sym] || ''
  end

  def movement_reason_collection
    Movement.all.map(&:reason).uniq.sort
  end

  def current_stock_collection
    stocks = []

    current_user.current_unit.stocks.each do |stock|
      stocks << [stock.identifier, stock.id]
    end

    stocks.sort
  end

  def supply_collection
    Supply.all.map(&:name).sort
  end

  def current_role_kind
    current_user.roles.find_by(unit: current_user.current_unit).kind
  end

  def can_access_admin?
    User::Role::ADMIN_KINDS.include?(current_role_kind) || current_user.roles.kind_coordinators.any?
  end
end
