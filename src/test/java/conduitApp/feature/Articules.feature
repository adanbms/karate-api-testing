Feature: Articules for Conduit APP

Background: Login and get token
    Given url conduitApiUrl

@ignore
Scenario: Create a new article
    Given path 'articles/'
    And request 
    """
        {
            "article": {
                "tagList": [],
                "title": "Karate Test",
                "description": "Test from Karate",
                "body": "Made with cucumber too."
            }
        }
    """
    When method Post
    Then status 200
    And match response.article.title == 'Karate Test'

@DeleteArticle
Scenario: Create and Delete Article
    Given path 'articles'
    And request
    """
        {
            "article": {
                "tagList": [],
                "title": "Karate Test Delete",
                "description": "Test from Karate",
                "body": "Made with cucumber too."
            }
        }
    """
    When method Post
    Then status 200
    And match response.article.title == 'Karate Test Delete'
    * def articleId = response.article.slug

    Given params {limit:10, offset:0}
    And path 'articles'
    When method Get
    Then status 200
    And match response.articles[0].title == 'Karate Test Delete'

    Given path 'articles',articleId
    When method Delete
    Then status 204

    Given params {limit:10, offset:0}
    And path 'articles'
    When method Get
    Then status 200
    And match response.articles[0].title != 'Karate Test Delete'

@CreateJson
Scenario: Create a new article using json file
    * def dataGenerator = Java.type("helpers.DataGenerator")
    * def randomDataObj = dataGenerator.getRandomArticle()
    * def requetBody = read("classpath:conduitApp/json/CreateArticleRequest.json")
    
    * set requetBody.article.title = randomDataObj.title
    * set requetBody.article.description = randomDataObj.description
    * set requetBody.article.body = randomDataObj.body

    Given path 'articles/'
    And request requetBody
    When method Post
    Then status 200
    And match response.article.title == requetBody.article.title