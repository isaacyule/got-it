class OmniauthCallbackPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def facebook?
    true
  end
end
