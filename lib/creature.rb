# frozen_string_literal: true

# Base class for Magic 8-Ball like object
class Creature
  BASE_INTERVAL = 50
  INTERVAL_RANGE = 45

  attr_reader :name, :health, :health_max, :strength, :toughness, :speed

  def initialize(name: 'Creature', health: 25, strength: 1, toughness: 1, speed: 1)
    @name = name
    @health_max = health.clamp(1, 255)
    @health = health.clamp(1, 255)
    @strength = strength.clamp(1, 255)
    @toughness = toughness.clamp(1, 255)
    @speed = speed.clamp(1, 255)

    @tick_counter = 0
  end

  def hurt(amount)
    @health = clamp_health(@health - amount)
  end

  def heal(amount)
    @health = clamp_health(@health + amount)
  end

  def roll_initiative(seed: nil)
    @tick_counter = if seed.nil?
                      # generates a random number between 0 and 2 less than attack_intverval
                      rand(attack_interval - 1)
                    elsif seed.negative?
                      # shortcut to instant attack (have the jump on an enemy)
                      attack_interval
                    else
                      # assign a legal seed number, including instant attack
                      seed.clamp(0, attack_interval)
                    end
  end

  def can_attack?
    @tick_counter += 1
    if @tick_counter >= attack_interval
      @tick_counter = 0
      true
    else
      false
    end
  end

  def alive?
    @health.positive?
  end

  def card
    c_card = "= #{@name.upcase.ljust(13)} ===\n"
    c_card += "HP:  [ #{@health.to_s.rjust(3, '0')} / #{@health_max.to_s.rjust(3, '0')} ]\n"
    c_card += "STR: #{@strength.to_s.rjust(3, '0')}\n"
    c_card += "TGH: #{@toughness.to_s.rjust(3, '0')}\n"
    c_card += "SPD: #{@speed.to_s.rjust(3, '0')}\n"
    c_card
  end

  def to_s
    @name
  end

  private

  def attack_interval
    # Calculate interval based on speed
    BASE_INTERVAL - ((@speed / 255.0) * INTERVAL_RANGE).to_i
  end

  def clamp_health(new_health)
    new_health.clamp(0, @health_max)
  end
end
