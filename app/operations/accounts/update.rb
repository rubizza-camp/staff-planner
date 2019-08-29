# frozen_string_literal: true

module Accounts
  class Update
    def call(account, params)
      set_avatar(account, params[:avatar])
      if account.update(account_params(params))
        Result::Success.new(account)
      else
        Result::Failure.new(account)
      end
    end

    private

    def account_params(params)
      params.require(:account)
            .permit(:name,
                    :surname,
                    :email,
                    :password,
                    :date_of_birth,
                    :avatar)
    end

    def set_avatar(account, avatar)
      account.avatar.purge if account.avatar.present?
      account.avatar.attach(avatar) if avatar.present?
    end
  end
end
