module WordCount
  class FragmentFactory
    def self.make(text : String)
      words = 0_u32
      left = nil
      right = nil

      return empty if text.empty? || text.blank?

      had_leading_space = text.chars.first { ' ' }.whitespace?
      had_trailing_space = text.chars.last { ' ' }.whitespace?
      stripped = text.strip
      words = stripped.split

      left = words.shift? unless had_leading_space
      right = words.pop? unless had_trailing_space
      words = words.size.to_u32

      Fragment.new(left: left, right: right, words: words)
    end

    def self.empty
      Fragment.new(left: nil, right: nil, words: 0_u32)
    end
  end
end
