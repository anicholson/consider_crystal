require "../word_count"
require "option_parser"

map_reduce = false
chunk_size = 10_000_u32

OptionParser.parse! do |p|
  p.on "-c CHUNK", "--chunk-size=CHUNK" { |c| chunk_size = c.to_u32 }
  p.on "-m", "--map-reduce" { map_reduce = true }
end

count = if map_reduce
          WordCount::Counter.count(STDIN, chunk_size)
        else
          data = STDIN.gets_to_end
          data.split.size
        end

puts count
