lambda {
  events = []
  setups = []

  Kernel.send :define_method, :event do |description, &block|
    events << {description: description, condition: block}
    run_event(events.last)
  end

  Kernel.send :define_method, :setup do |&block|
    setups << block
  end

  Kernel.send :define_method, :run_event do |event|
    clear_room = Object.new
    setups.each {|setup| clear_room.instance_eval &setup }
    puts "ALERT: #{event[:description]}" if clear_room.instance_eval &(event[:condition])
  end

}.call

setup do
  puts "Setting up sky"
  @sky_height = 100
end

setup do
  puts "Setting up mountains"
  @mountains_height = 200
end

event "the sky is falling" do
  @sky_height < 300
end

event "it's getting closer" do
  @sky_height < @mountains_height
end

event "whoops... too late" do
  @sky_height < 0
end