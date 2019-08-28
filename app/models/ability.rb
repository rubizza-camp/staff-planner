# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(account)
    access_to_companies('owner', :manage, account)
    access_to_companies('employee', :read, account)
    access_to_events(account)

    can :manage, account
    can :manage, WorkingDayDecorator
    can %i[new create], Company
  end

  def access_to_companies(role, access, account)
    company_ids = account.employees.where(role: role).pluck(:company_id)
    return if company_ids.empty?

    can access, Company, id: company_ids
    can %i[employee_events calendar], Company, id: company_ids
    can access, [Employee, WorkingDay, Holiday, Rule], company_id: company_ids
    can %i[new create], Event, company_id: company_ids
  end

  def access_to_events(account)
    can %i[index edit update destroy], Event,
        employee_id: account.employees.pluck(:id),
        aasm_state: 'pending'
    can %i[accept decline], Event,
        company_id: account.companies.where(employees: { role: 'owner' }).pluck(:id),
        aasm_state: 'pending'
  end
end
