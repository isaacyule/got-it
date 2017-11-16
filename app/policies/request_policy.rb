class RequestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    if user
      !user.products.include?(record.product)
    end
  end

  def update?
    user.products.include?(record.product)
  end

end
