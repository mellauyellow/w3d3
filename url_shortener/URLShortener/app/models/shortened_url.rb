require 'securerandom'

class ShortenedUrl < ActiveRecord::Base
  include SecureRandom

  belongs_to :submitter,
    class_name: :User,
    primary_key: :id,
    foreign_key: :user_id

  has_many :visitations,
    class_name: :Visit,
    primary_key: :id,
    foreign_key: :url_id

  has_many :visitors,
    Proc.new { distinct },
    through: :visitations,
    source: :user

  has_many :taggings,
    class_name: :Tagging,
    primary_key: :id,
    foreign_key: :url_id

  has_many :topics,
    through: :taggings,
    source: :tag_topic

  validates :user_id, :presence => true

  def self.random_code
    code = SecureRandom.urlsafe_base64
    code = SecureRandom.urlsafe_base64 until !ShortenedUrl.exists?(code)
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(long_url: long_url, user_id: user.id, short_url: ShortenedUrl.random_code)
  end

  def num_clicks
    self.visitations.count
  end

  def num_uniques
    self.visitors.select(:user_id).count
  end

  def num_recent_uniques
    self.visitations.select(:user_id).where({created_at: (30.minutes.ago..Time.now)}).distinct.count
  end
end
