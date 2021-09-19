# frozen_string_literal: true

require_relative "slots"

class Solver
  attr_reader :desired_composition, :job_preferences

  def self.solve(**kwargs)
    new(**kwargs).solve
  end

  def initialize(desired_composition:, job_preferences:)
    raise InsufficientPlayersError.new("Composition requires #{desired_composition.length} slots but only #{job_preferences.length} supplied") if job_preferences.length < desired_composition.length

    @desired_composition = desired_composition
    @job_preferences = job_preferences
  end

  def solve
    potential_solutions = [] # a list that holds all of the candidates that are tied for having the least error
    lowest_mean_squared_error = Float::MAX

    all_player_order_permutations = job_preferences.keys.permutation

    all_player_order_permutations.each do |permutation|
      solution = solution_for_permutation(permutation)
      next if solution.nil?

      error = Slots.mean_squared_error(solution)
      if error == lowest_mean_squared_error
        potential_solutions.append(solution)
        next
      end

      if error < lowest_mean_squared_error
        potential_solutions.clear
        potential_solutions.append(solution)
        next
      end
    end

    return potential_solutions.map{|c| Slots.to_standardized_output(c)}
  end

  class InsufficientPlayersError < RuntimeError
  end

  class NoSolutionError < RuntimeError
  end

  private

  def solution_for_permutation(player_names)
    slots = Slots.initialize_from_composition(desired_composition)

    player_names.each do |player_name|
      player = Player.new(name: player_name, jobs: job_preferences.fetch(player_name))
      return nil unless slot_player(slots, player)
    end

    return slots
  end

  def slot_player(slots, player)
    player.jobs.each_with_index do |job, index|
      placement_slot = slots.find { |slot| slot.satisfied_by?(job) }
      if ! placement_slot.nil?
        placement_slot.assign(job: job, player: player.name, rank: index)
        return true
      end
    end

    return false # because we couldn't find a slot for this player
  end

  Player = Struct.new(:name, :jobs, keyword_init: true)
end
