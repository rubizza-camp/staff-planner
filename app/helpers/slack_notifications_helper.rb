# frozen_string_literal: true

module SlackNotificationsHelper
  def link_to_slack_notification(company)
    return edit_slack_notification_path if company.slack_notification&.persisted?

    new_slack_notification_path
  end
end
