require_relative './section-8-provided'

class Knight < Character
  attr_reader :hp, :ap

  def initialize(hp, ap)
    super hp
    @ap = ap
  end

  def to_s
    "HP: " + @hp.to_s + " AP: " + @ap.to_s
  end

  def play_out_encounter enc
    ## YOUR CODE HERE
    hp, ap = enc.resolve_knight self
    @hp = hp 
    @ap = ap
  end
end

class Wizard < Character
  attr_reader :hp, :mp

  def initialize(hp, mp)
    super hp
    @mp = mp
  end

  def to_s
    "HP: " + @hp.to_s + " MP: " + @mp.to_s
  end

  def play_out_encounter enc
    ## YOUR CODE HERE
    hp, mp = enc.resolve_wizard self
    @hp = hp 
    @mp = mp
  end
end

class FloorTrap < Encounter
  attr_reader :dam

  def initialize dam
    @dam = dam
  end

  def to_s
    "A deadly floor trap dealing " + @dam.to_s + " point(s) of damage lies ahead!"
  end

  ## YOUR CODE HERE
  def resolve_knight kni
    ## resolve knights encounter with floor trap
    hp, ap = damage_knight(@dam, kni.hp, kni.ap)
    return hp, ap
  end

  def resolve_wizard wiz 
    ## resolve wizard's encounter with floor trap
    hp, mp = damage_wizard(@dam, wiz.hp, wiz.mp) 
    return hp, mp
  end

  private 

  def damage_knight(dam, hp, ap) 
    if ap == 0
      return hp-dam, 0
    elsif dam > ap 
      damage_knight(dam-ap, hp, 0)
    else 
      return hp, ap-dam
    end
  end

  def damage_wizard(dam, hp, mp) 
    if mp > 0 
      return hp, mp-1
    else 
      return hp-dam, mp
    end
  end
end

class Monster < Encounter
  attr_reader :dam, :hp

  def initialize(dam, hp)
    @dam = dam
    @hp = hp
  end

  def to_s
    "A horrible monster lurks in the shadows ahead. It can attack for " +
        @dam.to_s + " point(s) of damage and has " +
        @hp.to_s + " hitpoint(s)."
  end

  ## YOUR CODE HERE
  def resolve_knight kni
    ## resolve knights encounter with monster
    hp, ap = damage_knight(@dam, kni.hp, kni.ap)
    return hp, ap
  end

  def resolve_wizard wiz 
    ## resolve wizard's encounter with monster
    hp, mp = damage_wizard(@dam, wiz.hp, wiz.mp)
    return hp, mp
  end

  private 

  def damage_knight(dam, hp, ap)
    if ap == 0
      return hp-dam, 0
    elsif dam > ap 
      damage_knight(dam-ap, hp, 0)
    else 
      return hp, ap-dam
    end
  end

  def damage_wizard(dam, hp, mp) 
    if mp >= @hp
      return hp, mp-@hp
    else 
      return 0, 0
    end
  end
end

class Potion < Encounter
  attr_reader :hp, :mp

  def initialize(hp, mp)
    @hp = hp
    @mp = mp
  end

  def to_s
    "There is a potion here that can restore " + @hp.to_s +
        " hitpoint(s) and " + @mp.to_s + " mana point(s)."
  end

  ## YOUR CODE HERE
  def resolve_knight kni
    ## resolve knights encounter with potion
    return kni.hp + @hp, kni.ap
  end

  def resolve_wizard wiz 
    ## resolve wizard's encounter with potion
    return wiz.hp + @hp, wiz.mp + @mp
  end
end

class Armor < Encounter
  attr_reader :ap

  def initialize ap
    @ap = ap
  end

  def to_s
    "A shiny piece of armor, rated for " + @ap.to_s +
        " AP, is gathering dust in an alcove!"
  end

  ## YOUR CODE HERE
  def resolve_knight kni
    ## resolve knights encounter with armor
    return kni.hp, kni.ap + @ap
  end

  def resolve_wizard wiz 
    ## resolve wizard's encounter with armor
    return wiz.hp, wiz.mp
  end
end

if __FILE__ == $0
  Adventure.new(Stdout.new, Wizard.new(15, 10),
    [Monster.new(1, 1),
    FloorTrap.new(3),
    Monster.new(5, 3),
    Potion.new(5, 5),
    Monster.new(1, 15),
    Armor.new(10),
    FloorTrap.new(5),
    Monster.new(10, 10)]).play_out
end