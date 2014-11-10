require 'sinatra'
require 'httparty'

set :static, true

mashable_data  = HTTParty.get('http://mashable.com/stories.json')

new_stories    = mashable_data['new']
rising_stories = mashable_data['rising']
hot_stories    = mashable_data['hot'] 

all_stories    = mashable_data.values_at('new', 'rising', 'hot').flatten(1)

story_categories = mashable_data.keys

categories = story_categories.pop

new_titles = new_stories.each do |story|
	story["title"]
end

get '/' do
	@categories = story_categories
	erb :home
end

get '/new' do
	@new_stories = new_stories
	erb :new
end

get '/rising' do
	@rising_stories = rising_stories
	erb :rising
end

get '/hot' do
	@hot_stories = hot_stories
	erb :hot
end

get '/results' do
	@current_id = params['id']
	all_stories.each do |story|
		if story['_id'] == @current_id
			@current_story = {
				title: story['title'],
				author: story['author'],
				text: story['content']['plain'].gsub("\n\n", "<br><br>"),
				image: story['feature_image']
			}
			break
		end
	end

	erb :results
end

