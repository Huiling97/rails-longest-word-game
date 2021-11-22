require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = 10.times.map { ("A".."Z").to_a.sample }
  end

  def score
    retrieved_grid = params[:letters].split(" ")
    @attempt = params[:word]

    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    word_seralized = URI.open(url).read
    attempted_word = JSON.parse(word_seralized)

    attempted_letters = @attempt.upcase.chars
    check = true

    attempted_letters.each do |attempted_letter|
      if (retrieved_grid.include?(attempted_letter))
        retrieved_grid.delete_at(retrieved_grid.index(attempted_letter))
      else
        check = false
      end
    end

    if !check
      @response = "Sorry but the TEST can't be built out of #{params[:letters]}"
    else
      if attempted_word["found"]
        @response = "Congratulations! #{@attempt.capitalize} is a valid English word!"
      else
        @response = "Sorry but #{@attempt} does not seem to be a valid English word..."
      end
    end
  end
end
