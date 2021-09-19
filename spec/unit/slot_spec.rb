# frozen_string_literal: true

require_relative "../../slot"

describe Slot do
  subject { Slot.new(role: :mage) }

  it "is satisfied by a matching job" do
    expect(subject).to be_satisfied_by("BLM")
  end

  it "is not satisfied by a non-matching job" do
    expect(subject).not_to be_satisfied_by("DRG")
  end

  it "is not satisfied by a matching job when a player is already assigned" do
    subject.assign(job: "BLM", rank: 0, player: "Yorvo")
    expect(subject).not_to be_satisfied_by("BLM")
  end
end
