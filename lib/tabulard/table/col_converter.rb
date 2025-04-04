# frozen_string_literal: true

module Tabulard
  module Table
    class ColConverter
      CHARSET      = ("A".."Z").to_a.freeze
      CHARSET_SIZE = CHARSET.size
      CHAR_TO_INT  = CHARSET.map.with_index(1).to_h.freeze
      INT_TO_CHAR  = CHAR_TO_INT.invert.freeze

      def col2int(col)
        raise ArgumentError unless col.is_a?(String) && !col.empty?

        int = 0

        col.each_char.reverse_each.with_index do |char, pow|
          int += char2int(char) * (CHARSET_SIZE**pow)
        end

        int
      end

      def int2col(int)
        raise ArgumentError unless int.is_a?(Integer) && int.positive?

        col = +""

        until int.zero?
          int, char_int = int.divmod(CHARSET_SIZE)

          if char_int.zero?
            int -= 1
            char_int = CHARSET_SIZE
          end

          col << int2char(char_int)
        end

        col.reverse!
        col.freeze
      end

      private

      def char2int(char)
        CHAR_TO_INT[char] || raise(ArgumentError, char.inspect)
      end

      def int2char(int)
        INT_TO_CHAR[int] || raise(ArgumentError, int.inspect)
      end
    end

    private_constant :ColConverter

    COL_CONVERTER = ColConverter.new.freeze
  end
end
