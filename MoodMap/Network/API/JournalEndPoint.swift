//
//  JournalEndPoint.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 11.03.2023.
//

import Foundation
import Moya

enum JournalEndPoint: TargetType {
    
    case sendUserNote(createdAt: String, activities: [String], emotionId: String, stateId: String, stressRate: String, text: String?, isMoodWeenEvent: Bool?)
    case getUserNotes(from: String?, to: String?)

    var baseURL: URL {
        switch self {
        case .sendUserNote, .getUserNotes:
            return URL(string: "\(AppState.shared.baseURL)/v1")!
        }
    }
    
    var path: String {
        switch self {
        case .sendUserNote, .getUserNotes: return "/diary/notes"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sendUserNote:
            return .post
        case .getUserNotes:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getUserNotes(let from, let to):
            if let from = from,
                let to = to,
               !from.isEmpty && !to.isEmpty {
                return .requestParameters(parameters:
                                          [
                                            "from": from,
                                            "to": to
                                          ],
                                          encoding: URLEncoding.queryString)
            } else {
                return .requestPlain
            }
        case .sendUserNote(let createdAt,
                           let activities,
                           let emotionId,
                           let stateId,
                           let stressRate,
                           let text,
                           let isMoodWeenEvent):
            return .requestParameters(
                parameters: [
                    "created_at": createdAt,
                    "activities": activities,
                    "day_rate": 0,
                    "emotion_id": emotionId,
                    "state_id": stateId,
                    "stress_id": stressRate,
                    "text": text ?? nil,
                    "is_moodween_event": isMoodWeenEvent ?? nil
                ],
                encoding: JSONEncoding.default
            )
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .sendUserNote(_, _, _, _, _, _, _), .getUserNotes
            : return ["Authorization": "Bearer \(AppState.shared.jwtToken ?? "")"]
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .sendUserNote(_, _, _, _, _, _, _), .getUserNotes
             :return .bearer
        }
    }
    
    var dummyPlist: String? {
        return nil
    }
}
