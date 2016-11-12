defmodule WebPortal.APIEndpointTest do
  use WebPortal.ModelCase

  alias WebPortal.APIEndpoint

  test "url single path param resolving" do
    url = "https://www.google.com/{{ user_id }}/profile"
    url_params = %{"user_id"=>"john_doe"}

    expected = "https://www.google.com/john_doe/profile"
    assert(APIEndpoint.generate_url(url, url_params) == expected)
  end

  test "url multiple path params resolving" do
    url = "https://www.google.com/{{ user_id }}/profile/{{ type }}"
    url_params = %{"user_id"=>"john_doe", "type" => "email"}

    expected = "https://www.google.com/john_doe/profile/email"
    assert(APIEndpoint.generate_url(url, url_params) == expected)
  end

  test "url single param resolving" do
    url = "https://www.google.com/profile"
    url_params = %{"user_id"=>"john_doe"}

    expected = "https://www.google.com/profile?user_id=john_doe"
    assert(APIEndpoint.generate_url(url, url_params) == expected)
  end

  test "url mixed param resolving" do
    url = "https://www.google.com/{{ user_id }}/profile"
    url_params = %{"user_id"=>"john_doe", "type" => "email"}

    expected = "https://www.google.com/john_doe/profile?type=email"
    assert(APIEndpoint.generate_url(url, url_params) == expected)
  end
end