require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (0..10).map { ('A'..'Z').to_a[rand(26)] }
    # @letters = []
    # 10.times { @letters << ("A".."Z").to_a.sample }
    # return @letters
  end

  def english_word?
    @word = params[:word]
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    response = open(url).read
    return JSON.parse(response)["found"]
  end

  def included?
    return true if @word.chars.all? { |char| params[:letters].include?(char.upcase) }
  end

  def count?
    return true if @word.chars.all? { |char| params[:letters].chars.count(char) <= params[:letters].split.count(char) }
  end

  def score
    @result = ""
    if english_word? && included? && count?
      @result = "Congratulations! #{@word} is a valid English word!"
    elsif !included? || !count?
      @result = "Sorry but #{@word} can't be built out of #{params[:letters]}"
    else
      @result = "Sorry but #{@word} does not seem to be a valid English word..."
    end
  end
end
