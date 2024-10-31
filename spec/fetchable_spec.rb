require "spec_helper"

require "fetchable"

RSpec.describe Fetchable do
  subject(:fetchable) { augmented_class.new }

  let(:augmented_class) {
    key_that_has_a_value = key
    the_value = value

    Class.new do
      include Fetchable

      define_method(:[]) do |key|
        if key == key_that_has_a_value
          the_value
        else
          nil
        end
      end
    end
  }

  let(:value) { double(:value) }
  let(:key)   { double(:key) }

  describe "#fetch" do
    it "calls the target object's `[]` method" do
      expect(fetchable).to receive(:[]).with(key).and_return(value)

      fetchable.fetch(key)
    end

    context "when the `[]` method returns not `nil`" do
      it "returns the value from the `[]` method" do
        expect(fetchable.fetch(key)).to be value
      end

      it "does not execute the block" do
        expect {
          fetchable.fetch(key) { raise "This block must not run" }
        }.not_to raise_error
      end
    end

    context "when the `[]` method returns `false`" do
      let(:value) { false }

      it "does not execute the block" do
        expect {
          fetchable.fetch(key) { raise "This block must not run" }
        }.not_to raise_error
      end

      it "returns the entry from the fetchable" do
        expect(fetchable.fetch(key)).to be value
      end
    end

    context "when `[]` returns nil" do
      let(:value) { nil }

      context "when a default argument is given" do
        let(:default) { double(:default) }

        it "returns the default" do
          expect(fetchable.fetch(key, default)).to be default
        end

        context "when default argument is nil" do
          it "returns nil" do
            expect(fetchable.fetch(key, nil)).to be nil
          end
        end

        context "when default argument is false" do
          it "returns false" do
            expect(fetchable.fetch(key, false)).to be false
          end
        end
      end

      context "when a block is given" do
        let(:spy) { double(:spy, :block_was_called => block_return_value) }
        let(:block) { lambda { |key| spy.block_was_called(key) } }
        let(:block_return_value) { double(:block_return_value) }

        it "returns the result of block" do
          expect(fetchable.fetch(key, &block)).to be block_return_value
        end

        it "yields the key to the block" do
          fetchable.fetch(key, &block)
          expect(spy).to have_received(:block_was_called).with(key)
        end
      end

      context "no default or block given" do
        it "raises KeyError" do
          expect{ fetchable.fetch(key) }.to raise_error(KeyError, "key not found #{key}")
        end
      end
    end

    context "when both block and default argument is given" do
      it "prints a warning" do
        expect{ fetchable.fetch(key, nil) {} }.to raise_error(ArgumentError)
      end
    end
  end
end
