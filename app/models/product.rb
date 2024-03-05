class Product < ApplicationRecord
  has_one :approval_queue
  validates :name, presence: true
  validates :price, presence: true, numericality: { less_than_or_equal_to: 10000 }
  validate :price_change_for_approval, on: :update

  private

  def price_change_for_approval
    if price_changed? && (price > (price_was * 1.5))
      # @TODO: logic to add to approval queue
    end
  end
end
