class AbilityAdmin
  include CanCan::Ability
  attr_reader :user

  def initialize(user)
    return unless user

    @user = user
    @user.roles.each do |role|
      PerAbility.new(self, user: @user).permit(role.kind)
    end
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
