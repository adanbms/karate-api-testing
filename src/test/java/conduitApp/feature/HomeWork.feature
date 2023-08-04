@hw
Feature: Home Work

    Background: Preconditions
        * url conduitApiUrl
        * def timeValidator = read("classpath:helpers/time-validator.js")

    Scenario: Favorite articles
        # Step 1: Get atricles of the global feed
        Given params {limit:10, offset:0}
        And path 'articles'
        When method Get
        Then status 200

        # Step 2: Get the favorites count and slug ID for the first arice, save it to variables
        * def favoritesCount = response.articles[0].favoritesCount
        * def slugId = response.articles[0].slug

        # Step 3: Make POST request to increse favorites count for the first article
        Given path 'articles/' + slugId + '/favorite'
        When method Post
        Then status 200

        # Step 4: Verify response schema
        And match response.article ==
            """
            {
                "id": "#number",
                "slug": "#(slugId)",
                "title": "#string",
                "description": "#string",
                "body": "#string",
                "createdAt": "#? timeValidator(_)",
                "updatedAt": "#? timeValidator(_)",
                "authorId": "#number",
                "tagList": "#array",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": "#boolean"
                },
                "favoritedBy": "#array",
                "favorited": "#boolean",
                "favoritesCount": "#number"
            }
            """
        And match each response.article.tagList == "#string"
        And match each response.article.favoritedBy ==
            """
            {
                "id": "#number",
                "email": "#string",
                "username": "#string",
                "password": "#string",
                "image": "#string",
                "bio": "##string",
                "demo": "#boolean"
            }
            """

        # Step 5: Verify that favorites article incremented by 1
        And match response.article.favoritesCount == favoritesCount + 1

        # Step 6: Get all favorite articles
        Given path 'articles'
        When method Get
        Then status 200

        # Step 7: Verify response schema
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

        # Step 8: Verify that slug ID from Step 2 exist in one of the favorite articles
        And match response.articles[*].slug contains slugId

        # Step 9: Quit favorite added by us and return article to initial values
        Given path 'articles/' + slugId + '/favorite'
        When method Delete
        Then status 200
        And assert response.article.favoritesCount == favoritesCount

    Scenario: Comment articles
        # Step 1: Get atricles of the global feed
        Given path 'articles'
        When method Get
        Then status 200

        # Step 2: Get the slug ID for the first arice, save it to variable
        * def slugId = response.articles[0].slug

        # Step 3: Make a GET call to 'comments' end-point to get all comments
        Given path 'articles/' + slugId + '/comments'
        When method Get
        Then status 200

        # Step 4: Verify response schema
        And match each response.comments ==
            """
            {
                "id": "#number",
                "createdAt": "#? timeValidator(_)",
                "updatedAt": "#? timeValidator(_)",
                "body": "#string",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": "#boolean"
                }
            }
            """

        # Step 5: Get the count of the comments array lentgh and save to variable
        * def commentsCount = response.comments.length

        # Step 6: Make a POST request to publish a new comment
        * def commentText = 'Testing comment.'
        Given path 'articles/' + slugId  + '/comments'
        And request {comment: {body: "#(commentText)"}}
        When method Post
        Then status 200

        # Step 7: Verify response schema that should contain posted comment text
        And match response.comment == 
            """
            {
                "id": "#number",
                "createdAt": "#? timeValidator(_)",
                "updatedAt": "#? timeValidator(_)",
                "body": "#(commentText)",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": "#boolean"
                }
            }
            """

        * def commentId = response.comment.id

        # Step 8: Get the list of all comments for this article one more time
        Given path 'articles/' + slugId  + '/comments'
        When method Get
        Then status 200

        # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
        And assert response.comments.length == commentsCount+1

        # Step 10: Make a DELETE request to delete comment
        Given path 'articles/' + slugId  + '/comments/' + commentId
        When method Delete
        Then status 200

        # Step 11: Get all comments again and verify number of comments decreased by 1
        Given path 'articles/' + slugId  + '/comments'
        When method Get
        Then status 200
        And assert response.comments.length == commentsCount