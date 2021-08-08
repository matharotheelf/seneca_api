class SessionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :unprocessable_entity_error
  rescue_from ActionController::ParameterMissing, with: :bad_request_error

  def create
    Session.create!(
      {
        course: Course.find(params[:course_id]),
        user: User.find(request.headers[:'X-USER-ID'])
      }.merge!(
        params.require(:'stats diff').permit(:sessionId, :totalModulesStudied, :averageScore, :timeStudied)
      )
    )

    render nothing: true, status: :created
  end

  private

  def unprocessable_entity_error(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def bad_request_error(exception)
    render nothing: true, status: :bad_request
  end
end
