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
}

extension BaseAPI: TargetType {
    
    var baseURL: URL {
        switch self {
        case let .mainScreen(mainScreenAPI): return mainScreenAPI.baseURL
        case let .auth(authAPI): return authAPI.baseURL
        }
    }
    
    var path: String {
        switch self {
        case let .mainScreen(mainScreenAPI): return mainScreenAPI.path
        case let .auth(authAPI): return authAPI.path
        }
    }
    
    var method: Moya.Method {
        switch self {
        case let .mainScreen(mainScreenAPI): return mainScreenAPI.method
        case let .auth(authAPI): return authAPI.method
        }
    }
    
    var sampleData: Data {
        switch self {
        case let .mainScreen(mainScreenAPI): return mainScreenAPI.sampleData
        case let .auth(authAPI): return authAPI.sampleData
        }
    }
    
    var task: Task {
        switch self {
        case let .mainScreen(mainScreenAPI): return mainScreenAPI.task
        case let .auth(authAPI): return authAPI.task
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case let .mainScreen(mainScreenAPI): return mainScreenAPI.headers
        case let .auth(authAPI): return authAPI.headers
        }
    }
    
    // MARK: AccessTokenAuthorizable
    var authorizationType: AuthorizationType? {
        switch self {
        case let .mainScreen(mainScreenAPI): return mainScreenAPI.authorizationType
        case let .auth(authAPI): return authAPI.authorizationType
        }
    }
}
