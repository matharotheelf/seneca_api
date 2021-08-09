# frozen_string_literal: true

# application wide controller functionality
class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :unprocessable_entity_error
  rescue_from ActionController::ParameterMissing, with: :bad_request_error

  private

  def unprocessable_entity_error(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def bad_request_error(exception)
    render json: { error: exception.message }, status: :bad_request
  end
end
