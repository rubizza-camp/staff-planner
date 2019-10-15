# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(account)
    access_to_companies('owner', :manage, account)
    access_to_companies('employee', :read, account)
    access_to_events_employee(account)
    access_to_events_owner(account)

    can :manage, account
    can :manage, WorkingDayDecorator
    can %i[new create], Company
  end

  def access_to_companies(role, access, account)
    company_ids = account.employees.where(role: role).pluck(:company_id)
    return if company_ids.empty?

    can access, Company, id: company_ids
    can :calendar, Company, id: company_ids
    can access, [Employee, WorkingDay, Holiday, Rule, SlackNotification], company_id: company_ids
  end

  def access_to_events_employee(account)
    employee_ids = account.employees.ids
    return if employee_ids.empty?

    can %i[edit update destroy], Event, employee_id: employee_ids, state: 'pending'
    can %i[new create], Event
    can %i[index], Event, employee_id: employee_ids
    can :access_to_event, Employee, id: employee_ids
  end

  def access_to_events_owner(account)
    companies = account.companies.where(employees: { role: 'owner' }).includes(:employees)
    return if companies.empty?

    can %i[accept decline index], Event, company_id: companies.map(&:id), state: 'pending'
    can :index, Event, company_id: companies.map(&:id)
    can :access_to_event, Employee, id: companies.flat_map(&:employee_ids)
  end
end
