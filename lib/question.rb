class Question
  attr_reader :text, :variants, :right, :point, :time
  def initialize(params)
    @text = params[:text]
    @variants = params[:variants]
    @right = params[:right]
    @point = params[:point]
    @time = params[:time]
  end
end
