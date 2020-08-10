require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @attempt = params[:word]
    @letters = params[:letters]
    @grid = @letters.chars
    @english_word = english_word?(@attempt)
    @message = score_and_message(@attempt, @letters)
    end
  end


private

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def score_and_message(attempt, grid)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        return "well done! You win!"
      else
        return "sorry but #{attempt} is not an english word"
      end
    else
      return "sorry bro' but #{attempt} is not in the grid"
    end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end



