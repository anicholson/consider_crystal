require "spec2"
require "../../spec_helper"

module WordCount
  Spec2.describe FragmentFactory do
    let(text) { "abc 2de f" }
    describe "empty string" do
      subject { FragmentFactory.make "" }

      it "has no words" { expect(subject.words).to eq 0 }
      it "has no left" { expect(subject.left).to be_nil }
      it "has no right" { expect(subject.right).to be_nil }
    end

    describe "leading whitespace" do
      let(with_leading) { "   " + text }

      it "causes left to be nil" do
        expect(FragmentFactory.make(with_leading).left).to be_nil
      end

      it "changes word count" do
        expect(FragmentFactory.make(text).words < FragmentFactory.make(with_leading).words).to be_true
      end
    end

    describe "trailing whitespace" do
      let(with_trailing) { text + "     " }

      it "causes right to be nil" do
        expect(FragmentFactory.make(with_trailing).right).to be_nil
      end

      it "changes the word count" do
        expect(FragmentFactory.make(text).words < FragmentFactory.make(with_trailing).words).to be_true
      end
    end

    describe "no leading or trailing whitespace" do
      subject { FragmentFactory.make text }

      it "causes left to be present" do
        expect(subject.left).to eq("abc")
      end

      it "causes right to be present" do
        expect(subject.right).to eq("f")
      end
    end

    describe "whole words" do
      it "are counted" do
        expect(FragmentFactory.make(text).words).to eq(1)
      end
    end
  end
end
