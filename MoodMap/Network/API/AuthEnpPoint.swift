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
    case singUpWithAppleId(AppleID: String)
    case logout
    case deleteAccount
    case setLanguage
    case updateTimezone
    
    case getUserInfo
    case refreshToken
    
    var baseURL: URL {
        switch self {
        case .singUp, .refreshToken, .singUpWithAppleId, .logout:
            return URL(string: "https://api.mapmood.com/auth")!
        case .getUserInfo, .deleteAccount, .setLanguage, .updateTimezone:
            return URL(string: "https://api.mapmood.com/v1/users")!
        }
    }
    
    var path: String {
        switch self {
        case .logout: return "/token/revoke"
        case .refreshToken: return "/token/refresh"
        case .singUp: return "/oauth/google"
        case .singUpWithAppleId: return "/oauth/apple"
        case .getUserInfo, .deleteAccount: return "/me"
        case .updateTimezone: return "me/settings/timezone"
        case .setLanguage: return "/me/settings"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .singUp, .singUpWithAppleId, .logout, .setLanguage, .refreshToken: return .post
        case .getUserInfo: return .get
        case .deleteAccount: return .delete
        case .updateTimezone: return .put
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .setLanguage:
            return .requestParameters(parameters: [
                "timezone": AppState.shared.timezone ?? "",
                "notifications": false,
                "language": "ru"], encoding: JSONEncoding.default)
        case .logout:
            return .requestParameters(parameters: ["access_token": AppState.shared.jwtToken ?? "",
                                                   "refresh_token": AppState.shared.refreshToken ?? ""],
                                      encoding: JSONEncoding.default)
        case .singUp(let GToken):
            return .requestParameters(
                parameters: ["id_token": GToken],
                encoding: JSONEncoding.default)
        case .singUpWithAppleId(let AppleIDToken):
            return .requestParameters(
                parameters: ["id_token": AppleIDToken],
                encoding: JSONEncoding.default)
        case .getUserInfo, .deleteAccount: return .requestPlain
        case .updateTimezone: return .requestParameters(parameters: ["timezone": AppState.shared.timezone ?? ""],
                                                         encoding: JSONEncoding.default)
        case .refreshToken:
            return .requestParameters(parameters: ["refresh_token": AppState.shared.refreshToken ?? ""],
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .singUp, .singUpWithAppleId, .refreshToken: return nil
        case .getUserInfo, .logout, .deleteAccount, .setLanguage, .updateTimezone: return ["Authorization": "Bearer \(AppState.shared.jwtToken ?? "")"]
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .singUp, .singUpWithAppleId, .refreshToken:
            return nil
        case .getUserInfo, .logout, .deleteAccount, .setLanguage, .updateTimezone:
            return .bearer
        }
    }
    
    var dummyPlist: String? {
        return nil
    }
}
