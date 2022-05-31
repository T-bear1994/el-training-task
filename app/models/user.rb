class User < ApplicationRecord
  before_destroy :must_have_at_least_one_admin
  before_update :at_least_one_admin_before_update
  has_many :tasks, dependent: :destroy
  has_secure_password
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  private

  def must_have_at_least_one_admin
    if User.all.where(admin: true).count == 1 && self.admin
      errors.add(:base, '管理者が0人になるため削除できません')
      throw(:abort)
    end
  end

  def at_least_one_admin_before_update
    if User.all.where(admin: true).count == 1
      errors.add(:base, '管理者が0人になるため変更できません')
      throw(:abort) unless self.admin
    end
  end
end
