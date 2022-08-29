class ShortenersController < ApplicationController
  before_action :validate_password, only: :create
  skip_before_action :verify_authenticity_token

  def create
    url =  ActiveRecord::Base::sanitize_sql(params[:url])
    shortener = Shortener::ShortenedUrl.generate(url)

    render plain: alias_url(shortener.unique_key)
  end

  def show
    shortener = Shortener::ShortenedUrl.fetch_with_token(token: params[:alias])

    redirect_to shortener[:url], status: 301, allow_other_host: true
  end

  private


  def validate_password
    params_password = params[:password]
    password = ENV['PASSWORD'] || ''
    valid = ActiveSupport::SecurityUtils.secure_compare(password, params_password)

    if password.blank? || !valid
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
