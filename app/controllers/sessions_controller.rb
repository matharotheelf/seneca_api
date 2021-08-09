class SessionsController < ApplicationController
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

  def show
    render nothing: true, status: :ok
  end
end
