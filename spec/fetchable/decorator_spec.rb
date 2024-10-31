require "spec_helper"

require "fetchable/decorator"

RSpec.describe Fetchable::Decorator do
  subject(:fetchable) {
    Fetchable::Decorator.new(collection)
  }

  let(:collection)     { double(:collection, :[] => fetched_object) }

  let(:fetched_object) { double(:fetched_object) }
  let(:fetch_key)      { double(:fetch_key) }

  it "is a true decorator" do
    expect(collection).to receive(:i_am_a_decorator_and_forward_all_messages)
      .with("some", "args")

    fetchable.i_am_a_decorator_and_forward_all_messages("some", "args")
  end

  it "is fetchable" do
    expect(fetchable).to be_a(Fetchable)
  end

  describe "#fetch" do
    it "delegates to the collection's #[] method" do
      fetchable.fetch(fetch_key)

      expect(collection).to have_received(:[]).with(fetch_key)
    end

    it "returns the entry from the collection" do
      expect(fetchable.fetch(fetch_key)).to be fetched_object
    end
  end
end
