class SessionsController < ApplicationController
  def create
    Session.create!(course: Course.find(params[:course_id]))

    render :nothing => true, :status => :created
  end
end
