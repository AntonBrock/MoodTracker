//
//  UserStateEndPoint.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 07.03.2023.
//

import Foundation
import Moya

enum UserStateEndPoint: TargetType {
    
    case getEmotionsList
    case getActivitiesList
//    case getStressList
    
    var baseURL: URL {
        switch self {
        case .getEmotionsList:
            return URL(string: "https://api.mapmood.com/v1/emotions")!
        case .getActivitiesList:
            return URL(string: "https://api.mapmood.com/v1/activities")!
        }
    }
    
    var path: String {
        switch self {
        case .getEmotionsList,
             .getActivitiesList: return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getEmotionsList, .getActivitiesList:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getEmotionsList,
             .getActivitiesList:
            return .requestParameters(parameters: ["language": "ru"], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getEmotionsList,
             .getActivitiesList: return ["Authorization": "Bearer \(AppState.shared.jwtToken ?? "")"]
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .getEmotionsList,
             .getActivitiesList:
            return .bearer
        }
    }
    
    var dummyPlist: String? {
        return nil
    }
}
