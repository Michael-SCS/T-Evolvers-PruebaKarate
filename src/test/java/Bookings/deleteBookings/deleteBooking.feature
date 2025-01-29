Feature: Test for Delete bookings

  Background:
    * url url_booking
    * def auth = call read('classpath:Bookings/authentication/auth.feature@HappyPath')
    * def token = auth.token
    * header cookie = 'token=' + token


  @happyPath
  Scenario: Delete a booking succesfully
    * def createBooking = call read('classpath:Bookings/createBookings/createBooking.feature@happyPath')
    * def bookingid = createBooking.response.bookingid
    Given path 'booking/' + bookingid
    When method DELETE
    Then status 201

  Scenario: Validar dato eliminado
    * def bookingid = karate.get('bookingid')
    Given path 'booking/' + bookingid
    When method GET
    Then status 404

  @ScenarioAltern
  Scenario: Delete a booking with incorrect id
    Given path 'booking/65465465465465'
    When method DELETE
    Then status 405

  @ScenarioAltern
  Scenario: Attempt to delete a booking that has already been deleted
    * def bookingid = karate.get('bookingid')
    Given path 'booking/' + bookingid
    When method DELETE
    Then status 405

  @ScenarioAltern
  Scenario: Delete a booking without authorization
    * def bookingid = karate.get('bookingid')
    * def invalidToken = 'invalid_token_value'
    * header cookie = 'token=' + invalidToken
    Given path 'booking/' + bookingid
    When method DELETE
    Then status 403



