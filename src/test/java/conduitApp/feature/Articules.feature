Feature: Articules for Conduit APP

Background: Login and get token
    Given url 'https://api.realworld.io/api'
    # Given path 'users/login'
    # And request {"user": {"email": "bmerino@test.com","password": "bmerino1234"}}
    # When method Post
    # Then status 200
    # * def token = response.user.token
    * def callResult = call read('classpath:helpers/GetAuthToken.feature')
    * def token = callResult.authToken

@CreateArticle
Scenario: Create a new article
    Given header authorization = 'Token ' + token
    And path 'articles/'
    And request {"article": {"tagList": [],"title": "Karate Test","description": "Test from Karate","body": "Made with cucumber too."}}
    When method Post
    Then status 200
    And match response.article.title == 'Karate Test'

@DeleteArticle
Scenario: Create and Delete Article
    Given header authorization = 'Token ' + token
    And path 'articles'
    And request {"article": {"tagList": [],"title": "Karate Test Delete","description": "Test from Karate","body": "Made with cucumber too."}}
    When method Post
    Then status 200
    And match response.article.title == 'Karate Test Delete'
    * def articleId = response.article.slug

    Given header authorization = 'Token ' + token
    And params {limit:10, offset:0}
    And path 'articles'
    When method Get
    Then status 200
    And match response.articles[0].title == 'Karate Test Delete'

    Given header authorization = 'Token ' + token
    And path 'articles',articleId
    When method Delete
    Then status 204

    Given header authorization = 'Token ' + token
    And params {limit:10, offset:0}
    And path 'articles'
    When method Get
    Then status 200
    And match response.articles[0].title != 'Karate Test Delete'


