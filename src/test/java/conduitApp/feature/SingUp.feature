Feature: Test for singup functionality of Conduit App

    Background:
        * def dataGen = Java.type("helpers.DataGenerator")
        * def name = dataGen.getRandomUserName()
        * def email = dataGen.getRandomEmail()
        Given url conduitApiUrl

    @CreateUser
    Scenario: Create User (Happy Path)
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

    @CreateUserNegative
    Scenario Outline: Create user with <case>
        Given path 'users'
        And request
            """
            {
                "user": {
                    "email": "<email>",
                    "password": "<password>",
                    "username": "<name>"
                }
            }
            """
        When method POST
        Then status <code>
        And response.errors == <response>

        Examples:
            | case           | email         | name     | password | code | response                                |
            | existing user  | #(email)      | temi1023 | temi1023 | 422  | {"username":["has already been taken"]} |
            | existing email | temi@mail.com | #(name)  | temi1023 | 422  | {"email":["has already been taken"]}    |
            | empty email    |               | #(name)  | temi1023 | 422  | {"email":["can't be blank"]}            |
            | empty user     | #(email)      |          | temi1023 | 422  | {"username":["can't be blank"]}         |
            | empty password | #(email)      | #(name)  |          | 422  | {"password":["can't be blank"]}         |