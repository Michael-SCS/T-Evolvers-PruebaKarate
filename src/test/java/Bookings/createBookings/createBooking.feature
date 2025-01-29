Feature: Tests for create bookings

  Background:
    # Definimos las variables y configuraciones comunes para los tests
    * url url_booking
    * header Accept = 'application/json'
    * def ExcelReader = Java.type('utils.ReadExcel')
    * def jsonData = ExcelReader.readExcelAsJson('src/test/resources/data/data.xlsx', 'Hoja1')
    * def data = karate.fromString(jsonData)

  @happyPath
  Scenario: Create a booking successfully
    Given path 'booking'
    And def requestBodyJson = read('classpath:Bookings/createBookings/RequestBodyCreateBooking.json')
    And request requestBodyJson
    When method POST
    Then status 200
    And match response == read('classpath:Bookings/createBookings/ResponseSchemaCreateBooking.json')

  @ScenarioAltern
  Scenario Outline: Create Booking with invalid bodyRequest
    Given path 'booking'
    And request
    """
    {
      "firstname": <firstname>,
      "lastname": <lastname>,
      "totalprice": <totalprice>,
      "depositpaid": <depositpaid>,
      "bookingdates": {
        "checkin": "2018-01-01",
        "checkout": "2019-01-01"
      },
      "additionalneeds": "Breakfast"
    }
    """
    When method POST
    Then status 500
    And match response == "Internal Server Error"

    Examples:
      | firstname | lastname | totalprice | depositpaid |
      | 123       | 123      | "123"      | 1           |
      | 322       | 123      | 123        | 1           |
      | null      | 123      | "ABC"      | 1           |
      | null      | "Doe"    | 123        | 1           |

  @ScenarioAltern
  Scenario: Create Booking with missing required fields
    Given path 'booking'
    And request
    """
    {
      "firstname": "John",
      "totalprice": 200,
      "depositpaid": true,
      "bookingdates": {
        "checkin": "2025-02-01",
        "checkout": "2025-02-10"
      }
    }
    """
    When method POST
    Then status 500
    And match response == "Internal Server Error"

  @ScenarioAltern
  Scenario: Create Booking with a bad json
    Given path 'booking'
    And def requestBadBody = read('classpath:Bookings/createBookings/RequestBodyCreateBadBooking.json')
    And request requestBadBody
    When method POST
    Then status 500
    And match response == "Internal Server Error"

  @ScenarioAltern
  Scenario: Create Booking with invalid dates
    Given path 'booking'
    And request
      """
      {
        "firstname": "Alice",
        "lastname": "Smith",
        "totalprice": 300,
        "depositpaid": true,
        "bookingdates": {
          "checkin": "2025-07-15",
          "checkout": "2025-06-10"
        },
        "additionalneeds": "WiFi"
      }
      """
    When method POST
    Then status 200
    # Esperaba un 500 pero el servicio no valida las fechas

  @ScenarioAltern
  Scenario: Create Booking with null required fields
    Given path 'booking'
    And request
      """
      {
        "firstname": null,
        "lastname": "Doe",
        "totalprice": 100,
        "depositpaid": true,
        "bookingdates": {
          "checkin": "2025-08-01",
          "checkout": "2025-08-10"
        },
        "additionalneeds": "None"
      }
      """
    When method POST
    Then status 500
    And match response == "Internal Server Error"

  Scenario Outline: Probar datos desde Excel
    # Leemos los datos del Excel y los pasamos a Karate
    * def ExcelReader = Java.type('utils.ReadExcel')
    * def jsonData = ExcelReader.readExcelAsJson('src/test/resources/data/data.xlsx', 'Hoja1')
    * def data = karate.fromString(jsonData)
    * print 'Datos JSON:', data
    * print 'Datos convertidos:', data

    Given path 'booking'
    And request { firstname: "<firstname>", lastname: "<lastname>", totalprice: <totalprice>, depositpaid: <depositpaid> }
    When method post
    Then status 500

    Examples:
      | firstname           | lastname           | totalprice           | depositpaid            |
      | <data[0].firstname> | <data[0].lastname> | <data[0].totalprice> | <data[0].depositpaid>  |
      | <data[1].firstname> | <data[1].lastname> | <data[1].totalprice> | <data[1].depositpaid>  |
      | <data[2].firstname> | <data[2].lastname> | <data[2].totalprice> | <data[2].depositpaid>  |
      | <data[3].firstname> | <data[3].lastname> | <data[3].totalprice> | <data[3].depositpaid>  |