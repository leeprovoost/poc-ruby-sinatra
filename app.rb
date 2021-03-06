require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'sinatra/activerecord' 

db = URI.parse('postgres://postgres:@localhost/videos')

# More info on ActiveRecord http://guides.rubyonrails.org/active_record_basics.html
ActiveRecord::Base.establish_connection(
  :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  :host     => db.host,
  :username => db.user,
  :password => db.password,
  :database => db.path[1..-1],
  :encoding => 'utf8'
)

class Video < ActiveRecord::Base
end

["/", "/list"].each do |path|
  get path do
  	@videos = Video.all.order('id DESC')
    erb :list
  end
end

get '/add' do
	erb :add
end

post '/add' do
	video = Video.create(	title: params[:title],
							description: params[:description],
							video_id: params[:video_id],
							genre: params[:genre] )
	redirect to('/list')
end