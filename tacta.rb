
require 'json'

def read_contacts
   json = File.read( 'contacts.json' )
   array = JSON.parse( json, { :symbolize_names => true } )
end

def write_contacts( contacts )
   File.open( "contacts.json", "w" ) do |f|
      json = JSON.pretty_generate( contacts )
      f.write( json  )
   end
end

def index(contacts)
   contacts.each_with_index do |contact, i|
      puts "#{i+1}) #{contact[:name]}"
   end
end

def show( contact )
   puts "#{contact[:name]}"
   puts "phone: #{contact[:phone]}"
   puts "email: #{contact[:email]}"
end

def ask(prompt)
   puts
   print prompt
   gets.chomp
end

def create_new
   contact = {}

   puts
   puts "Enter contact info:"

   contact[:name ] = ask "Name? "
   contact[:phone] = ask "Phone? "
   contact[:email] = ask "Email? "

   contact
end

def action_new(contacts)
  contact = create_new
  contacts << contact

  write_contacts(contacts) #json file

  puts
  puts "New contact created:"
  puts

  show(contact)
  puts
end

def action_show(contacts, i)
  contact = contacts[i-1]

  puts
  show(contact)
  puts
end

def action_delete( contacts )
   puts
   response = ask "Delete which contact? "

   i = response.to_i

   puts
   puts "Contact for #{contacts[i-1][:name]} deleted."

   contacts.delete_at( i-1 )

   write_contacts(contacts) #json file

   puts
end

def action_error
   puts
   puts "Sorry, I don't recognize that command."
   puts
end

def contacts_exists?(contacts, index)
  !contacts[index.to_i-1].nil?
end

loop do
  index(read_contacts)

  response = ask("Who would you like to see? (n for new, d for delete, q to quit) ")
  break if response == "q"
  if response == "n"
      action_new(read_contacts)
  elsif response == "d"
    action_delete(read_contacts)
  elsif response =~ /[0-9]/
    if contacts_exists?(read_contacts, response)
      action_show(read_contacts, response.to_i)
    else
      puts
      puts "That contact does not exists!"
      puts
    end
  else
    action_error
  end
end

puts
puts "Bye!"
