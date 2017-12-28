require "spec2"
require "../../spec_helper"

module WordCount
  Spec2.describe Fragment do
    subject { Fragment.new("a", "b", 3) }

    it "has a left" { expect(subject.left).to eq("a") }
    it "has a right" { expect(subject.right).to eq("b") }
    it "has a word count" { expect(subject.words).to eq(3_u32) }

    describe ".+" do
      describe "when LHS is empty" do
        subject { FragmentFactory.empty }

        it "returns the RHS" do
          rhs = Fragment.new("LOL", "NO", 100)

          expect(subject + rhs).to eq(rhs)
        end
      end

      describe "when RHS is empty" do
        it "returns the LHS" do
          lhs = Fragment.new("Not", "Empty", 1)
          rhs = FragmentFactory.empty

          expect(lhs + rhs).to eq(lhs)
        end
      end

      describe "neither are empty" do
        let(result) { lhs + rhs }

        describe "when LHS has empty .right" do
          let(lhs) { Fragment.new("PRESENT", nil, 10) }

          describe "when RHS has empty .left" do
            let(rhs) { Fragment.new(nil, "LOL", 5) }

            it "keeps LHS.left" do
              expect(result.left).to eq(lhs.left)
            end

            it "keeps RHS.right" do
              expect(result.right).to eq(rhs.right)
            end

            it "adds the word counts together" do
              expect(result.words).to eq(15)
            end
          end

          describe "when RHS has non-empty .left" do
            let(rhs) { Fragment.new("WHAT", "NOW", 5) }

            it "converts the RHS.right into a word" do
              expect(result.words).to eq(16)
            end
          end
        end

        describe "when LHS has non-empty .right" do
          let(lhs) { Fragment.new(nil, "RIGHT", 1) }
          let(rhs) { Fragment.new("Doesn't matter", nil, 1) }

          it "converts the LHS.right and RHS.left into a word" do
            expect(result.words).to eq(3)
          end
        end
      end
    end
  end
end
