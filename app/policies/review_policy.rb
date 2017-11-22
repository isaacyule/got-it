class ReviewPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def new?
    user.requests.include?(record.request)
  end

  def create?
    user.requests.include?(record.request)
  end
end
