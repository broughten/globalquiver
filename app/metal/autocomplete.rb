require 'sinatra'

class Autocomplete < Sinatra::Application

  get '/autocomplete/style/name' do
    find_options = { 
      :conditions => [ "LOWER(name) LIKE ?", '%' + params[:q].downcase + '%' ], 
      :limit => 10 }
      # the .collect(&:name) puts the names of the styles into the @items array
    @items = Style.find(:all, find_options).collect(&:name)
    @items.join("\n")
  end
end