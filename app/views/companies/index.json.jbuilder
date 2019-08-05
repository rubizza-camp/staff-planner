# frozen_string_literal: true

json.array! @companies, partial: 'companies/company', as: :company
