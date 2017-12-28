require "spec2"
require "../../spec_helper"

module WordCount
  Spec2.describe Counter do
    describe ".count" do
      it "empty strings have 0 words" do
        expect(Counter.count("")).to eq(0)
      end

      it "treats numerals as words" do
        expect(Counter.count("1 2 34")).to eq(3)
      end

      it "can read a File" do
        file = File.open("examples/kjv.txt", "r")

        expect(Counter.count(file)).to eq(824337)
      end
    end
  end
end
