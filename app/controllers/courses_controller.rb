class CoursesController < ApplicationController
  def show
    render json: course_lifetime_stats, status: :ok
  end

  private

  def course_lifetime_stats
    {
      totalModulesStudied: course.total_modules_by_user(user),
      averageScore: course.average_score_by_user(user),
      timeStudied: course.time_studied_by_user(user)
    }
  end

  def course
    @course ||= Course.find(params[:id]) 
  end

  def user
    @user ||= User.find(request.headers[:'X-USER-ID']) 
  end
end
