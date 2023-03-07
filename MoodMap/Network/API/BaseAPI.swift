//
//  BaseAPI.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 13.11.2022.
//

import Foundation
import Moya

enum BaseAPI {
    case mainScreen(MainScreenEndpoint)
    case auth(AuthEnpPoint)
    case userState(UserStateEndPoint)
}

extension BaseAPI: TargetType {
    
    var baseURL: URL {
        switch self {
        case let .mainScreen(mainScreenAPI): return mainScreenAPI.baseURL
        case let .auth(authAPI): return authAPI.baseURL
        case let .userState(userStateAPI): return userStateAPI.baseURL
        }
    }
    
    var path: String {
        switch self {
        case let .mainScreen(mainScreenAPI): return mainScreenAPI.path
        case let .auth(authAPI): return authAPI.path
        case let .userState(userStateAPI): return userStateAPI.path
        }
    }
    
    var method: Moya.Method {
        switch self {
        case let .mainScreen(mainScreenAPI): return mainScreenAPI.method
        case let .auth(authAPI): return authAPI.method
        case let .userState(userStateAPI): return userStateAPI.method
        }
    }
    
    var sampleData: Data {
        switch self {
        case let .mainScreen(mainScreenAPI): return mainScreenAPI.sampleData
        case let .auth(authAPI): return authAPI.sampleData
        case let .userState(userStateAPI): return userStateAPI.sampleData
        }
    }
    
    var task: Task {
        switch self {
        case let .mainScreen(mainScreenAPI): return mainScreenAPI.task
        case let .auth(authAPI): return authAPI.task
        case let .userState(userStateAPI): return userStateAPI.task
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case let .mainScreen(mainScreenAPI): return mainScreenAPI.headers
        case let .auth(authAPI): return authAPI.headers
        case let .userState(userStateAPI): return userStateAPI.headers
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case let .mainScreen(mainScreenAPI): return mainScreenAPI.authorizationType
        case let .auth(authAPI): return authAPI.authorizationType
        case let .userState(userStateAPI): return userStateAPI.authorizationType
        }
    }
}
