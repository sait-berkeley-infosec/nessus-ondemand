class UserPolicy < ApplicationPolicy
  def become?
    user.admin?
  end

  def index?
    user.admin?
  end

  def show?
    user.admin?
  end
end
