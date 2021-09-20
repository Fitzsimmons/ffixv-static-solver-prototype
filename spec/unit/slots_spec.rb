# frozen_string_literal: true

require_relative "../../slots"

MockSlot = Struct.new(:rank)

describe Slots do
  describe "calculating the mean_squared_error" do
    it "works" do
      ranked_internal_slots = [1, 0, 2, 0].map { |s| slot = Slot.new(role: :bogus); slot.instance_variable_set(:@rank,s); slot }

      slots = Slots.new({})
      slots.instance_variable_set(:@slots, ranked_internal_slots)

      expect(slots.mean_squared_error).to eq(1.25)
    end
  end

  it "creates slots according to the desired composition"

  describe "assigning a player to a slot" do
    it "assigns the player to their most-preferred job out of the remaining slots"
    it "returns true when a slot is found"
    it "returns false when a slot cannot be found"
    it "does not allow for repeated jobs"
  end
end
