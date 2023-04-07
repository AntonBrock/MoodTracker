//
//  UserStateEndPoint.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 07.03.2023.
//

import Foundation
import Moya

enum UserStateEndPoint: TargetType {
    
    case getStateList
    case getEmotionsList
    case getActivitiesList
    case getStressList
    
    var baseURL: URL {
        switch self {
        case .getStateList, .getEmotionsList, .getActivitiesList, .getStressList:
            return URL(string: "https://api.mapmood.com/v1")!
        }
    }
    
    var path: String {
        switch self {
        case .getStateList: return "/states"
        case .getEmotionsList: return "/emotions"
        case .getActivitiesList: return "/activities"
        case .getStressList: return "/stress"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getStateList,
             .getEmotionsList,
             .getActivitiesList,
             .getStressList:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getStateList,
             .getEmotionsList,
             .getActivitiesList,
             .getStressList:
            return .requestParameters(parameters: ["language": "ru"], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getStateList,
             .getEmotionsList,
             .getActivitiesList,
             .getStressList
            : return ["Authorization": "Bearer \(AppState.shared.jwtToken ?? "")"]
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .getStateList,
             .getEmotionsList,
             .getActivitiesList,
             .getStressList
             :return .bearer
        }
    }
    
    var dummyPlist: String? {
        return nil
    }
}
