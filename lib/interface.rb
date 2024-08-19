# = interface.rb
#
# == class Interface
#
# The Interface class provides a text-based user interface for the program.
#
# Creation of a new interface object should be done with the Interface.new_ui
# class method rather than the .new method. This allows extension to graphical
# interfaces. New interface classes can be created, inheriting from the Interface
# class and overriding the methods of the Interface class. The .new_ui class
# method will select which type of interface to create.
#
# The Interface class and subclasses must be kept as portable as possible.
class Interface
  def Interface.new_ui
    Interface.new 
  end

  def initialize
    @prompt = '  ? '

    Gem.win_platform? ? (system "cls") : (system "clear")
    welcome = "\n\n\n\n\n\n***************************************************\n"
    welcome = welcome + 'Welcome to the Repository Toolkit ' + $version
    welcome = welcome + "\n***************************************************\n"
    splash(welcome)
  end

  def clearscreen
    Gem.win_platform? ? (system "cls") : (system "clear")
    puts "RepoToolKit " + $version
  end

  def splash(text, duration=5)
    puts
    puts text
    sleep(duration)
  end

  def message(text)
    puts text      
  end

  def question(text, prompt=@prompt)
    if text.length > 0
      puts text
    end
    print prompt
    STDIN.gets.chomp.strip
  end

  def yesno(text, default=nil)
    if default == 'y' or default == 'n'
      prompt = '(y or n, blank=' + default + '?): '
    else prompt = '(y or n?): '
    end
    input = question(text, prompt).chomp.strip.downcase
    while true
      if input == 'y' or input == 'yes'
        return true
      end
      if input == 'n' or input == 'no'
        return false
      end
      if input == ''
        if default == 'y'
          return true
        elsif default == 'n'
          return false
        end
      end
      input = question('', prompt).chomp.strip.downcase
    end
  end

  def multiple_choice(text, choices)
    puts
    puts text
    puts
    choices.each {|i| puts "  *  " + i.to_s}

    while true
      puts
      choice = question('Enter at least the first few letters of your choice:')
      choicenum = nil
      i = 0
      while i < choices.length
        if choice.length > 0 and choices[i].to_s.downcase.start_with?(choice.downcase)
          choicenum = i
          break
        end
        i = i + 1
      end
      puts
      if choicenum == nil
        puts 'Choice not recognized'
      else
        if yesno('You chose:  ' + choices[choicenum] + ': Confirm?', 'y')
          return choices[choicenum]
        end
      end
    end
  end

  def debug(message = "")
    if $debug == true
      puts "DEBUG  #{caller[0]}" + " -- " + message
    end
  end

  # Send a closing message
  def close
    splash('Goodbye', 2)
  end
end