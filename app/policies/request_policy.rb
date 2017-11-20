class RequestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    record.product.user != user
  end

  def update?
    user.products.include?(record.product)
  end

end
