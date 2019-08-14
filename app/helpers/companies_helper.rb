# frozen_string_literal: true

module CompaniesHelper
  def days_tdstyle(day)
    @style = if @calendar.days_status[day].eql?('work')
               'padding-bottom:0.5em;font-size:14px'
             else
               'padding-bottom:0.5em;background-color:lightgray;font-size:14px'
             end
  end

  def calendar_event(event, day)
    return if event.start_period.strftime('%Y-%m-%d') == day.strftime('%Y-%m-%d')

    @style = 'background-color:#44c9b3;padding-bottom:0.5em;font-size:14px'
    @event = event
  end

  def day_links(day)
    if @style == 'padding-bottom:0.5em;font-size:14px'
      link_to day.strftime('%d'), new_company_event_path(
        company_id: @calendar.company.id,
        event: { start_period: day.strftime('%c') }
      )
    else
      link_to day.strftime('%d'),
              company_event_path(company_id: @calendar.company.id, id: @event.id)
    end
  end
end
