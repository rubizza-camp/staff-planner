# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(account)
    access_to_companies('owner', :manage, account)
    access_to_companies('user', :read, account)

    can :manage, account
    can :manage, WorkingDayDecorator
    can :manage, Event, employee_id: account.employees.pluck(:id)

    can %i[new create], Company
  end

  def access_to_companies(role, access, account)
    company_ids = account.employees.where(role: role).pluck(:company_id)
    return if company_ids.empty?

    can access, Company, id: company_ids
    can :calendar, Company, id: company_ids
    can access, [Employee, WorkingDay, Holiday, Rule, Event], company_id: company_ids
    can %i[new create], Event, company_id: company_ids
  end
end
