require "spec_helper"

require "fetchable"

describe Fetchable do
  subject(:fetchable) { Fetchable.new(collection, finder_method: finder_method) }

  let(:collection) {
    double(:collection, finder_method => fetched_object)
  }

  let(:finder_method)  { :[] }
  let(:fetched_object) { double(:fetched_object) }
  let(:fetch_key)      { double(:fetch_key) }

  it "is a true decorator" do
    expect(collection).to receive(:arbitrary).with("an arg")

    fetchable.arbitrary("an arg")
  end

  describe "#fetch" do
    it "delegates to the collection's finder method" do
      fetchable.fetch(fetch_key)

      expect(collection).to have_received(finder_method).with(fetch_key)
    end

    context "when entry for key exists" do
      it "does not execute the block" do
        expect {
          fetchable.fetch(fetch_key) { raise "This block must not run" }
        }.not_to raise_error
      end

      it "returns the entry from the collection" do
        expect(fetchable.fetch(fetch_key)).to be fetched_object
      end
    end

    context "when entry for key does not exist" do
      let(:fetched_object) { nil }

      context "when a default argument is given" do
        let(:default) { double(:default) }

        it "returns the default" do
          expect(fetchable.fetch(fetch_key, default)).to be default
        end

        context "when default argument is nil" do
          it "returns nil" do
            expect(fetchable.fetch(fetch_key, nil)).to be nil
          end
        end

        context "when default argument is false" do
          it "returns false" do
            expect(fetchable.fetch(fetch_key, false)).to be false
          end
        end
      end

      context "when a block is given" do
        let(:spy) { double(:spy, :block_was_called => block_return_value) }
        let(:block) { lambda { |key| spy.block_was_called(key) } }
        let(:block_return_value) { double(:block_return_value) }

        it "returns the result of block" do
          expect(fetchable.fetch(fetch_key, &block)).to be block_return_value
        end

        it "yields the key to the block" do
          fetchable.fetch(fetch_key, &block)
          expect(spy).to have_received(:block_was_called).with(fetch_key)
        end
      end

      context "no default or block given" do
        it "raises record not found" do
          expect{ fetchable.fetch(fetch_key) }.to raise_error(KeyError)
        end
      end
    end

    context "when both block and default argument is given" do
      it "raises ArgumentError" do
        expect{ fetchable.fetch(fetch_key, nil) {} }.to raise_error(ArgumentError)
      end
    end
  end
end
