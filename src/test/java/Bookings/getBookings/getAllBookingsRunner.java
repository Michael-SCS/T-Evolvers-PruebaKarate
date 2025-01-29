package Bookings.getBookings;

import com.intuit.karate.junit5.Karate;

public class getAllBookingsRunner {
    @Karate.Test
    Karate testGetAllBookings() {
        return Karate.run("classpath:Bookings/getBookings/getAllBookings.feature");

    }
}

