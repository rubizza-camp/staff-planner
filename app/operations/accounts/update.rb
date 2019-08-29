# frozen_string_literal: true

module Accounts
  class Update
    def call(account, account_params)
      set_avatar(account, params)
      if account.update?(account_params)
        Result::Success.new(event)
      else
        Result::Failure.new(event)
      end
    end

    private

    def set_avatar(account, params)
      account.avatar.purge if @account.avatar.present?
      account.avatar.attach(params[:avatar]) if account_params[:avatar].present?
    end
  end
end
