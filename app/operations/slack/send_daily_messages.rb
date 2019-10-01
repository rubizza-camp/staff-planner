# frozen_string_literal: true

module Slack
  class SendDailyMessages
    def call
      slack_notifications.each do |slack_notification|
        text_message = get_text_message(slack_notification.company)
        next if text_message.empty?

        send_message(slack_notification.token, text_message)
      end
    end

    private

    def slack_notifications
      SlackNotification.where(is_enabled: true)
                       .where.not(token: nil)
                       .includes(:company)
    end

    def get_text_message(company)
      text_message = ''
      events = get_events_today(company)
      events.each_with_index do |event, i|
        account = event.employee.account
        rule_name = event.rule.name
        text_message += "#{i + 1}) #{account.surname} #{account.name}. #{rule_name}"
        text_message += ' (pending)' if event.state == 'pending'
        text_message += "\n"
      end
      text_message
    end

    def get_events_today(company)
      date_today = Date.today.to_datetime
      start_period = date_today.change(hour: Event::END_DAY)
      end_period = date_today.change(hour: Event::START_DAY)
      company
        .events
        .where('start_period <= ? and end_period >= ?', start_period, end_period)
        .where(state: %i[accepted pending])
        .includes(:rule, employee: :account)
    end

    def send_message(token, text_message)
      client = Slack::Notifier.new token
      client.ping text_message
    rescue StandardError => e
      p e
    end
  end
end
