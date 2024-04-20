@ignore
Feature: oauth2

Scenario: Obtain oauth2 token
  * url 'https://example.com'
  * method get
  * status 200

  # Mock data here. In real use case, use the access token from response
  * def access_token = 'mock oauth2 access token'
