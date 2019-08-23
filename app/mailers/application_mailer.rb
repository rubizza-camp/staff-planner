# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'staffplanner24@gmail.com'
  layout 'mailer'

  def event_email(company, event, current_account)
    @params = create_email_params(company, event, current_account)
    mail(to: @params[:owners_email], subject: "#{@params[:company]} event from #{@params[:created_by]}")
  end

  private

  def create_email_params(company, event, current_account)
    {
      company: company.name,
      event: event,
      owners_email: company.accounts.where(employees: { role: 'owner' }).pluck(:email),
      created_by: "#{current_account.name} #{current_account.surname}",
      rule_name: Rule.find(event.rule_id).name,
      event_link: link_to_events(company, event),
      remaining_days: RemainingDaysService.new.call(event.employee_id, event.rule_id)
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
