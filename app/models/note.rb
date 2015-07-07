class Note < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  before_save  :sanitize_inputs
  validates :user_id, presence: true
  validates :text, presence: true

  def author
    user.username
  end

  def sanitize_inputs
    self.text =  Rack::Utils.escape_html(self.text) unless self.text.nil?
  end

  def get_votes
    votes_hash = {}
    comments.each do |comment|
      if comment.vote_kind
        if votes_hash[comment.vote_kind.to_sym]
          votes_hash[comment.vote_kind.to_sym] += 1
        else
          votes_hash[comment.vote_kind.to_sym] = 1
        end
      end
    end
    votes_hash
  end

  def top_vote_type
    result = :neutral
    vote_types = get_votes
    vote_types[:neutral] = 0
    vote_types.each do |vote_type_key, vote_type_value|
      result = vote_type_key if vote_type_value > vote_types[result]
    end
    result.to_s
  end
  
end