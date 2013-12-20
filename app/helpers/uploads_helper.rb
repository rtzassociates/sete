module UploadsHelper
  def users_for(upload)
    shared_with = upload.shared_with 
    shared_with -= Array(current_user) if upload.user.is?(current_user)
    shared_with.blank? ? "Nobody" : raw(shared_with.map { |u| link_to(u.name, u) }.to_sentence)
  end
end
