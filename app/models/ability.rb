# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(account)
    companies_with_role_owner = account.employees.where(role: 'owner').pluck(:company_id)
    if companies_with_role_owner.size.positive?
      can :manage, Company, id: companies_with_role_owner
      can :manage, [Employee, WorkingDay], company_id: companies_with_role_owner
    end

    companies_with_role_user = account.employees.where(role: 'user').pluck(:company_id)
    if companies_with_role_user.size.positive?
      can :read, Company, id: companies_with_role_user
      can :read, [Employee, WorkingDay], company_id: companies_with_role_user
    end
    can :manage, WorkingDayDecorator
    can %i[new create], Company
  end
end
