Feature: Test for singup functionality of Conduit App

Background: 
    * def dataGen = Java.type("helpers.DataGenerator")
    Given url conduitApiUrl

@CreateUser
Scenario: Create User
    * def name = dataGen.getRandomUserName()
    * def email = dataGen.getRandomEmail()
    Given path 'users'
    And request 
    """
        {
            "user": {
                "email": "#(email)",
                "password": "RandTest1234",
                "username": "#(name)"
            }
        }

    """
    When method POST
    Then status 200
    And match response.user ==
    """
        {
            "email": "#(email)",
            "username": "#(name)",
            "bio": "##string",
            "image": "#string",
            "token": "#string"
        }
    """