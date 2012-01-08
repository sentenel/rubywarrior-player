class Player

  attr_accessor(:last_health)

  def initialize
    @last_health = 20
    @direction = :forward
  end

  def alone?
    @warrior.feel.empty?
  end

  def butt_rescue!
    @warrior.rescue!(:backward)
  end

  def captive_behind?
    if facing_forward?
      @warrior.look(:backward).each do |space|
        return true if space.captive?
        return false unless space.empty?
      end
    end
    false
  end

  def captive_directly_ahead?
    @warrior.feel.captive?
  end

  def combat_actions!
    if enemy_far_ahead?
      if taking_damage?
        @warrior.walk!
      else
        @warrior.shoot!
      end
    else
      @warrior.attack!
    end
  end

  def enemy_ahead?
    !!enemy_location
  end

  def enemy_far_ahead?
    enemy_location > 1
  end

  def enemy_location
    @warrior.look.each_with_index do |space, index|
      return index + 1 if space.enemy?
      return nil unless space.empty?
    end
    return nil
  end

  def facing_forward?
    @direction == :forward
  end

  def initiate_butt_rescue_protocol!
    if @warrior.feel(:backward).captive?
      butt_rescue!
    else
      @warrior.walk!(:backward)
    end
  end

  def taking_damage?
    @warrior.health < @last_health
  end

  def turn_around!
    @warrior.pivot!(:backward)
    @direction = (facing_forward? ? :backward : :forward)
  end

  def play_turn(warrior)
    @warrior = warrior

    if captive_behind?
      initiate_butt_rescue_protocol!
    elsif captive_directly_ahead?
      @warrior.rescue!
    elsif enemy_ahead?
      combat_actions!
    elsif @warrior.feel.wall?
      turn_around!
    elsif warrior.feel.stairs?
      @warrior.walk!
    elsif @warrior.health < 10 && !taking_damage?
      #Heal if safe unless warrior is at minimum safe health
      @warrior.rest!
    else
      @warrior.walk!
    end

    @last_health = @warrior.health
  end
end