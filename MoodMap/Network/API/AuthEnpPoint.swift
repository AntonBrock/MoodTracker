//
//  AuthEnpPoint.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 01.03.2023.
//

import Foundation
import Moya

enum AuthEnpPoint: TargetType {
    
    case singUp(with: UserInfoModel)
    
    var baseURL: URL {
        switch self {
        case .singUp:
            return URL(string: "https://api.mapmood.com/auth")!
        }
    }
    
    var path: String {
        switch self {
        case .singUp:
            return "/sing_up"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .singUp:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .singUp(let model):
            return .requestParameters(
                parameters: ["name": model.name,
                             "email": model.email,
                             "notifications": model.isNotificationEnable,
                             "local": model.locale],
                encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .singUp: return nil
//            return [
////                "Accept": "application/json",
////                "Authorization": "Bearer \(token)"
//            ]
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .singUp:
            return nil
        }
    }
    
    var dummyPlist: String? {
        return nil
    }
}
