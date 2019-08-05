require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @grid = []
    10.times { @grid << ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].upcase
    if english?(@word)
      @score = "Congratulations! #{@word} is a valid English word!"
    elsif !in_grid?
      @score = "#{@word} is not in the grid!"
    else
      @score = "Sorry but #{@word} does not seem to be a valid English word..."
    end
  end

  private

  def english?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    read_response = open(url).read
    response = JSON.parse(read_response)
    response['found']
  end

  def in_grid?
    @grid_letters = params[:grid].split('')
    @word_letters = @word.split('')
    @word_letters.each do |letter|
      if @grid_letters.include?(letter)
        @grid_letters.delete_at(@grid_letters.index(letter))
      else
        return false
      end
      return true
    end
  end
end
