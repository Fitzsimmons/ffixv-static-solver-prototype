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

      error = solution.mean_squared_error
      if error == lowest_mean_squared_error
        potential_solutions.append(solution)
        next
      end

      if error < lowest_mean_squared_error
        lowest_mean_squared_error = error
        potential_solutions.clear
        potential_solutions.append(solution)
        next
      end
    end

    return potential_solutions.map(&:to_standardized_output).uniq
  end

  class InsufficientPlayersError < RuntimeError
  end

  class NoSolutionError < RuntimeError
  end

  private

  def solution_for_permutation(player_names)
    slots = Slots.new(desired_composition)

    player_names.each do |player_name|
      player = Player.new(name: player_name, jobs: job_preferences.fetch(player_name))
      return nil unless slots.assign(player)
    end

    return slots
  end

  Player = Struct.new(:name, :jobs, keyword_init: true)
end
