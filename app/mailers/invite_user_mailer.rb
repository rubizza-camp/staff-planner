# frozen_string_literal: true

class InviteUserMailer < ApplicationMailer
  default from: 'staffplanner24@gmail.com'
  layout 'mailer'

  def send_email(email, company)
    mail(to: email, subject: 'Invite to work') do |body|
      body.html do
        "<p>The company #{company.name} invites you to work. Follow the link</p>
         <p><a href=#{new_account_registration_url(account: { email: email })}>Go to Staff-planner</a></p>"
      end
    end
  end
end
