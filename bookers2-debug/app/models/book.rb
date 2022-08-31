class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :view_counts, dependent: :destroy
  has_many :book_tags, dependent: :destroy
  has_many :tags ,through: :book_tags

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  
  def save_tags(savebook_tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - savebook_tags
    new_tags = savebook_tags - current_tags
    
    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name:old_name)
    end
    
    new_tags.each do |new_name|
      book_tag = Tag.find_or_create_by(name:new_name)
      self.tags << book_tag
    end
  end

  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end

  #日付別表示
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  scope :created_yesterday, -> {where(created_at: 1.day.ago.all_day) }
  scope :created_2days, -> {where(created_at: 2.day.ago.all_day) }
  scope :created_3days, -> {where(created_at: 3.day.ago.all_day) }
  scope :created_4days, -> {where(created_at: 4.day.ago.all_day) }
  scope :created_5days, -> {where(created_at: 5.day.ago.all_day) }
  scope :created_6days, -> {where(created_at: 6.day.ago.all_day) }

  scope :created_this_week, -> {where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
  scope :created_last_week, -> {where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }

end


