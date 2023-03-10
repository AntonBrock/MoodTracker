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
    case sendUserNote(activities: [String], emotionId: String, stateId: String, stressRate: Int, text: String)
    
    var baseURL: URL {
        switch self {
        case .getStateList, .getEmotionsList, .getActivitiesList, .sendUserNote:
            return URL(string: "https://api.mapmood.com/v1")!
        }
    }
    
    var path: String {
        switch self {
        case .getStateList: return "/states"
        case .getEmotionsList: return "/emotions"
        case .getActivitiesList: return "/activities"
        case .sendUserNote: return "/diary/notes"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getStateList,
             .getEmotionsList,
             .getActivitiesList:
            return .get
        case .sendUserNote:
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
             .getActivitiesList:
            return .requestParameters(parameters: ["language": "ru"], encoding: URLEncoding.queryString)
        case .sendUserNote(let activities,
                           let emotionId,
                           let stateId,
                           let stressRate,
                           let text):
            return .requestParameters(
                parameters: [
                    "activities": activities,
                    "day_rate": 0,
                    "emotion_id": emotionId,
                    "state_id": stateId,
                    "stress_rate": stressRate,
                    "text": text
                ],
                encoding: JSONEncoding.default
            )
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getStateList,
             .getEmotionsList,
             .getActivitiesList,
             .sendUserNote(_, _, _, _, _)
            : return ["Authorization": "Bearer \(AppState.shared.jwtToken ?? "")"]
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .getStateList,
             .getEmotionsList,
             .getActivitiesList,
             .sendUserNote(_, _, _, _, _)
             :return .bearer
        }
    }
    
    var dummyPlist: String? {
        return nil
    }
}
