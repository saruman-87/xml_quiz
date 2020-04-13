require_relative "lib/question"
require_relative "lib/game.rb"
require "timeout"

xml_file = File.new("#{__dir__}/data/data.xml")
game = Game.from_xml_file(xml_file)

game.questions.each_with_index do |question, index|
  puts "#{index + 1}. #{question.text}"
  puts "(За верный ответ: #{question.point} баллов | На ответ #{question.time} секунд)"
  #Выводим варианты ответа
  question.variants.each_with_index do |variant, index|
    puts "   #{index + 1} - #{variant}"
  end
  #Время на ответ пользователя
  limit_time = question.time
  user_choise = nil
  begin
    Timeout::timeout limit_time do
      user_choise = gets.to_i
    end
  rescue Timeout::Error
    puts "Время вышло..."
  end
  #Передаем данные и проверям ответ верный или нет
  if game.play(question, user_choise)
    puts "Верно!!"
  else
    puts "Ошибка ¯\\_(ツ)_/¯"
  end
  puts "У Вас #{game.points} баллов"
end
puts "Правильных ответов #{5 - game.errors} из 5"
