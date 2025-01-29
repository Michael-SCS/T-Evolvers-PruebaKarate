package Bookings.createBookings;

import com.intuit.karate.junit5.Karate;

public class CreateBookingRunner {
    @Karate.Test
    Karate testGetAllBookings() {
        return Karate.run("classpath:Bookings/createBookings/createBooking.feature");

    }
}