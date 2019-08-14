# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    companies_with_role_owner = user.employees.where(role: 'owner').pluck(:company_id)
    if companies_with_role_owner.size.positive?
      can :manage, Company, id: companies_with_role_owner
      can :manage, [Employee, WorkingDay], company_id: companies_with_role_owner
    end
    companies_with_role_user = user.employees.where(role: 'user').pluck(:company_id)
    if companies_with_role_user.size.positive?
      can :read, Company, id: companies_with_role_user
      can :read, [Employee, WorkingDay], company_id: companies_with_role_user
    end
    can :manage, WorkingDayDecorator
    byebug
  end
end
