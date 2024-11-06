# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/spec'

require_relative '../lib/creature'

describe Creature do
  before do
    @creature = Creature.new
  end

  it 'retains its name after birth' do
    refute_nil @creature.name
  end

  it 'is represented by its name' do
    assert_same(@creature.to_s, 'Creature')
  end

  describe '#alive?' do
    it 'is alive at birth' do
      assert @creature.alive?
    end

    it 'is alive if it has 1 or more health' do
      @creature.hurt(@creature.health - 1)
      assert @creature.alive?
    end

    it 'is not alive if it has 0 or less health' do
      @creature.hurt(@creature.health)
      refute @creature.alive?
    end
  end

  describe '#hurt' do
    it 'has less health after taking damage' do
      health = @creature.health
      @creature.hurt(5)
      assert_operator @creature.health, :<, health
    end

    it 'cannot have negative health' do
      @creature.hurt(@creature.health + 1)
      refute @creature.health.negative?
    end
  end

  describe '#heal' do
    it 'has more health after healing' do
      @creature.hurt(5)
      health = @creature.health
      @creature.heal(5)
      assert_operator @creature.health, :>, health
    end

    it 'cannot have more health than its max' do
      @creature.heal(1)
      refute_operator @creature.health, :>, @creature.health_max
    end
  end

  describe '#can_attack?' do
    it 'should never be ready to attack at birth' do
      refute @creature.can_attack?
    end

    it 'should not be ready to attack before enough time passes' do
      49.times do
        refute @creature.can_attack?
      end

      assert @creature.can_attack?
    end

    it 'should never be ready to attack on the first tick after random initiative' do
      bools = []
      25.times do
        @creature.roll_initiative

        can_attack_now = @creature.can_attack?
        bools.append can_attack_now

        assert_equal false, can_attack_now
      end

      refute_includes bools, true
    end

    it 'should be ready to attack if ambushing' do
      @creature.roll_initiative(seed: -1)
      assert @creature.can_attack?
    end
  end

  describe '#card' do
    it "contains the creature's stats and information" do
      card = @creature.card
      assert_includes card, 'CREATURE'
      assert_includes card, 'HP:  [ 025 / 025 ]'
      assert_includes card, 'STR: 001'
      assert_includes card, 'TGH: 001'
      assert_includes card, 'SPD: 001'
    end
  end
end
