class CreateApprovalQueues < ActiveRecord::Migration[7.1]
  def change
    create_table :approval_queues do |t|
      t.references :product, null: false, foreign_key: true
      t.datetime :request_data

      t.timestamps
    end
  end
end
