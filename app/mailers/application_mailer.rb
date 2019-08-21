# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'staffplanner24@gmail.com'
  layout 'mailer'

  def welcome_email
    mail(to: 'richkovevgeniy@mail.ru', subject: 'test')
  end
end
