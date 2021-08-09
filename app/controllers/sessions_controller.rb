# frozen_string_literal: true

# handles requests to query or persist session data
class SessionsController < ApplicationController
  def create
    Session.create!({ course: course, user: user }.merge!(stats_diff_data))

    render nothing: true, status: :created
  end

  def show
    render json: session_stats, status: :ok
  end

  private

  def session_stats
    {
      sessionId: session.sessionId,
      totalModulesStudied: session.totalModulesStudied,
      averageScore: session.averageScore,
      timeStudied: session.timeStudied
    }
  end

  def stats_diff_data
    params.require(:'stats diff').permit(:sessionId, :totalModulesStudied, :averageScore, :timeStudied)
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
