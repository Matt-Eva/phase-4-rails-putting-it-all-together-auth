class ApplicationController < ActionController::API
  include ActionController::Cookies
rescue_from ActiveRecord::RecordNotFound, with: :not_found
rescue_from ActiveRecord::RecordInvalid, with: :unprocessable

private 

  def not_found(exception)
    render json: {error: "#{exception.model} not found"}, status: :not_found
  end

  def unprocessable(invalid)
    render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def authorize
    return render json: {errors: ["Not authorized"]}, status: :unauthorized unless session.include? :user_id
  end

end
