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
    case getMoodCheck
    case postMoodBreathCheck
    
    var baseURL: URL {
        switch self {
        case .getStateList, .getEmotionsList, .getActivitiesList, .getStressList, .getMoodCheck, .postMoodBreathCheck:
            return URL(string: "\(AppState.shared.baseURL)/v1")!
        }
    }
    
    var path: String {
        switch self {
        case .getStateList: return "/states"
        case .getEmotionsList: return "/emotions"
        case .getActivitiesList: return "/activities"
        case .getStressList: return "/stress"
        case .getMoodCheck: return "users/me/activities"
        case .postMoodBreathCheck: return "users/me/activities/breath"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getStateList,
             .getEmotionsList,
             .getActivitiesList,
             .getStressList, .getMoodCheck:
            return .get
        case .postMoodBreathCheck:
            return .post
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
             .getStressList, .getMoodCheck:
            return .requestParameters(parameters: ["language": "ru"], encoding: URLEncoding.queryString)
        case .postMoodBreathCheck: return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getStateList,
             .getEmotionsList,
             .getActivitiesList,
             .getStressList,
             .getMoodCheck,
             .postMoodBreathCheck: return ["Authorization": "Bearer \(AppState.shared.jwtToken ?? "")"]
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .getStateList,
             .getEmotionsList,
             .getActivitiesList,
             .getStressList,
             .postMoodBreathCheck,
             .getMoodCheck: return .bearer
        }
    }
    
    var dummyPlist: String? {
        return nil
    }
}
