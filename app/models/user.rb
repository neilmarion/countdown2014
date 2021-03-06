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
      Resque.enqueue(ImageUploader, auth['uid'], auth['credentials']['token']) 
      #file_name = ProcessImage.process(auth['uid'])
      #upload_image(auth['credentials']['token'], file_name)
      #ProcessImage.remove_photo(file_name)
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

  def self.upload_image(access_token, file_name)
    @graph = Koala::Facebook::API.new(access_token) 
    @graph.put_picture("#{Rails.root}/tmp/images/#{file_name}.jpg", {'message'=> 'test'})
  end

  def name
    "#{first_name} #{last_name}"
  end

end
