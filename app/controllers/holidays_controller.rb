# frozen_string_literal: true

class HolidaysController < ApplicationController
  before_action :set_company
  before_action :set_holiday, only: %i[show edit update destroy]
  load_and_authorize_resource :company

  def index
    @holidays = @company.holidays.order(:name).page params[:page]

    @countries = ISO3166::Country.countries.sort_by(&:name)
    @countries = @countries.collect { |c| ["#{c.name} #{c.emoji_flag}, #{c.gec}", c.gec] }
  end

  def show; end

  def new
    @holiday = @company.holidays.build
  end

  def edit; end

  def create
    @holiday = @company.holidays.build(holiday_params)

    if @holiday.save
      redirect_to company_holidays_url, notice: 'Holiday was successfully created.'
    else
      render :new
    end
  end

  def update
    if @holiday.update(holiday_params)
      redirect_to company_holidays_url, notice: 'Holiday was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @holiday.destroy
      flash[:notice] = 'You have successfully delete holiday.'
    else
      flash[:error] = "Holiday can't be deleted"
    end
    redirect_to company_holidays_url
  end

  def calendarific_import
    token = Rails.application.secrets.token_calendarific

    uri = URI("https://calendarific.com/api/v2/holidays?&api_key=#{token}&country=#{params[:country]}&year=#{params[:year]}")
    parsed_country = JSON.parse(Net::HTTP.get(uri))

    pparsed_country.dig('response', 'holidays').each do |holiday|
      @holiday = @company.holidays.build(name: holiday['name'], date: holiday.dig('date', 'iso'))
      @holiday.save
    end

    redirect_to company_holidays_url, notice: 'Holidays was successfully created.'
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_holiday
    @holiday = @company.holidays.find_by!(id: params[:id])
  end

  def holiday_params
    params.require(:holiday).permit(:name, :date)
  end
end
