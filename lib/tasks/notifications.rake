namespace :notifications do
  desc 'send daily messages to slack'
  task daily_messages_to_slack: :environment do
    Slack::SendDailyMessages.new.call
  end
end
