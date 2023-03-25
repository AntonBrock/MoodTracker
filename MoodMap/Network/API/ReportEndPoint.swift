//
//  ReportEndPoint.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 15.03.2023.
//

import Foundation
import Moya

enum ReportEndPoint: TargetType {
    
    case getReport(from: String, to: String)
    
    var baseURL: URL {
        switch self {
        case .getReport:
            return URL(string: "https://api.mapmood.com/v1")!
        }
    }
    
    var path: String {
        switch self {
        case .getReport: return "/reports"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getReport: return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getReport(let from, let to):
            return .requestParameters(parameters: ["from": from,
                                                   "to": to],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getReport: return ["Authorization": "Bearer \(AppState.shared.jwtToken ?? "")"]
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .getReport: return .bearer
        }
    }
    
    var dummyPlist: String? {
        return nil
    }
}
