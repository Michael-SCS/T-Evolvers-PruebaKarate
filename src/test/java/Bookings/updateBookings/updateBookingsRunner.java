package Bookings.updateBookings;

import com.intuit.karate.junit5.Karate;

public class updateBookingsRunner {
    @Karate.Test
    Karate testUpdateBookings() {
        return Karate.run("classpath:Bookings/updateBookings/modifyBooking.feature");
    }
}
