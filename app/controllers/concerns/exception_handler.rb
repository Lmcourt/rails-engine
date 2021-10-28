module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { message: e.message, errors: 'Record not found' }, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { message: e.message, errors: 'Invalid parameters' }, status: :unprocessable_entity
    end

    rescue_from ActiveRecord::RecordNotDestroyed do |e|
      render json: { errors: e.record.errors }, status: :unprocessable_entity
    end

    rescue_from ActionController::ParameterMissing do |e|
      render json: { errors: 'Missing parameters' }, status: :unprocessable_entity
    end

    rescue_from ActionController::BadRequest do |e|
      render json: { errors: 'Invalid parameters' }, status: 400
    end
  end
end
