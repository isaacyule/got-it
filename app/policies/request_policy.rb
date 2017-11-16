class RequestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    !user.products.include?(record.product)
  end

  def update?
    user.products.include?(record.product)
  end

end
