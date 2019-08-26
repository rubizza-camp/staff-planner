# frozen_string_literal: true

module HolidaysHelper
  def countries_for_select
    countries = ISO3166::Country.countries.sort_by(&:name)
    countries.collect { |c| ["#{c.name} #{c.emoji_flag}, #{c.gec}", c.gec] }
  end
end
