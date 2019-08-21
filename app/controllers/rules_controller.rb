# frozen_string_literal: true

class RulesController < ApplicationController
  before_action :set_company
  before_action :set_rule, only: %i[show edit update destroy]
  before_action :companies, only: %i[edit new update create]
  before_action :authenticate_account!
  load_and_authorize_resource :company
  load_and_authorize_resource through: :company

  # GET /rules
  def index
    @rules = @company.rules
  end

  # GET /rules/1
  def show; end

  # GET /rules/new
  def new
    @rule =  @company.rules.build
  end

  # GET /rules/1/edit
  def edit; end

  # POST /rules
  def create
    @rule = @company.rules.build(rule_params)
    if @rule.save
      redirect_to company_rules_path, notice: 'Rule was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /rules/1
  def update
    if @rule.update(rule_params)
      redirect_to company_rules_url, notice: 'Rule was successfully updated.'
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
    redirect_to company_rules_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rule
    @rule = @company.rules.find(params[:id])
  end

  def companies
    @companies = Company.all.order(:name)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def rule_params
    params.require(:rule).permit(:name, :allowance_days, :period, :is_enabled)
  end

  def set_company
    @company = Company.find(params[:company_id])
  end
end
