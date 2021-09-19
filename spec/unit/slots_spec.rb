# frozen_string_literal: true

require_relative "../../slots"

MockSlot = Struct.new(:rank)

describe Slots do
  describe "calculating the mean_squared_error" do
    it "works" do
      slots = [1, 0, 2, 0].map { |s| MockSlot.new(s) }

      expect(subject.mean_squared_error(slots)).to eq(1.25)
    end
  end
end
