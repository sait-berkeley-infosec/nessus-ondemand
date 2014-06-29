class ScanPolicy < ApplicationPolicy
  def update?
    user.admin? or scan.user == user.calnet
  end

  def destroy?
    user.admin?
  end
end
