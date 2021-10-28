class ApplicationController < ActionController::API
  include ExceptionHandler

  private

  def per_page
    page_size = params.fetch(:per_page, 20).to_i
    if params[:per_page].to_i > 0
      page_size
    else
      20
    end
  end

  def page
    if params[:page].to_i > 0
      params.fetch(:page, 1).to_i - 1
    else
      0
    end
  end
end
