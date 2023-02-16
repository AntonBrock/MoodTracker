//
//  MainScreenEndpoint.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 13.11.2022.
//

import Foundation
import Moya

//let token: String = """
//                    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaXJzdF9uYW1lIjoi0JDQvdGC0L7QvSIsImxhc3RfbmFtZSI6ItCU0L7QsdGA0YvQvdC40L0iLCJleHAiOjE2OTkwOTgzNDUsImlhdCI6MTY2NzU2MjM0NSwiaXNzIjoibWFrZUJ1cmVhdSJ9.PXH_brjqUJ1JJgxoEx7K9SvqZJyqzDaoBF1YSrTtPjw
//                    """

enum MainScreenEndpoint: TargetType {
    
    case getUserInfo
    
    var baseURL: URL {
        switch self {
        case .getUserInfo:
            return URL(string: "https://crcal-dev.sovcombank.ru/app/bureau/api/v1")!
        }
    }
    
    var path: String {
        switch self {
        case .getUserInfo:
            return "user/info"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserInfo:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getUserInfo:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getUserInfo:
            return [
                "Accept": "application/json",
//                "Authorization": "Bearer \(token)"
            ]
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .getUserInfo:
            return nil
        }
    }
    
    var dummyPlist: String? {
        return nil
    }
}
