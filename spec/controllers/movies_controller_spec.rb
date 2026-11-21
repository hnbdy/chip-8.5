require 'rails_helper'

describe MoviesController, type: :controller do
    describe 'searching TMDb' do
      before :each do
        @fake_results = [double('movie1'), double('movie2')]
      end
      it 'calls the model method that performs TMDb search' do
        expect(Movie).to receive(:find_in_tmdb).with({ title: 'hardware', language: 'all' }).
         and_return(@fake_results)
        get :search_tmdb, params: { title: 'hardware', language: 'all' }
     end
     describe 'after valid search' do
       before :each do
         allow(Movie).to receive(:find_in_tmdb).and_return(@fake_results)
         get :search_tmdb, params: { title: 'hardware', language: 'all' }
       end
       it 'selects the Search Results template for rendering' do
         expect(response).to render_template('search_tmdb')
       end
       it 'makes the TMDb search results available to that template' do
         expect(assigns(:movies)).to eq(@fake_results)
       end
     end
   end

    describe 'adding a movie' do
        it 'saves the movie to the database' do
            expect {
            post :add_movie, params: {
                title: 'New Test Movie',
                rating: 'R',
                release_date: '2000-09-15'
            }
            }.to change(Movie, :count).by(1)

            expect(response).to redirect_to(search_path)
            expect(flash[:success]).to eq(
            'New Test Movie was successfully added to RottenPotatoes.'
            )
        end
    end
 end
