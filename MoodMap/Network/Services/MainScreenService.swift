//
//  MainScreenService.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 13.11.2022.
//

import Foundation

protocol MainScreenServiceProtocol {}

struct MainScreenService: MainScreenServiceProtocol {
    
    private var decoder: JSONDecoder = {
        let decoder = JSONDecoder()

        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"

            if let date = formatter.date(from: dateStr) {
                return date
            }

            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"

            if let date = formatter.date(from: dateStr) {
                return date
            }

            throw Error.self as! Error
        })

        return decoder
    }()
}

struct StubMainScreen: MainScreenServiceProtocol {
    func getUserInfo(completion: @escaping(Result<UserInfoModel, Error>) -> Void) { }
}
