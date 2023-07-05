Feature: Test for singup functionality of Conduit App

Background: 
    Given url conduitApiUrl
* def user = {name:'xy', email: 'xy@z.com', password:'xyz12345'}

@CreateUser
Scenario: Create User
    Given path 'users'
    And request 
    """
        {
            "user": {
                "email": "#(user.name)",
                "password": "#(user.email)",
                "username": "#(user.password)"
            }
        }

    """
    When method POST
    Then status 200