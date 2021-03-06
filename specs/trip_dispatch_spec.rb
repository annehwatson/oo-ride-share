require_relative 'spec_helper'

describe "TripDispatcher class" do
  describe "Initializer" do
    it "is an instance of TripDispatcher" do
      dispatcher = RideShare::TripDispatcher.new
      dispatcher.must_be_kind_of RideShare::TripDispatcher
    end

    it "establishes the base data structures when instantiated" do
      dispatcher = RideShare::TripDispatcher.new
      [:trips, :passengers, :drivers].each do |prop|
        dispatcher.must_respond_to prop
      end

      dispatcher.trips.must_be_kind_of Array
      dispatcher.passengers.must_be_kind_of Array
      dispatcher.drivers.must_be_kind_of Array
    end
  end

  describe "find_driver method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
    end

    it "throws an argument error for a bad ID" do
      proc{ @dispatcher.find_driver(0) }.must_raise ArgumentError
    end

    it "finds a driver instance" do
      driver = @dispatcher.find_driver(2)
      driver.must_be_kind_of RideShare::Driver
    end
  end

  describe "find_passenger method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
    end

    it "throws an argument error for a bad ID" do
      proc{ @dispatcher.find_passenger(0) }.must_raise ArgumentError
    end

    it "finds a passenger instance" do
      passenger = @dispatcher.find_passenger(2)
      passenger.must_be_kind_of RideShare::Passenger
    end
  end

  describe "loader methods" do
    it "accurately loads driver information into drivers array" do
      dispatcher = RideShare::TripDispatcher.new

      first_driver = dispatcher.drivers.first
      last_driver = dispatcher.drivers.last

      first_driver.name.must_equal "Bernardo Prosacco"
      first_driver.id.must_equal 1
      first_driver.status.must_equal :UNAVAILABLE
      last_driver.name.must_equal "Minnie Dach"
      last_driver.id.must_equal 100
      last_driver.status.must_equal :AVAILABLE
    end

    it "accurately loads passenger information into passengers array" do
      dispatcher = RideShare::TripDispatcher.new

      first_passenger = dispatcher.passengers.first
      last_passenger = dispatcher.passengers.last

      first_passenger.name.must_equal "Nina Hintz Sr."
      first_passenger.id.must_equal 1
      last_passenger.name.must_equal "Miss Isom Gleason"
      last_passenger.id.must_equal 300
    end

    it "accurately loads trip info and associates trips with drivers and passengers" do
      dispatcher = RideShare::TripDispatcher.new

      trip = dispatcher.trips.first
      driver = trip.driver
      passenger = trip.passenger

      driver.must_be_instance_of RideShare::Driver
      driver.trips.must_include trip
      passenger.must_be_instance_of RideShare::Passenger
      passenger.trips.must_include trip
    end
  end

  describe "find_available_driver" do
    it "returns the first available driver from @drivers" do
      @dispatcher = RideShare::TripDispatcher.new
      driver = @dispatcher.find_available_driver
      driver.must_be_instance_of(RideShare::Driver)
      driver.status.must_equal(:AVAILABLE)
      driver.name.must_equal("Antwan Prosacco")
    end

    it "raises an error when there are no available drivers" do
      @dispatcher = RideShare::TripDispatcher.new
      @dispatcher.drivers.clear
      proc {
        @dispatcher.find_available_driver
      }.must_raise ArgumentError
    end
  end

  describe "request_trip" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
    end

    it "creates a new instance of Trip" do
      result = @dispatcher.request_trip(1)
      result.must_be_instance_of(RideShare::Trip)
    end

    it "creates an id for trip (trip.id) accurately" do
      existing_number_of_trips = @dispatcher.trips.length
      new_trip = @dispatcher.request_trip(55)
      new_trip.id.must_equal(existing_number_of_trips + 1)
    end

    it "increments the driver's trips by 1" do
      driver = @dispatcher.find_available_driver
      starting_driver_trip_count = driver.trips.length
      new_request = @dispatcher.request_trip(1)
      ending_driver_trip_count = driver.trips.length
      ending_driver_trip_count.must_equal(starting_driver_trip_count + 1)
    end

    it "increments the passenger's trips by 1" do
      passenger_id = 298
      passenger = @dispatcher.find_passenger(passenger_id)
      starting_ride_count = passenger.trips.length

      new_request = @dispatcher.request_trip(passenger_id)
      ending_ride_count = new_request.passenger.trips.length
      ending_ride_count.must_equal(starting_ride_count + 1)
    end

    it "accurately assigns trips to the available drivers who have not driven in the longest time" do
      requested_trip_1 = @dispatcher.request_trip(1)
      requested_trip_1.driver.name.must_equal("Antwan Prosacco")

      requested_trip_2 = @dispatcher.request_trip(99)
      requested_trip_2.driver.name.must_equal("Nicholas Larkin")

      requested_trip_3 = @dispatcher.request_trip(23)
      requested_trip_3.driver.name.must_equal("Mr. Hyman Wolf")

      requested_trip_4 = @dispatcher.request_trip(45)
      requested_trip_4.driver.name.must_equal("Jannie Lubowitz")

      requested_trip_5 = @dispatcher.request_trip(64)
      requested_trip_5.driver.name.must_equal("Mohammed Barrows")
    end
  end

end
