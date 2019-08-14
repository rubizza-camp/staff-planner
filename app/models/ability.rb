# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(account)
    access_to_companies('owner', :manage, account)
    access_to_companies('user', :read, account)

    can :manage, WorkingDayDecorator
    can %i[new create], Company
  end

  def access_to_companies(role, access, account)
    companies = account.employees.where(role: role).pluck(:company_id)
    return unless companies.size.positive?

    can access, Company, id: companies
    can access, [Employee, WorkingDay], company_id: companies
  end
end
