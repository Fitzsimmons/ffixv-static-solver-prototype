# frozen_string_literal: true

require_relative "slot"

class Slots
  def initialize(composition, unique: true)
    @unique = unique
    @slots = []
    @claimed_jobs = []

    composition.each do |role, amount|
      amount.times do
        @slots.push(Slot.new(role: role))
      end
    end
  end

  def to_standardized_output
    @slots.map do |slot|
      [slot.player, slot.job]
    end.to_h
  end

  def mean_squared_error
    @slots.sum { |s| s.rank * s.rank }.to_f / @slots.count
  end

  def assign(player)
    player.jobs.each_with_index do |job, index|
      next if @unique && @claimed_jobs.include?(job)

      placement_slot = @slots.find { |slot| slot.satisfied_by?(job) }
      if ! placement_slot.nil?
        placement_slot.assign(job: job, player: player.name, rank: index)
        @claimed_jobs.push(job)
        return true
      end
    end

    return false # because we couldn't find a slot for this player
  end
end
