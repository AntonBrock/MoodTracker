//
//  ReportEndPoint.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 15.03.2023.
//

import Foundation
import Moya

enum ReportEndPoint: TargetType {
    
    case getReport
    
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
        case .getReport: return .requestPlain
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
