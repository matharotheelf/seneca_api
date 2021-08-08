class SessionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :unprocessable_entity_error

  def create
    Session.create!(
      {
        course: Course.find(params[:course_id]),
        user: User.find(request.headers[:'X-USER-ID'])
      }.merge!(
        params.require(:'stats diff').permit(:sessionId, :totalModulesStudied, :averageScore, :timeStudied)
      )
    )

    render :nothing => true, :status => :created
  end


  def unprocessable_entity_error
    render :nothing => true, :status => :unprocessable_entity
  end
end
