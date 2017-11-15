class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    record == user
  end

  def destroy?
    record == user
  end

#   private

#   def user_is_owner_or_admin?
#     record == user || user.admin
#   end
end

