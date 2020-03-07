class Topic
  attr_reader :user_id
  attr_reader :category_id

  def initialize(user_id, category_id, is_closed)
    @user_id = user_id
    @category_id = category_id
    @is_closed = is_closed
  end

  def closed?
    !!@is_closed
  end
end