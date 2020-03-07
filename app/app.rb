require './app/site_setting'

class App
  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def allow_accepted_answers_on_category?(category_id)
    category_id == :allow_accepted_answers
  end

  def is_staff?
    current_user.is_staff?
  end

  def authenticated?
    current_user.authenticated?
  end

  def can_accept_answer?(topic)
    if topic_cant_be_answered?(topic)
      return false
    elsif user_can_override?
      return true
    elsif user_can_accept?(topic)
      return true
    end
  end

  def topic_cant_be_answered?(topic)
    !(topic && allow_accepted_answers_on_category?(topic.category_id))
  end

  def user_can_override?
    return false unless authenticated?

    return is_staff? || (current_user.trust_level >= SiteSetting.accept_all_solutions_trust_level)
  end

  def user_can_accept?(topic)
    return (!topic.closed? && topic.user_id == current_user.id)
  end
end
