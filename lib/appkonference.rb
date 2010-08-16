module Adhearsion
  module Components
    class KonferenceManager
      include Adhearsion::VoIP::Asterisk

      attr_accessor :conf_rooms
  
      class << self
  
        def initialize
          @@conf_rooms = []
        end
  
        def []=(room, channel)
          @@conf_rooms[room] = [] unless @@conf_rooms[room]
          @@conf_rooms[room].push(channel)
        end
  
        def delete(room, channel)
          @@conf_rooms[room].delete(channel)
          @@conf_rooms.delete(room) if @@conf_rooms[room].empty?
        end
  
        def play_entry_sound(room)
          @@conf_rooms[room].each do |channel|
            ahn_log.event_handler.debug("Playing join tone to #{channel}")
            manager_interface.send_action("Command", "Command" => "konference play sound #{channel} conf-enter")
          end
        end
  
        def play_exit_sound(room)
          @@conf_rooms[room].each do |channel|
            ahn_log.event_handler.debug("Playing leave tone to #{channel}")
            manager_interface.send_action("Command", "Command" => "konference play sound #{channel} conf-exit")
          end
        end
      end
    end
  end
end

Events.register_callback([:asterisk, :manager_interface]) do |event|
  include Adhearsion::Components::KonferenceManager
  case event.name.downcase 
  when "conferencejoin"
    ahn_log.konference.info("Caller #{event.headers["Channel"]} joining conference #{event.headers["ConferenceName"]}")
    room = event.headers["ConferenceName"]
    add_channel(room, event.headers["Channel"])
    play_entry_sound(room)

  when "conferenceleave"
    ahn_log.event_handler.debug("Caller #{event.headers["Channel"]} leaving conference #{event.headers["ConferenceName"]}")
    room = event.headers["ConferenceName"]
    remove_channel(room, event.headers["Channel"])
    play_exit_sound(room)
  end
end

Events.register_callback([:after_initialized]) do |event|
  include Adhearsion::VoIP::Asterisk
  attendees = manager_interface.send_action("KonferenceList")
end
