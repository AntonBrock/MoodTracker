//
//  ReportService.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 15.03.2023.
//

import Foundation

protocol ReportServiceProtocol {
    func fetchReport()
}

struct ReportService: ReportServiceProtocol {
    
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
    
    func fetchReport() {
        let target = BaseAPI.report(.getReport)

        let networkService = ServiceProvider().networkService
        networkService?.request(.target(target), completion: { response in
            switch response {
            case let .success(result):
               print(result)
            case let .failure(error):
//                completion(.failure(error))
                print(error)
            }
        })
    }
}
