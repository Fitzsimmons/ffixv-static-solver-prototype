# frozen_string_literal: true

require_relative "slot"

module Slots
  def self.mean_squared_error(slots)
    slots.sum { |s| s.rank * s.rank }.to_f / slots.count
  end

  def self.initialize_from_composition(composition)
    slots = []

    composition.each do |role, amount|
      amount.times do
        slots.push(Slot.new(role: role))
      end
    end

    return slots
  end

  def self.to_standardized_output(slots)
    slots.map do |slot|
      [slot.player, slot.job]
    end.to_h
  end
end
