require_relative 'tagging'

class TagTopic < ActiveRecord::Base
  has_many :taggings,
    class_name: :Tagging,
    primary_key: :id,
    foreign_key: :topic_id

  has_many :tagged_urls,
    through: :taggings,
    source: :shortened_url

  def most_popular_links
    Tagging.joins(:tag_topics).where({topic_id: self.id})
  end
end
