class Task < ApplicationRecord
  belongs_to :user
  has_many :labellings, dependent: :destroy
  has_many :labels, through: :labellings

  validates :title, presence: true
  validates :content, presence: true
  validates :deadline_on, presence: true
  validates :priority, presence: true
  validates :status, presence: true

  enum priority: { 低: 0, 中: 1, 高: 2 }
  enum status: { 未着手: 0, 着手中: 1, 完了: 2 }

  scope :search_index, -> (search_params) do
    return if search_params.blank?

    status_is(search_params[:status])
      .title_like(search_params[:title])
  end
  scope :status_is, -> (status) { where(status: status) if status.present? }
  scope :title_like, -> (title) { where('title LIKE ?', "%#{title}%") if title.present? }
  scope :ordered_by_created_at, -> { order(created_at: "DESC") }
  scope :sort_deadline_on, -> { order(deadline_on: "ASC") }
  scope :sort_priority, -> { order(priority: "DESC") }
  
end
