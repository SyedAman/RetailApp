class AddRequestDateToApprovalQueues < ActiveRecord::Migration[7.1]
  def change
    add_column :approval_queues, :request_date, :datetime
  end
end
