class UserPolicy < ApplicationPolicy
  attr_reader :current_user, :user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end
  def become?
    current_user.admin?
  end

  def index?
    current_user.admin?
  end

  def show?
    current_user.admin? or current_user.calnet == user.calnet
  end
end
