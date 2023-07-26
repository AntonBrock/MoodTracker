//
//  ReportEndPoint.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 15.03.2023.
//

import Foundation
import Moya

enum ReportEndPoint: TargetType {
    
    enum TypeOfReport: String {
        case mood = "mood"
        case stress = "stress"
    }
    
    case getReport(from: String, to: String, type: TypeOfReport)
    case currentReportDay(day: String)
    
    var baseURL: URL {
        switch self {
        case .getReport, .currentReportDay:
            return URL(string: "\(AppState.shared.baseURL)/v1")!
        }
    }
    
    var path: String {
        switch self {
        case .getReport: return "/reports"
        case .currentReportDay(let day):
            return "/reports/\(day)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getReport, .currentReportDay: return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getReport(let from, let to, let type):
            return .requestParameters(parameters: ["from": from,
                                                   "to": to,
                                                   "type": type.rawValue],
                                      encoding: URLEncoding.queryString)
        case .currentReportDay:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getReport, .currentReportDay:
            return ["Authorization": "Bearer \(AppState.shared.jwtToken ?? "")"]
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .getReport, .currentReportDay:
            return .bearer
        }
    }
    
    var dummyPlist: String? {
        return nil
    }
}
