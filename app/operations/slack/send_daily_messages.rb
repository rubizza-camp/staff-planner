# frozen_string_literal: true

module Slack
  class SendDailyMessages
    def call
      companies_events.each do |companie_events|
        company, events = companie_events
        text_message = make_text_message(events)
        next if text_message.empty?

        send_message(company.slack_notification.token, text_message)
      end
    end

    private

    def companies_events
      date_today = Date.today.to_datetime
      start_period = date_today.change(hour: Event::END_DAY)
      end_period = date_today.change(hour: Event::START_DAY)
      Event.includes(:rule, company: :slack_notification, employee: :account)
           .where('start_period <= ? and end_period >= ?', start_period, end_period)
           .where(state: %i[accepted pending])
           .where(companies: { slack_notifications: { is_enabled: true } })
           .where.not(companies: { slack_notifications: { token: nil } })
           .group_by(&:company)
    end

    def make_text_message(events)
      text_message = ''
      events.each_with_index do |event, i|
        account = event.employee.account
        rule_name = event.rule.name
        text_message += "#{i + 1}) #{account.surname} #{account.name}. #{rule_name}"
        text_message += ' (pending)' if event.state == 'pending'
        text_message += "\n"
      end
      text_message
    end

    def send_message(token, text_message)
      client = Slack::Notifier.new token
      client.ping text_message
    rescue StandardError => e
      p e
    end
  end
end
