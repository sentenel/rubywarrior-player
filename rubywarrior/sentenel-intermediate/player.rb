require "pry"

class Player

  attr_accessor(:last_health)

  def initialize
    @last_health = 20
  end

  def combat_protocol!
    attack!(direction_of_enemy) if next_to_enemy?
  end

  def direction_of_enemy
    [:forward, :left, :backward, :right].each do |direction|
      if feel(direction).enemy?
        return direction
      end
    end
    nil
  end

  def method_missing(name, *args)
    @warrior.send(name, *args)
  end

  def surroundings
    [:forward, :left, :backward, :right].map do |direction|
      feel(direction)
    end
  end

  def next_to_enemy?
    !!direction_of_enemy
  end

  def recovery_protocol!
    rest!
  end

  def taking_damage?
    health < @last_health
  end

  def play_turn(warrior)
    @warrior = warrior

    if next_to_enemy?
      combat_protocol!
    elsif health < 20
      recovery_protocol!
    else
      walk!(direction_of_stairs)
    end
  end
end