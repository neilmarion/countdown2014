class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :omniauthable, :trackable, :validatable, :omniauth_providers => [:facebook, :twitter]

  serialize :latest_feed
  has_many :posts

  validates_presence_of :provider
  validates_presence_of :uid

  def self.from_omniauth(auth)
    a = where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
    if a
      upload_image(auth['credentials']['token'])
      #ProcessImage.echo
    end
    a 
  end

  def self.create_from_omniauth(auth)
    auth['credentials']['token']
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.first_name = auth["info"]["first_name"]
      user.last_name = auth["info"]["last_name"]
      user.username = auth["info"]["nickname"]
      user.email = auth["info"]["email"]
      user.password = Devise.friendly_token[0,20]
    end

  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def self.upload_image(access_token)
    @graph = Koala::Facebook::API.new(access_token) 
    #album_info = @graph.put_object('me','albums', :name=>'test')
    #album_id = album_info['id'] 
    @graph.put_picture("#{Rails.root}/tmp/images/imgp8233_crop.jpg")
  end

  def name
    "#{first_name} #{last_name}"
  end

end
