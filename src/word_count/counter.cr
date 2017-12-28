require "concurrent/future"

module WordCount
  alias F = Concurrent::Future(Fragment)

  class Counter
    NO_WORDS = 0_u32

    def self.count(corpus : String, chunk_size : Int = 1000) : UInt32
      io = IO::Memory.new(corpus)
      count(io, chunk_size)
    end

    def self.count(corpus : IO, chunk_size : Int = 1000) : UInt32
      fragments = [] of F
      no_more_bytes = false

      until no_more_bytes
        this_chunk = corpus.gets(delimiter: '\0', limit: chunk_size)

        if this_chunk.nil?
          no_more_bytes = true
        else
          c = this_chunk.as(String)
          fragments << future { FragmentFactory.make(c) }
        end
      end

      return NO_WORDS if fragments.empty?

      result = fragments.reduce do |lhs, rhs|
        future { lhs.get + rhs.get }
      end.get.normalize

      result.words
    end
  end
end
