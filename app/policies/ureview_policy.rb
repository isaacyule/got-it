class UreviewPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def new?
    user.requests.include?(record.request) && record.request.status == "Accepted"
  end

  def create?
    user.requests.include?(record.request) && record.request.status == "Accepted"
  end
end
