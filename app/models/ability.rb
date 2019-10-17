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

    end_day_today = Date.today.to_datetime.change(hour: Event::END_DAY)
    events_ids = account.events.where('start_period >= ?', end_day_today).ids
    can %i[edit update], Event, id: events_ids
    can %i[new create], Event
    can %i[index], Event, employee_id: employee_ids
    can :access_to_event, Employee, id: employee_ids
  end

  def access_to_events_owner(account)
    companies = account.companies.where(employees: { role: 'owner' }).includes(:employees)
    return if companies.empty?

    companie_ids = companies.map(&:id)
    can :accept, Event, company_id: companie_ids, state: %w[pending declined]
    can :decline, Event, company_id: companie_ids, state: %w[pending accepted]
    can %i[edit update index], Event, company_id: companie_ids
    can :index, Event, company_id: companie_ids
    can :access_to_event, Employee, id: companies.flat_map(&:employee_ids)
  end
end
