Feature: Access token

Scenario: Validate access token
  # consume access token obtained in config
  * url 'https://example.com'
  * method get
  * status 200

  * match access_token == 'mock oauth2 access token'
