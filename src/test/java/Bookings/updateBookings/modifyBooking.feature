Feature: Test for Modify a booking

  Background:
    * url url_booking

  @HappyPath
  Scenario: Autenticarse y cambiar un booking
    * def auth = call read('classpath:Bookings/authentication/auth.feature@HappyPath')
    And def token = auth.token
    And header Content-Type = 'application/json'
    And header accept = 'application/json'
    And header cookie = 'token=' + token
    * def createBooking = call read('classpath:Bookings/createBookings/createBooking.feature@happyPath')
    * def bookingid = createBooking.response.bookingid
    Given path 'booking/' + bookingid
    And def bodyrequest = read('classpath:Bookings/updateBookings/RequestBodyModifyBooking.json')
    And request bodyrequest
    When method PUT
    Then status 200

    @ScenarioAltern
    Scenario:Añadir un dato con un valor que no pertenece al tipo de dato 500
        * def auth = call read('classpath:Bookings/authentication/auth.feature@HappyPath')
        And def token = auth.token
        And header Content-Type = 'application/json'
        And header accept = 'application/json'
        And header cookie = 'token=' + token
        * def createBooking = call read('classpath:Bookings/createBookings/createBooking.feature@happyPath')
        * def bookingid = createBooking.response.bookingid
        Given path 'booking/' + bookingid
        And def bodyrequest = read('classpath:Bookings/updateBookings/RequestBodyModifyBookingInt.json')
        And request bodyrequest
        When method PUT
        Then status 500


    @ScenarioAltern
    Scenario: Edit a booking with a null data 400
      * def auth = call read('classpath:Bookings/authentication/auth.feature@HappyPath')
      * def token = auth.token
        * header Content-Type = 'application/json'
        * header accept = 'application/json'
        * header cookie = 'token=' + token
      * def createBooking = call read('classpath:Bookings/createBookings/createBooking.feature@happyPath')
        * def bookingid = createBooking.response.bookingid
        Given path 'booking/' + bookingid
        * def bodyrequest = read('classpath:Bookings/updateBookings/RequestBodyModifyBookingNull.json')
        And request bodyrequest
        When method PUT
        Then status 400


        @ScenarioAltern
        Scenario: Enviar data vacio
            * def auth = call read('classpath:Bookings/authentication/auth.feature@HappyPath')
            * def token = auth.token
            * header Content-Type = 'application/json'
            * header accept = 'application/json'
            * header cookie = 'token=' + token
            * def createBooking = call read('classpath:Bookings/createBookings/createBooking.feature@happyPath')
            * def bookingid = createBooking.response.bookingid
            Given path 'booking/' + bookingid
            * def bodyrequest = read('classpath:Bookings/updateBookings/RequestBodyModifyBookingEmpty.json')
            And request bodyrequest
            When method PUT
            Then status 400




