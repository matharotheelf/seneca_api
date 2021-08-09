class SessionsController < ApplicationController
  def create
    Session.create!(
      {
        course: course,
        user: user
      }.merge!(
        params.require(:'stats diff').permit(:sessionId, :totalModulesStudied, :averageScore, :timeStudied)
      )
    )

    render nothing: true, status: :created
  end

  def show
    render json: session_stats, status: :ok
  end

  private

  def session_stats
    {
      totalModulesStudied: session.totalModulesStudied,
      averageScore: session.averageScore,
      timeStudied: session.timeStudied
    }
  end

  def session
    Session.find_by!(sessionId: params[:id], course: course, user: user)
  end

  def course
    @course ||= Course.find(params[:course_id]) 
  end

  def user
    @user ||= User.find(request.headers[:'X-USER-ID']) 
  end
end
