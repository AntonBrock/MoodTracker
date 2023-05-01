//
//  ReportService.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 15.03.2023.
//

import Foundation

protocol ReportServiceProtocol {
    func fetchReport(from: String, to: String, type: ReportEndPoint.TypeOfReport, completion: @escaping(Result<ReportModel?, Error>) -> Void)
    func fetchCurrentDate(date: Date, complection: @escaping(Result<[ReportCurrentDateModel], Error>) -> Void)
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
    
    func fetchReport(
        from: String,
        to: String,
        type: ReportEndPoint.TypeOfReport,
        completion: @escaping(Result<ReportModel?, Error>) -> Void
    ) {
        let target = BaseAPI.report(.getReport(from: from, to: to, type: type))

        let networkService = ServiceProvider().networkService
        networkService?.request(.target(target), completion: { response in
            switch response {
            case let .success(result):
                guard let model = try? decoder.decode(ReportModel.self, from: result.data) else {
                    completion(.success(nil))
                    return
                }
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
    
    func fetchCurrentDate(
        date: Date,
        complection: @escaping(Result<[ReportCurrentDateModel], Error>) -> Void
    ) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        let target = BaseAPI.report(.currentReportDay(day: dateString))

        let networkService = ServiceProvider().networkService
        networkService?.request(.target(target), completion: { response in
            switch response {
            case let .success(result):
                guard let model = try? decoder.decode([ReportCurrentDateModel].self, from: result.data) else {
                    return
                }
                complection(.success(model))
            case let .failure(error):
                complection(.failure(error))
            }
        })
    }
}
