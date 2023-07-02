Feature: Helper to login and get the user auth token needed to create and delete articles

Scenario: Login and get token
    Given url 'https://api.realworld.io/api'
    And path 'users/login'
    And request {"user": {"email": "bmerino@test.com","password": "bmerino1234"}}
    When method Post
    Then status 200
    * def authToken = response.user.token