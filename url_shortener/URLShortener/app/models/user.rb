class User < ActiveRecord::Base
  has_many :submitted_urls,
    class_name: :ShortenedUrl,
    primary_key: :id,
    foreign_key: :user_id

  has_many :visited_urls,
    Proc.new { distinct },
    class_name: :Visit,
    primary_key: :id,
    foreign_key: :user_id

  validates :email, :presence => true, :uniqueness => true
end
