//
//  AuthEnpPoint.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 01.03.2023.
//

import Foundation
import Moya

enum AuthEnpPoint: TargetType {
    
    case singUp(GToken: String)
    case getUserInfo
    
    var baseURL: URL {
        switch self {
        case .singUp:
            return URL(string: "https://api.mapmood.com/auth")!
        case .getUserInfo:
            return URL(string: "https://api.mapmood.com/v1/users")!
        }
    }
    
    var path: String {
        switch self {
        case .singUp:
            return "/oauth/google"
        case .getUserInfo:
            return "/me"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .singUp:
            return .post
        case .getUserInfo:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .singUp(let GToken):
            return .requestParameters(
                parameters: ["id_token": GToken],
                encoding: JSONEncoding.default)
        case .getUserInfo:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .singUp: return nil
        case .getUserInfo: return ["Authorization": "Bearer \(AppState.shared.jwtToken ?? "")"]
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .singUp:
            return nil
        case .getUserInfo:
            return .bearer
        }
    }
    
    var dummyPlist: String? {
        return nil
    }
}
