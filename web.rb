require 'json'
require 'rubygems'
require 'sinatra'
require 'bundler'


Bundler.require :default, Sinatra::Application.environment
set :root, File.dirname(__FILE__)
Dir["./lib/*.rb"].each {|file| require file }
set :partial_template_engine, :haml

plurk = Plurk.new(ENV["PLURK_OAUTH_CONSUMER_KEY"], ENV["PLURK_OAUTH_CONSUMER_SECRET"])

get '/' do
  @plurk = plurk
  @plurk.get_authorize_url(to('/deanonymize'))
  haml :home
end

post '/deanonymize' do
  do_deanonymize plurk
end

get '/deanonymize' do
  do_deanonymize plurk
end

def do_deanonymize plurk
  if params[:oauth_verifier].nil? 
    @access_token = {token:params[:token], secret:params[:secret]}
    plurk.authorize(@access_token[:token], @access_token[:secret])
  else
    auth = plurk.authorize(params[:oauth_verifier])
    @access_token = {token:auth.token, secret:auth.secret}
  end

  @common_friends = nil
  @results = ""
  if !params[:plurk_id].nil?
    @plurk_id = params[:plurk_id]
    plurk_id = @plurk_id.to_i(36)

    if @plurk_json.nil? || @plurk_json.empty?
      @plurk_json = plurk.post('/APP/Timeline/getPlurk', {:plurk_id => plurk_id, :limited_detail=>true, :favorers_detail => true, :replurkers_detail => true})
    else
      @plurk_json = JSON.parse(params[:plurk_json])
    end

    @results += "Commentators: "

    if params[:commenters].nil? || params[:commenters].empty? || params[:commenters]=="null"
      json = plurk.post('/APP/Responses/get', {:plurk_id => plurk_id})
      @commenters = json['friends'].map{|k,v| {id:k, name:v['nick_name'], friends:nil}}
      @results += "{just received}: #{@commenters.inspect}"
    else
      @commenters = JSON.parse(params[:commenters])
      @results += @commenters.map{|c|c['name']}.inspect + "\n\nInvestigation of common friends:\n\nUniversum\n"

      @commenters.each_with_index do |commenter, index|
        if commenter["friends"].nil? || commenter["friends"].empty? || commenter["friends"]=="null"
          friends = []
          i=0
          begin
            friends_json = plurk.post('/APP/FriendsFans/getFriendsByOffset', {user_id: commenter["id"], :limit => 1000, :offset => i})
            friends_buf = friends_json.map{|f| f["nick_name"]}
            friends = friends | friends_buf
            i+= friends_buf.count
          end while friends_buf.count > 0
          friends = friends << commenter["name"]
          @commenters[index]["friends"]=friends
          break
        end
      end

      @common_friends = @commenters[0]["friends"]
      @commenters.each_with_index do |commenter, index|
        if (!commenter["friends"].nil?) && commenter["friends"].count > 0
          @results += "\n& #{@commenters[index]['name']}'s friends: #{commenter['friends']}\n"
          @common_friends = @common_friends & commenter["friends"]
          @results += "= #{@common_friends}\n"
        end
      end        

    end

  end

  haml :deanonymize
  #plurk.authorize(ACCESS_TOKEN, ACCESS_TOKEN_SECRET)
end



