# frozen_string_literal: true

class RulesController < ApplicationController
  before_action :set_rule, only: %i[show edit update destroy]
  before_action :companies, only: %i[edit new update create]
  before_action :authenticate_account!
  load_and_authorize_resource :company
  # load_and_authorize_resource through: :company

  # GET /rules
  def index
    @rules = Rule.all
  end

  # GET /rules/1
  def show; end

  # GET /rules/new
  def new
    @rule = Rule.new(rule_params)
  end

  # GET /rules/1/edit
  def edit; end

  # POST /rules
  def create
    @rule = Rule.new(rule_params)
    if @rule.save
      redirect_to @rule, notice: 'Rule was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /rules/1
  def update
    if @rule.update(rule_params)
      redirect_to @rule, notice: 'Rule was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /rules/1
  def destroy
    if @rule.destroy
      flash[:notice] = 'You have successfully delete your rule.'
    else
      flash[:error] = "Rule can't be deleted"
    end
    redirect_to rules_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rule
    @rule = Rule.find(params[:id])
  end

  def companies
    @companies = Company.all.order(:name)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def rule_params
    return {} unless params[:rule]
    params.require(:rule).permit(:name, :company_id, :allowance_days, :period, :is_enabled)
  end
end
