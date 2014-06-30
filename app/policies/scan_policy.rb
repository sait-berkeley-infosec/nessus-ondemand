class ScanPolicy < ApplicationPolicy
  def edit?
    user.admin? or record.user == user.calnet
  end
end
