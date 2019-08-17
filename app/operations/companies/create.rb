# frozen_string_literal: true

module Companies
  class Create
    def call(company_params, current_account)
      company = Company.new(company_params)
      ActiveRecord::Base.transaction do
        company.save!
        Employee.create!(
          start_day: Date.today,
          position: 'director',
          is_enabled: true,
          account_id: current_account.id,
          company_id: company.id,
          role: 'owner'
        )
        Result::Success.new(company)
      end
    rescue ActiveRecord::RecordInvalid => exception
      Result::Failure.new(company, exception.message)
    end
  end
end
