class AbilityAdmin
  include CanCan::Ability
  attr_reader :user

  def initialize(user)
    return unless user

    @user = user
    @user.roles.each do |role|
      PerAbility.new(self, user: @user).permit(role.kind)
    end

    can(:read, ActiveAdmin::Page, name: 'Dashboard')
  end

  class PerAbility
    def initialize(ability, user:)
      @ability = ability
      @user = user
    end

    def permit(kind)
      case kind
      when :admin_master
        can(:manage, :all)
      when :admin_support
        can(:manage, [Unit, ActiveAdmin::Comment])
        can(:read, [User, User::Role, Person, Supply, Stock, Movement, Order, Order::Version])
        can(:create, User::Role)
        can([:update, :destroy], User::Role, kind_cd: User::Role::KINDS.map(&:to_s) - ['admin_master'])
      end
    end

    private

    def can(*args)
      @ability.can(*args)
    end

    def cannot(*args)
      @ability.cannot(*args)
    end
  end
end
