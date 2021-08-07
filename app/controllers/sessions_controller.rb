class SessionsController < ApplicationController
  def create
    Session.create!(
      {
        course: Course.find(params[:course_id])
      }.merge!(
        params.require(:'stats diff').permit(:sessionId, :totalModulesStudied, :averageScore, :timeStudied)
      )
    )

    render :nothing => true, :status => :created
  end
end
