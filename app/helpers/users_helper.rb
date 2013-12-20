module UsersHelper
  def allowed_users_for(user)
    if user.admin?
      "Everybody"
    elsif user.allowed_users.empty?
      "Nobody"
    else
      allowed_users = user.allowed_users
      raw allowed_users.map { |u| link_to(u.name, u) }.to_sentence
    end
  end
end