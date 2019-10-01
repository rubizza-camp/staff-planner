desc 'send messages to slack'
task messages_to_slack: :environment do
  Slack::SendDailyMessages.new.call
end
