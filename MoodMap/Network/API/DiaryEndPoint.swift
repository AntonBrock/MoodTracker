//
//  DiaryEndPoint.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 02.04.2023.
//

import Foundation

import Foundation
import Moya

enum DiaryEndPoint: TargetType {
    
    case getDiary
    case setNewPage(page: String)

    var baseURL: URL {
        switch self {
        case .getDiary, .setNewPage:
            return URL(string: "\(AppState.shared.baseURL)/v1")!
        }
    }
    
    var path: String {
        switch self {
        case .getDiary, .setNewPage: return "/gratitudes"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getDiary: return .get
        case .setNewPage: return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getDiary: return .requestPlain
        case .setNewPage(let page):
            return .requestParameters(parameters: ["text": page], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getDiary, .setNewPage: return ["Authorization": "Bearer \(AppState.shared.jwtToken ?? "")"]
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .getDiary, .setNewPage: return .bearer
        }
    }
    
    var dummyPlist: String? {
        return nil
    }
}
