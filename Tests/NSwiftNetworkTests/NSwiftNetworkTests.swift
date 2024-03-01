import XCTest
import Combine
import Foundation
@testable import NSwiftNetwork

class NetworkManagerTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchDataFromNetwork() async {
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=43.7&longitude=18.1667&hourly=temperature_2m&daily=snowfall_sum&timezone=Europe%2FBerlin&forecast_days=3")!
        let expectation = expectation(description: "Data fetched from network")
        let request = URLRequest(url: url)
        let publisher: AnyPublisher<Welcome, NSNetworkError> = await NSwiftNetwork().fetchData(with: request)
        
        publisher
            .sink(receiveCompletion: { completion in
                print("hello")
            }, receiveValue: { data in
                expectation.fulfill()
            })
            .store(in: &cancellables)
        await fulfillment(of: [expectation])
    }
    
}

extension NetworkManagerTests {
    
    // MARK: - Welcome
    struct Welcome: Codable {
        let latitude, longitude, generationtimeMS: Double
        let utcOffsetSeconds: Int
        let timezone, timezoneAbbreviation: String
        let elevation: Int
        let hourlyUnits: HourlyUnits
        let hourly: Hourly
        let dailyUnits: DailyUnits
        let daily: Daily

        enum CodingKeys: String, CodingKey {
            case latitude, longitude
            case generationtimeMS = "generationtime_ms"
            case utcOffsetSeconds = "utc_offset_seconds"
            case timezone
            case timezoneAbbreviation = "timezone_abbreviation"
            case elevation
            case hourlyUnits = "hourly_units"
            case hourly
            case dailyUnits = "daily_units"
            case daily
        }
    }

    // MARK: - Daily
    struct Daily: Codable {
        let time: [String]
        let snowfallSum: [Double]

        enum CodingKeys: String, CodingKey {
            case time
            case snowfallSum = "snowfall_sum"
        }
    }

    // MARK: - DailyUnits
    struct DailyUnits: Codable {
        let time, snowfallSum: String

        enum CodingKeys: String, CodingKey {
            case time
            case snowfallSum = "snowfall_sum"
        }
    }

    // MARK: - Hourly
    struct Hourly: Codable {
        let time: [String]
        let temperature2M: [Double]

        enum CodingKeys: String, CodingKey {
            case time
            case temperature2M = "temperature_2m"
        }
    }

    // MARK: - HourlyUnits
    struct HourlyUnits: Codable {
        let time, temperature2M: String

        enum CodingKeys: String, CodingKey {
            case time
            case temperature2M = "temperature_2m"
        }
    }
    
}
