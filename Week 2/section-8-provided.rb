class Encounter

  def to_s 
    raise "MethodMissingError"  # subclasses should implement this method
  end
  
end

class Character

  def initialize hp
    @hp = hp
  end

  def resolve_encounter enc
    if !is_dead?
      play_out_encounter enc
    end
  end

  def is_dead?
    @hp <= 0
  end

  def to_s 
    raise "MethodMissingError"  # subclasses should implement this method
  end

  private

  def play_out_encounter enc
    raise "MethodMissingError"  # subclasses should implement this method
  end
end

class Output
end

class Stdout < Output
  def print str
    puts str
  end
end

class Null < Output
  def print str
  end
end

class Adventure
  def initialize(out, character, dungeon)
    @out = out
    @init_character = character
    @dungeon = dungeon
  end

  def play_out
    reset

    @dungeon.each do |encounter|
      if @character.is_dead?
        break
      end
      @out.print @character.to_s
      @out.print encounter.to_s
      @character.resolve_encounter encounter
    end

    if !@character.is_dead?
      @out.print @character.to_s
      @out.print "The hero emerges victorious!\nTheir adventures are over...\nFOR NOW."
    else
      @out.print "Alas, the hero is dead.\nThe adventure ends here."
    end

    @character
  end

  private

  def reset
    @character = @init_character
  end
end