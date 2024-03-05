class ApprovalQueue < ApplicationRecord
  belongs_to :product, optional: true
  # @TODO: Verify with product -- since we want to delete a product and add it to the approval queue, we don't want to validate the presence of the product
  # validates :product, presence: true
end
