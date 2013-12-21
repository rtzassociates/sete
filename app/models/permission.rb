class Permission
  
  def initialize(user)
    allow :sessions, [:new, :create, :destroy]
    allow :home, [:index]
    if user
      allow :users, [:show]
      allow :uploads, [:new, :create]
      allow :uploads, [:show] do |upload|
        user.id == upload.user.id
      end
      allow :downloads, [:index, :new, :create]
      allow :uploads, [:show, :edit, :update, :destroy, :unshare] do |upload|
        upload.user.id == user.id
      end
      allow_all if user.admin?
    end
  end
  
  def allow_all
    @allow_all = true
  end
  
  def allow(controllers, actions, &block)
    @allowed_actions ||= {}
    Array(controllers).each do |controller|
      Array(actions).each do |action|
        @allowed_actions[[controller.to_s, action.to_s]] = block || true
      end
    end
  end
  
  def allow?(controller, action, resource = nil)
    allowed = @allow_all || @allowed_actions[[controller.to_s, action.to_s]]
    allowed && (allowed == true || resource && allowed.call(resource))
  end
    
end