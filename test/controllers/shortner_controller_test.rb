require 'test_helper'
require 'minitest/stub_const'

class ShortenerControllerTest < ActionDispatch::IntegrationTest
  include EnvHelper

  test "should create a shortned url and return it" do
    password = 'somepass'
    url = 'https://google.com'

    stub_env('PASSWORD', password) do
      post shortener_url, params: {password: password, url: url}
    end

    created_shortener = Shortener::ShortenedUrl.first

    assert(created_shortener.present?)
    assert_equal 200, response.status
    assert_equal alias_url(created_shortener.unique_key), response.body
  end

  test "it should redirect" do
    url = 'https://someurl.com/'
    shortened = Shortener::ShortenedUrl.generate(url)

    get alias_url(shortened.unique_key)

    assert_equal 301, response.status
    assert_equal url, response.redirect_url
  end
end
