class Api::ApprovalQueuesController < ApplicationController
  before_action :set_approval_queue, only: [:approve, :reject]

  def index
    @approval_queues = ApprovalQueue.order(request_date: :asc)
    render json: @approval_queues
  end

  def approve
    @approval_queue.product.update(status: true)
    @approval_queue.destroy
    render json: { message: 'Product approved' }
  end

  def reject
    @approval_queues.destroy
    render json: { message: 'Product rejected' }
  end

  private

  def set_approval_queue
    @approval_queue = ApprovalQueue.find(params[:id])
  end
end
