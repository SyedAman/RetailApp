class RemoveProductForeignKeyFromApprovalQueue < ActiveRecord::Migration[7.1]
  def change
    # Replace :approval_queues and :products with your table names if they are different
    # Replace :product_id with the actual foreign key column name if it's different
    # @TODO: Clarify with product whether we want to delete the product AND add to approval queue, or just add to approval queue and then delete when approved
    # @TODO: Right now, we are adding to approval queue and then deleting the product, which requires some adjustments to the model
    # @TODO: Alternative solution: soft delete the product instead of destroying it: @product.update(is_deleted: true) # or `deleted_at: Time.current` if using a timestamp
    remove_foreign_key :approval_queues, :products
  end
end
