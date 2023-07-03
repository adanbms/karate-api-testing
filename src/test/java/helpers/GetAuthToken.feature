Feature: Helper to login and get the user auth token needed to create and delete articles

Scenario: Login and get token
    Given url conduitApiUrl
    And path 'users/login'
    And request {"user": {"email": "#(userEmail)","password": "#(userPass)"}}
    When method Post
    Then status 200
    * def authToken = response.user.token