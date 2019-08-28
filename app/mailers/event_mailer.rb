# frozen_string_literal: true

class EventMailer < ApplicationMailer
  default from: 'staffplanner24@gmail.com'
  layout 'mailer'

  def send_email(company, event, current_account)
    return if company.nil?
    return if event.nil?
    return if current_account.nil?

    @params = create_email_params(company, event, current_account)
    mail(to: @params[:owners_emails], subject: "#{@params[:company]} event from #{@params[:created_by]}")
  end

  private

  def create_email_params(company, event, current_account)
    {
      company: company.name,
      event: event,
      owners_emails: company.accounts.where(employees: { role: 'owner' }).pluck(:email),
      created_by: "#{current_account.name} #{current_account.surname}",
      rule_name: event.rule.name,
      event_link: link_to_events(company, event),
      remaining_days: Events::RemainingDaysService.new.call(event.employee, event.rule)
    }
  end

  def link_to_events(company, event)
    company_employee_events_url(
      company_id: company.id,
      employee: event.employee_id,
      day: event.start_period
    )
  end
end
