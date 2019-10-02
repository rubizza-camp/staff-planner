# frozen_string_literal: true

module Slack
  class SendDailyMessages
    def call
      companies_events.each do |company, events|
        send_message(company.slack_notification.token, text_message(events))
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
           .group_by(&:company)
    end

    def text_message(events)
      text_message = ''
      events.each_with_index do |event, i|
        text_message += "#{i + 1}) #{event.account.full_name}. #{event.rule.name}"
        text_message += ' (pending)' if event.state == 'pending'
        text_message += "\n"
      end
      text_message
    end

    def send_message(token, text_message)
      client = Slack::Notifier.new(token)
      client.ping(text_message)
    rescue StandardError => e
      p e
    end
  end
end
