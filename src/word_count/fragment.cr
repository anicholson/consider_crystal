module WordCount
  struct Fragment
    @left : String?
    @right : String?
    @words : UInt32

    getter left, right, words

    def initialize(@left, @right, words)
      @words = words.to_u32
    end

    def +(other : Nil)
      self
    end

    def +(other : Fragment) : Fragment
      return other if empty?
      return self if other.empty?

      merged_word = (self.right || other.left) ? 1 : 0

      Fragment.new(self.left, other.right, self.words + other.words + merged_word)
    end

    def empty?
      @left.nil? && @right.nil? && @words.zero?
    end

    def normalize
      left_word = left.nil? ? 0 : 1
      right_word = right.nil? ? 0 : 1

      Fragment.new(nil, nil, words + left_word + right_word)
    end

    def to_s(io)
      io << "LEFT: " << left << "\tRIGHT: " << right \
        << "\tWORDS: " << words
    end
  end
end
