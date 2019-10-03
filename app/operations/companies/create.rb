# frozen_string_literal: true

module Companies
  class Create
    def call(company_params, current_account_id)
      company = Company.new(company_params)
      ActiveRecord::Base.transaction do
        company.save!
        create_employee(current_account_id, company)
        create_working_days(company)
        Result::Success.new(company)
      end
    rescue ActiveRecord::RecordInvalid => e
      Result::Failure.new(company, e.message)
    end

    def create_employee(current_account_id, company)
      Employee.create!(
        start_day: Date.today,
        position: 'director',
        is_enabled: true,
        account_id: current_account_id,
        company_id: company.id,
        role: 'owner'
      )
    end

    def create_working_days(company)
      (1..5).each do |day_of_week|
        WorkingDay.create!(company_id: company.id, day_of_week: day_of_week)
      end
    end
  end
end
