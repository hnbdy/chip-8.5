require 'rails_helper'
require 'spec_helper'

describe Movie do
  describe 'searching TMDB by keyword' do
    it 'calls Faraday' do
      expect(Faraday).to receive(:get).and_call_original
      Movie.find_in_tmdb({title: 'hacker', language: 'en'})
    end

    it 'returns matching movies' do
        movies = Movie.find_in_tmdb({title: 'hacker', language: 'en'})
    
        expect(movies.first.title).to eq('Sydney 2000 Olympics Opening Ceremony')
        expect(movies.first.rating).to eq('R')
    end
  end
end