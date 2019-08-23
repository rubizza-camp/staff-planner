# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  user_name: 'staffplanner24@gmail.com',
  password: 'StaffPlanner123456',
  domain: 'mydomain.com',
  address: 'smtp.gmail.com',
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}
