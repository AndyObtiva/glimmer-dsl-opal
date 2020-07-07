require_relative "contact"

class ContactManager
  class ContactRepository
    NAMES_FIRST = %w[
      Liam
      Noah
      William
      James
      Oliver
      Vivian
      Kaylee
      Sophie
      Brielle
      Madeline
    ]
    NAMES_LAST = %w[
      Smith
      Johnson
      Williams
      Brown
      Jones
      Miller
      Davis
      Wilson
      Anderson
      Taylor
    ]
    def initialize(contacts = nil)
      @contacts = contacts || 10.times.map do |n|
        first_name = NAMES_FIRST[n]
        last_name = NAMES_LAST[n]
        email = "#{first_name}@#{last_name}.com".downcase
        Contact.new(
          first_name: first_name,
          last_name: last_name,
          email: email
        )
      end
    end
  
    def find(attribute_filter_map)
      @contacts.find_all do |contact|
        match = true
        attribute_filter_map.keys.each do |attribute_name|
          contact_value = contact.send(attribute_name).downcase
          filter_value = attribute_filter_map[attribute_name].downcase
          match = false unless contact_value.match(filter_value)
        end
        match
      end
    end
  end
end
