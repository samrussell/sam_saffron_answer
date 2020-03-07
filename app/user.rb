class User
  attr_reader :id
  attr_reader :trust_level

  def initialize(id, trust_level, is_staff, authenticated)
    @id = id
    @trust_level = trust_level
    @is_staff = is_staff
    @authenticated = authenticated
  end

  def is_staff?
    !!@is_staff
  end

  def authenticated?
    !!@authenticated
  end
end