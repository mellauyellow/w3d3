class Visit < ActiveRecord::Base
  belongs_to :shortened_url,
    class_name: :ShortenedUrl,
    primary_key: :id,
    foreign_key: :url_id

  belongs_to :user,
    class_name: :User,
    primary_key: :id,
    foreign_key: :user_id

  validates :url_id, :user_id, :presence => true

  def self.record_visit!(user, shortened_url)
    Visit.create!(user_id: user.id, url_id: shortened_url.id)
  end
end
