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
    #A variation of that is contains only expression

@GetArticles
Scenario: Get 10 articles from the page
    Given params {limit:10, offset:0}
    Given path 'articles'
    When method Get
    Then status 200
    And match response == {"articles": '#array', "articlesCount": '##number'}
    And match response.articlesCount != 100
    And match response.articles[0].createdAt !contains '1997'
    And match response.articles[*].favoritesCount contains 1216
    And match response..bio contains null
    And match each response..username != null
