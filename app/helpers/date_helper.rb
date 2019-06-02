# frozen_string_literal: true

module DateHelper
  def created_at(klass)
    to_date_and_time(klass.created_at)
  end

  def updated_at(klass)
    to_date_and_time(klass.created_at)
  end

  def to_date(int_value)
    Time.at(int_value).strftime('%d.%m.%Y')
  end

  def to_date_and_time(int_value)
    Time.at(int_value).strftime('%d.%m.%Y - %R')
  end
end
