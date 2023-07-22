//
//  QuotesEndPoint.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 22.07.2023.
//

import Foundation
import Moya

enum QuotesEndPoint {
    
    case getQuote(language: String)
    
    var baseURL: URL {
        switch self {
        case .getQuote:
            return URL(string: "https://api.mapmood.com/v1")!
        }
    }
    
    var path: String {
        switch self {
        case .getQuote: return "/quotes/random"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getQuote: return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getQuote(let language):
            return .requestParameters(parameters: ["language": language], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getQuote: return nil
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .getQuote: return .bearer
        }
    }
    
    var dummyPlist: String? {
        return nil
    }
}
