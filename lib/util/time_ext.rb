# frozen_string_literal: true

module Util
  #
  # An extended class for time and date
  # @author hubery.cui
  #
  class TimeExt
    class << self
      #
      # Time format to the specified string.
      #
      # @author hubery.cui
      #
      #
      # @param [Time, DateTime, Date] time Time to be formatted
      # @param [Symbol] type specifies the specific format to be converted. The default value is +:date+.
      # There are four options :full, min, date, and year
      # @example
      # ::Util::TimeExt.format_date(Time.now, :full) Converted to "2022-02-13 13:34:34" format
      # ::Util::TimeExt.format_date(Time.now, :min) Converted to "2022-02-13 13:34" format
      # ::Util::TimeExt.format_date(Time.now, :date) Converted to "2022-02-13" format
      # ::Util::TimeExt.format_date(Time.now, :year) Converted to "2022" format
      # @return [String] Returns the converted string.
      #
      def format_date(time, type = :date)
        return nil unless %w[Time Date DateTime].include?(time.class.name)

        case type
        when :full
          time.strftime('%Y-%m-%d %H:%M:%S')
        when :min
          time.strftime('%Y-%m-%d %H:%M')
        when :date
          time.strftime('%Y-%m-%d')
        when :year
          time.strftime('%Y')
        end
      end
    end
  end
end
