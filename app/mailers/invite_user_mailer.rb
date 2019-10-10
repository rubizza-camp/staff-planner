# frozen_string_literal: true

class InviteUserMailer < ApplicationMailer
  default from: 'staffplanner24@gmail.com'
  layout 'mailer'

  def send_invite(email, company)
    byebug
    mail(to: email, subject: 'company')
  end
end
