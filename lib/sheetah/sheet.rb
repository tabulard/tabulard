# frozen_string_literal: true

require_relative "sheet/col_converter"
require_relative "errors/error"
require_relative "messaging/messenger"
require_relative "messaging/message_variant"
require_relative "utils/monadic_result"

module Sheetah
  module Sheet
    def self.included(mod)
      mod.extend(ClassMethods)
    end

    def self.col2int(...)
      COL_CONVERTER.col2int(...)
    end

    def self.int2col(...)
      COL_CONVERTER.int2col(...)
    end

    module ClassMethods
      def open(*args, **opts)
        sheet = new(*args, **opts)
        return Utils::MonadicResult::Success.new(sheet) unless block_given?

        begin
          yield sheet
        ensure
          sheet.close
        end
      rescue InputError
        Utils::MonadicResult::Failure.new
      end
    end

    class Error < Errors::Error
    end

    class InputError < Error
    end

    Message = Messaging::MessageVariant

    class Header
      def initialize(col:, value:)
        @col = col
        @value = value
      end

      attr_reader :col, :value

      def ==(other)
        other.is_a?(self.class) && col == other.col && value == other.value
      end

      def row_value_index
        Sheet.col2int(col) - 1
      end
    end

    class Row
      def initialize(row:, value:)
        @row = row
        @value = value
      end

      attr_reader :row, :value

      def ==(other)
        other.is_a?(self.class) && row == other.row && value == other.value
      end
    end

    class Cell
      def initialize(row:, col:, value:)
        @row = row
        @col = col
        @value = value
      end

      attr_reader :row, :col, :value

      def ==(other)
        other.is_a?(self.class) && row == other.row && col == other.col && value == other.value
      end
    end

    def initialize(messenger: Messaging::Messenger.new)
      @messenger = messenger
    end

    attr_reader :messenger

    def each_header
      raise NoMethodError, "You must implement #{self.class}#each_header => self"
    end

    def each_row
      raise NoMethodError, "You must implement #{self.class}#each_row => self"
    end

    def close
      raise NoMethodError, "You must implement #{self.class}#close => nil"
    end
  end
end
