# frozen_string_literal: true

require_relative "errors/spec_error"

module Sheetah
  class Specification
    class InvalidPatternError < Errors::SpecError
    end

    class MutablePatternError < Errors::SpecError
    end

    class DuplicatedPatternError < Errors::SpecError
    end

    def initialize
      @column_by_pattern = {}
    end

    def set(pattern, column)
      if pattern.nil?
        raise InvalidPatternError, pattern.inspect
      end

      unless pattern.frozen?
        raise MutablePatternError, pattern.inspect
      end

      if @column_by_pattern.key?(pattern)
        raise DuplicatedPatternError, pattern.inspect
      end

      @column_by_pattern[pattern] = column
    end

    def get(header)
      return if header.nil?

      @column_by_pattern.each do |pattern, column|
        if (pattern == header) || (pattern.is_a?(Regexp) && pattern.match?(header))
          return column
        end
      end

      nil
    end

    def freeze
      @column_by_pattern.freeze
      super
    end
  end
end