require_relative "question.rb"
require "rexml/document"

class Game
  COUNT_QUESTION = 5
  attr_accessor :questions, :status, :points, :errors
  def initialize(questions = [])
    @questions = questions.sample(COUNT_QUESTION)
    @errors = 0
    @points = 0
  end
  def self.from_xml_file(path_xml)
    xmldoc = REXML::Document.new(path_xml)
    question_tags = REXML::XPath.match(xmldoc, "//questions/question")
    #Вспомогательная переменная куда закинем все экземляры класса Question
    all_questions = []
    question_tags.each do |question|
      #Текст вопроса
      text =  question.elements["text"].text
      #Варианты ответа
      variants = []
      #Правильный ответ
      right = nil
      #Балл за правильный ответ на данный вопрос
      point = question.attribute("point").to_s.to_i
      #Время в секундах на вопрос
      time = question.attribute("time").to_s.to_i
      question.each_element("variants/variant") do |variant|
        if variant.has_attributes?
          right = variant.text
        end
        variants << variant.text
      end
      all_questions << Question.new(text: text, variants: variants, right: right, point: point, time: time)
    end
    self.new(all_questions)
  end
  def play(question, user_choise)
    if user_choise == nil
      @errors += 1
      return false
    end
    if question.right == question.variants[user_choise - 1]
      @points += question.point
      return true
    else
      @errors += 1
      return false
    end
  end
end
