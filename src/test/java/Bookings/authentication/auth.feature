Feature: Autentication

  Background:
    * url url_booking

  @HappyPath
  Scenario: Autenticación exitosa
    Given path 'auth'
    And request { "username": "admin", "password": "password123" }
    When method POST
    Then status 200
    And def token = response.token
    And print 'Token generado: ' + token
