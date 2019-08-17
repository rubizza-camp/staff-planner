# frozen_string_literal: true

module Companies
  class Create
    def call(company_params, current_account)
      company = Company.new(company_params)
      ActiveRecord::Base.transaction do
        company.save!
        create_employee(current_account, company)
        Result::Success.new(company)
      end
    rescue ActiveRecord::RecordInvalid => e
      Result::Failure.new(company, e.message)
    end

    def create_employee(current_account, company)
      Employee.create!(
        start_day: Date.today,
        position: 'director',
        is_enabled: true,
        account_id: current_account.id,
        company_id: company.id,
        role: 'owner'
      )
    end
  end
end
