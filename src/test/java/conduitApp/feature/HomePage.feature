Feature: Test for the home page

Background: Define URL
	Given url conduitApiUrl

@GetTags
Scenario: Get all tags
    Given path 'tags'
    When method Get
    Then status 200
    And match response.tags == '#array'
    And match response.tags == '#[10]'
    And match response.tags contains 'welcome'
    And match response.tags[0] == '#string'
    And match each response.tags == '#string'
    And match response.tags contains any ['fish', 'dog', 'welcome']
    And match response.tags !contains 'truck'

@GetArticles
Scenario: Get 10 articles from the page
    * def timeValidator = read("classpath:helpers/time-validator.js")

    Given params {limit:10, offset:0}
    And path 'articles'
    When method Get
    Then status 200
    And match response == {"articles": '#array', "articlesCount": '##number'}
    And match each response.articles == 
    """
        {
            "slug": "#string",
            "title": "#string",
            "description": "#string",
            "body": "#string",
            "tagList": '#array',
            "createdAt": '#? timeValidator(_)',
            "updatedAt": '#? timeValidator(_)',
            "favorited": '#boolean',
            "favoritesCount": '#number',
            "author": {
                "username": "#string",
                "bio": '##string',
                "image": "#string",
                "following": '#boolean'
            }
        }
    """
