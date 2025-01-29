Feature: Tests for all get bookings and by id

  Background:
    * url url_booking

  @HappyPath
  Scenario: Get all bookings successfully
    Given path 'booking'
    When method GET
    Then status 200
    And print response

  Scenario:validando que el campo exista en la posicion 0
    Given path 'booking'
    And header Accept = 'application/json'
    When method GET
    And def responseAll = response[0].bookingid
    Given path 'booking/' + responseAll
    Then status 200

  @HappyPath
  Scenario: Get a Booking by id Succesfully
    Given def createBooking = call read('classpath:Bookings/createBookings/createBooking.feature@happyPath')
    And def bookingid = createBooking.response.bookingid
    Given path 'booking/' + bookingid
    And header Accept = 'application/json'
    When method GET
    Then status 200
    And match response == read('classpath:Bookings/getBookings/ResponseSchemaGetBooking.json')
    And match response == read('classpath:Bookings/getBookings/ResponseBodyGetBooking.json')

  @ScenarioAltern
  Scenario: Intentar obtener una reserva con un ID inexistente
    Given path 'booking/9999999988542245'
    When method GET
    Then status 404
    And match response == "Not Found"

  @ScenarioAltern
  Scenario: Intentar obtener una reserva con ID no numerico
    //La Api intenta buscar cualquier valor que se le pase en el ID
    Given path 'booking/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa@2!!""35#"!"#$%&&&%$#'
    When method GET
    Then status 404
    And match response == "Not Found"