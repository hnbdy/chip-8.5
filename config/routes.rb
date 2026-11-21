Rottenpotatoes::Application.routes.draw do
  resources :movies
  # map '/' to be a redirect to '/movies'
  get '/search', to: 'movies#search_tmdb', as: :search
  root to: redirect('/movies')
  post '/add_movie', to: 'movies#add_movie', as: :add_movie
end
