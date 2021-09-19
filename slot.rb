# frozen_string_literal: true

require "json"

class Slot
  class InvalidJobError < ArgumentError
  end

  @@classifications ||= JSON.parse(File.read("classifications.json"), symbolize_names: true).freeze

  attr_reader :rank, :job, :player, :role

  def initialize(role:)
    @role = role
    @player = nil
    @rank = nil
    @job = nil
  end

  def satisfied_by?(job)
    @player.nil? && role_jobs.include?(job)
  end

  def assign(job:, player:, rank:)
    raise InvalidJobError.new("#{job} is not a valid assignment to role #{role} (#{role_jobs.join(", ")})") unless satisfied_by?(job)

    @job = job
    @player = player
    @rank = rank
  end

  private

  def role_jobs
    @_role_jobs ||= @@classifications.fetch(role)
  end
end
