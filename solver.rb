require "json"

module Solver
  Candidate = Struct.new(:job, :rank, :player, keyword_init: true) do
    def <=>(other)
      self.rank <=> other.rank
    end
  end

  class InsufficientPlayersError < RuntimeError
  end

  class NoSolutionError < RuntimeError
  end

  def self.solve(desired_composition:, job_preferences:)
    raise InsufficientPlayersError.new("Composition requires #{desired_composition.length} slots but only #{job_preferences.length} supplied") if job_preferences.length < desired_composition.length

    classifications = JSON.parse(File.read("classifications.json"), symbolize_names: true)

    final_composition = {}

    slots = desired_composition.sort {|a, b| a[1] <=> b[1]}.to_h

    slots.each do |slot, count|
      count.times do
        candidates = []

        job_preferences.each do |player, preferred_jobs|
          rank = preferred_jobs.find_index { |job| classifications.fetch(slot).include?(job) }

          if ! rank.nil?
            candidates.append(Candidate.new(job: preferred_jobs[rank], rank: rank, player: player))
          end
        end

        raise NoSolutionError.new("Could not find someone to fill the role of #{slot}") if candidates.empty?

        candidate = candidates.sort.first

        final_composition[candidate.player] = candidate.job

        job_preferences.delete(candidate.player)
      end
    end

    return final_composition
  end
end
