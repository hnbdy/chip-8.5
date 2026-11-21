class Movie < ApplicationRecord
  def self.all_ratings
    %w[G PG PG-13 R]
  end

  def self.with_ratings(ratings, sort_by)
    if ratings.nil?
      all.order sort_by
    else
      where(rating: ratings.map(&:upcase)).order sort_by
    end
  end

  def self.find_in_tmdb(search_terms)
    query = { 
      api_key: ENV['TMDB_KEY'], 
      query: search_terms[:title] 
    }

    if search_terms[:title].present?
      query[:primary_release_year] = search_terms[:release_year]
    end

    response = Faraday.get('https://api.themoviedb.org/3/search/movie', query)

    return [] unless response.status == 200

    result = JSON.parse(response.body)['results'] || []

    if search_terms[:language] == 'en'
      results = result.select do |movie|
        movie['original_language'] == 'en'
      end
    end

    results.filter_map do |movie|
      next if Movie.exists?(title: movie['title'])
      
    Movie.new(
      title: movie['title'],
      rating: 'R',
      release_date: movie['release_date'],
      description: movie['overview']
    )
    end

  end
end

