# frozen_string_literal: true

class SlackNotificationsController < ApplicationController
  before_action :set_slack_notification, only: %i[edit update]
  before_action :authenticate_account!
  load_and_authorize_resource :company
  load_and_authorize_resource through: :company, singleton: true

  def new
    @slack_notification = @company.build_slack_notification
  end

  def create
    @slack_notification = @company.build_slack_notification(slack_notification_params)
    if @slack_notification.save
      redirect_to company_path(@company), notice: 'Slack notifications was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @slack_notification.update(slack_notification_params)
      redirect_to @company, notice: 'Company was successfully updated.'
    else
      render :edit
    end
  end

  private

  def slack_notification_params
    params.require(:slack_notification).permit(:token, :is_enabled)
  end

  def set_slack_notification
    @slack_notification = @company.slack_notification
  end
end
