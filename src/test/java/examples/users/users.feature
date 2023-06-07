@parallel=false
Feature: Test for use-cases for User model

  Background:

    * url 'https://petstore.swagger.io/v2/'
    * def username = 'chardan25'
    * def password = 'carlos123'
    * def userJson =
    """
    [
      {
        username:  '#(username)',
        firstName: 'Fernando',
        lastName:  'Moreira',
        email: 'chardan25@hotmail.com',
        password: '#(password)',
        phone: '12345789',
        userStatus: 0
      }
    ]
    """

  Scenario: Create an user with Array and retrieve it
    # Create User
    Given path 'user/createWithArray'
    And header Content-Type = 'application/json'
    And request userJson
    When method post
    Then status 200
    And match response.message == 'ok'
    And match response.code == 200

    # Retrieve user
    Given path 'user/' + username
    When method get
    Then status 200
    And match response.username == username
    And match response.firstName == 'Fernando'
    And match response.lastName == 'Moreira'
    And match response.email == 'chardan25@hotmail.com'

  Scenario: Update user name and email and retrieve it
    # Retrieve user
    Given path 'user/' + username
    When method get
    Then status 200

    * def userId = response.id
    * def userUpdate =
    """
      {
        id: '#(userId)',
        username:  '#(username)',
        firstName: 'Carlitos',
        lastName:  'Salazar123',
        email: 'carlosprueba@prueba.com',
        password: '#(password)',
        phone: '12345789',
        userStatus: 0
      }
    """

    # Update User
    Given path 'user/' + username
    And request userUpdate
    When method put
    Then status 200
    And match response.code == 200

    # Retrieve User
    Given path 'user/' + username
    When method get
    Then status 200
    And match response.firstName == 'Carlitos'
    And match response.lastName == 'Salazar123'
    And match response.email == 'carlosprueba@prueba.com'

  Scenario: delete user
    Given path 'user/' + username
    When method delete
    Then status 200
    And match response.message == username