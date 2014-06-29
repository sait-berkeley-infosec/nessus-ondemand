class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    scope.where(:user => user.calnet).exists?
  end

  def show?
    scope.where(:user => user.calnet).exists?
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    scope.where(:user => user.calnet).exists?
  end

  def edit?
    update?
  end

  def destroy?
    user.admin?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end
end

