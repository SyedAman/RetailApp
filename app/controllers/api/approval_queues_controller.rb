module Api
  class ApprovalQueuesController < ApplicationController
    before_action :set_approval_queue, only: [:approve, :reject]

    # GET /api/products/approval-queue
    def index
      @approval_queues = ApprovalQueue.order(request_date: :asc)
      render json: @approval_queues
    end

    # PUT /api/products/approval-queue/:id/approve
    def approve
      approval_queue = ApprovalQueue.find(params[:id])
      approval_queue.product.update(status: true) # Assuming status 'true' means approved
      approval_queue.destroy
      render json: { message: 'Product approved' }, status: :ok
    end

    # PUT /api/products/approval-queue/:id/reject
    def reject
      approval_queue = ApprovalQueue.find(params[:id])
      approval_queue.destroy
      render json: { message: 'Product rejected' }, status: :ok
    end

    private

    def set_approval_queue
      @approval_queue = ApprovalQueue.find(params[:id])
    end
  end
end
