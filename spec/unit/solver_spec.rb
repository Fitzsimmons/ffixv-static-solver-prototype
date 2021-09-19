# frozen_string_literal: true

require_relative "../../solver"

describe Solver do
  let(:basic_composition) do
    basic_composition = {
      "ranged dps": 2,
      "melee dps": 2,
      tank: 2,
      "barrier healer": 1,
      "pure healer": 1,
    }
  end

  it "finds a solution" do
    job_preferences = {
      "Yorvo Hawke": ["DRG", "GNB"],
      "Squidgy Bunny": ["NIN", "SMN", "WHM", "PLD"],
      "Renfleur Orinoux": ["DRK", "SAM"],
      "Zelle Tamjin": ["PLD", "BLM"],
      "Era Dere": ["WHM", "DNC"],
      "Brando Id": ["SCH"],
      "Alleriana Valyrian": ["RDM", "BLM"],
      "Reye Fenris": ["BRD", "DRG"],
    }

    expected = {
      "Yorvo Hawke": "DRG",
      "Squidgy Bunny": "NIN",
      "Renfleur Orinoux": "DRK",
      "Zelle Tamjin": "PLD",
      "Era Dere": "WHM",
      "Brando Id": "SCH",
      "Alleriana Valyrian": "RDM",
      "Reye Fenris": "BRD",
    }

    expect(Solver.solve(desired_composition: basic_composition, job_preferences: job_preferences)).to eq(expected)
  end

  it "errors when there are not enough players" do
    job_preferences = { "Yorvo Hawke": "DRG" }

    expect { Solver.solve(desired_composition: basic_composition, job_preferences: job_preferences) }.to raise_error(Solver::InsufficientPlayersError)
  end

  it "errors when a solution cannot be found" do
    job_preferences = {
      "Yorvo Hawke": ["DRG"],
      "Squidgy Bunny": ["SMN"],
      "Renfleur Orinoux": ["DRK"],
      "Zelle Tamjin": ["PLD"],
      "Era Dere": ["WHM"],
      "Brando Id": ["SCH"],
      "Alleriana Valyrian": ["RDM"],
      "Reye Fenris": ["BRD"],
    }

    expect { Solver.solve(desired_composition: basic_composition, job_preferences: job_preferences) }.to raise_error(Solver::NoSolutionError)
  end
end
