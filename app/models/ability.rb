class Ability
  include CanCan::Ability
  attr_reader :user

  def initialize(user)
    return unless user

    @user = user
    @user.roles.includes(:unit).find_each do |role|
      next unless user.current_unit == role.unit

      PerUnitAbility.new(self, unit: user.current_unit, user: user).permit(role.kind)
    end

    can([:update, :update_current_unit], User, id: @user.id)
  end

  class PerUnitAbility
    def initialize(ability, unit:, user:)
      @ability = ability
      @unit = unit
      @user = user
    end

    def permit(kind)
      case kind
      when :admin_master
        can(:manage, :all)
      when :coordinator
        coordinator_abilities
      when :viewer
        viewer_abilities
      end
    end

    private

    def can(*args)
      @ability.can(*args)
    end

    def cannot(*args)
      @ability.cannot(*args)
    end

    def coordinator_abilities
      can(
        [:read, :update, :disable, :enable],
        User,
        roles: {
          unit_id: @unit.id, kind_cd: User::Role::USER_KINDS.map(&:to_s)
        }
      )
      can(:create, User)
      can([:read, :update, :destroy], User::Role, unit: @unit, kind_cd: User::Role::USER_KINDS.map(&:to_s))
      can(:create, User::Role, unit: @unit)

      if @unit.kind_pni?
        can([:read, :create], Supply)
        can([:create, :increment_amount], Batch, unit: @unit)
      end

      can([:read, :new_output], Batch, unit: @unit)
      can(:read, Stock, unit: @unit)
    end

    def viewer_abilities
      can(:read, User, roles: { unit_id: @unit.id, kind_cd: User::Role::USER_KINDS.map(&:to_s) })
      can(:read, User::Role, unit: @unit, kind_cd: User::Role::USER_KINDS.map(&:to_s))

      if @unit.kind_pni?
        can(:read, Supply)
      end

      can(:read, Batch, unit: @unit)
      can(:read, Stock, unit: @unit)
    end
  end
end
