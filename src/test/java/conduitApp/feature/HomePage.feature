Feature: Test for the home page

Background: Define URL
	Given url conduitApiUrl

Scenario: Get all tags
    Given path 'tags'
    When method Get
    Then status 200
    And match response.tags == '#array'
    And match response.tags == '#[10]'
    And match response.tags contains 'welcome'
    And match response.tags[0] == '#string'
    And match each response.tags == '#string'

Scenario: Get 10 articles from the page
    Given params {limit:10, offset:0}
    Given path 'articles'
    When method Get
    Then status 200