class RewardPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def show?
    record.user.family == user.family
  end

  def update?
    true
  end

  def create?
    true
  end
end