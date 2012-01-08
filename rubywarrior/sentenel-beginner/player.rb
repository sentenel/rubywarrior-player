require "pry"

class Player

  attr_accessor(:last_health)

  def initialize
    @last_health = 20
    @direction = :forward
  end

  def alone?
    feel.empty?
  end

  def butt_rescue!
    rescue!(:backward)
  end

  def captive_behind?
    if facing_forward?
      look(:backward).each do |space|
        return true if space.captive?
        return false unless space.empty?
      end
    end
    false
  end

  def captive_directly_ahead?
    feel.captive?
  end

  def combat_actions!
    if enemy_far_ahead?
      if taking_damage?
        walk!
      else
        shoot!
      end
    else
      attack!
    end
  end

  def enemy_ahead?
    !!enemy_location
  end

  def enemy_far_ahead?
    enemy_location > 1
  end

  def enemy_location
    look.each_with_index do |space, index|
      return index + 1 if space.enemy?
      return nil unless space.empty?
    end
    return nil
  end

  def facing_forward?
    @direction == :forward
  end

  def initiate_butt_rescue_protocol!
    if feel(:backward).captive?
      butt_rescue!
    else
      walk!(:backward)
    end
  end

  def method_missing(name, *args)
    @last_action = name.to_sym
    @warrior.send(name, *args)
  end

  def taking_damage?
    health < @last_health
  end

  def turn_around!
    pivot!(:backward)
    @direction = (facing_forward? ? :backward : :forward)
  end

  def play_turn(warrior)

    @warrior = warrior

    if captive_behind?
      initiate_butt_rescue_protocol!
    elsif captive_directly_ahead?
      rescue!
    elsif enemy_ahead?
      combat_actions!
    elsif feel.wall?
      turn_around!
    elsif feel.stairs?
      walk!
    elsif health < 10 && !taking_damage?
      rest!
    else
      walk!
    end

    @last_health = health
  end
end