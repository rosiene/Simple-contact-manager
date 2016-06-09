require 'sinatra'
require './contacts_file'

set :port, 4567

get '/' do
  "<h1>Tacta Contact Manager</h1>
  <a href=\"/contacts\">Contacts</a>"
end

get '/contacts' do
  @contacts = read_contacts
  erb :'contacts/index'
end

post '/contacts/search' do
  @text = params[:text_search]
  @contacts = []
  read_contacts.each do |contact|
    if contact[:name].upcase.index(params[:text_search].upcase) != nil
      @contacts << contact
    end
  end
  erb :'contacts/search'
end

get '/contacts/new' do
  erb :'contacts/new'
end

get '/contacts/:id/edit' do
  @id = params[:id].to_i

  contacts = read_contacts
  @contact = contacts.select { |contact| contact[:id] == @id }.first

  erb :'contacts/edit'
end

post '/contacts/:id/update' do
  id = params[:id].to_i

  updated_contact = {
    id: params[:id].to_i,
    name: params[:name],
    phone: params[:phone],
    email: params[:email]
  }

  contacts = read_contacts

  index = contacts.rindex { |contact| contact[:id] == id }

  contacts[index] = updated_contact
  write_contacts( contacts )

  redirect "/contacts/#{id}"
end

get '/contacts/:id/delete' do
  id = params[:id].to_i

  contacts = read_contacts
  index = contacts.rindex { |contact| contact[:id] == id }

  contacts.delete_at( index )
  write_contacts( contacts )

  redirect "/contacts"
end

get '/contacts/:id' do
  id = params[:id].to_i
  @contact = get_contact(id)
  erb :'contacts/show'
end

post '/contacts' do
  id = get_next_id

  new_contact = {
    id: id,
    name:  params[:name],
    phone: params[:phone],
    email: params[:email]
  }

  contacts = read_contacts
  contacts << new_contact
  write_contacts( contacts )

  redirect "/contacts/#{id}"
end

#return contact by id
def get_contact(id)
  contacts = read_contacts
  contacts.select { |contact| contact[:id] == id }.first
end

#return next id in the contacts
def get_next_id
  id = 0
  contacts = read_contacts
  contacts.each do |contact|
    if id < contact[:id]
      id = contact[:id]
    end
  end
  id + 1
end
