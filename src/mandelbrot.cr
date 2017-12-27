require "stumpy_png"
require "complex"
require "option_parser"

include StumpyPNG

include Random
include Math

class Arguments
  DEFAULTS = {
    width:      1600_u16,
    height:     1200_u16,
    iterations: 500_u16,
  }

  @width : UInt16
  @height : UInt16
  @iterations : UInt16

  getter width, height, iterations

  def initialize
    @width = DEFAULTS[:width]
    @height = DEFAULTS[:height]
    @iterations = DEFAULTS[:iterations]
  end

  def fetch!
    OptionParser.parse! do |parser|
      parser.on("-w WIDTH", "--width=WIDTH", "Width in pixels") { |w| @width = w.to_u16 }
      parser.on("-h HEIGHT", "--height=HEIGHT", "Height in pixels") { |h| @height = h.to_u16 }
      parser.on("-i ITERATIONS", "--iterations=ITERATIONS", "Max number of iterations") { |i| @iterations = i.to_u16 }
    end
    self
  end
end

args = Arguments.new.fetch!

canvas = Canvas.new(args.width.to_i32, args.height.to_i32)

def scaled(raw, raw_abs, scale_min, scale_max)
  width = scale_max - scale_min

  ((raw.to_f / raw_abs) * width + scale_min).to_f
end

def palette(n)
  #  puts n
  n = (n * 65536.to_f).to_u16
  RGBA.from_rgb_n(n, n, n, 8)
end

def inside_the_cardioid?(z)
  p = Math.sqrt((z.real - 0.25)**2 + z.imag**2)

  z.real < (p - 2*(p**2) + 2.0**-2) &&
    ((z.real + 1)**2 + (z.imag)**2) < 2.0**-3
end

max_iteration = args.iterations

(0...args.width).each do |px|
  (0...args.height).each do |py|
    c_real = scaled px, args.width, -2, 2
    c_imag = scaled py, args.height, -1.25, 1.25

    z = Complex.zero
    c = Complex.new(c_real, c_imag)
    iteration = 0

    unless inside_the_cardioid?(c)
      while ((z.abs < 2) && (iteration < max_iteration))
        z = z*z + c
        iteration += 1
      end
    end

    # puts "Iterations: #{iteration}" if iteration > 5
    if (iteration < max_iteration)
      log_zn = log(z.real**2 + z.imag**2) / 2
      nu = log(log_zn / log(2)) / log(2)
      iteration = iteration + 1 - nu
    end
    color = palette iteration.to_f / max_iteration
    # puts color
    canvas[px, py] = color
  end
end

StumpyPNG.write(canvas, "rainbow.png")
