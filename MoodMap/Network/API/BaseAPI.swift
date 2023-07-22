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
    case journal(JournalEndPoint)
    case report(ReportEndPoint)
    case diary(DiaryEndPoint)
    case quotes(QuotesEndPoint)
}

extension BaseAPI: TargetType {
    
    var baseURL: URL {
        switch self {
        case let .mainScreen(mainScreenAPI): return mainScreenAPI.baseURL
        case let .auth(authAPI): return authAPI.baseURL
        case let .userState(userStateAPI): return userStateAPI.baseURL
        case let .journal(journalEndPoint): return journalEndPoint.baseURL
        case let .report(reportEndPoint): return reportEndPoint.baseURL
        case let .diary(diaryEndPoint): return diaryEndPoint.baseURL
        case let .quotes(quotesEndPoint): return quotesEndPoint.baseURL
        }
    }
    
    var path: String {
        switch self {
        case let .mainScreen(mainScreenAPI): return mainScreenAPI.path
        case let .auth(authAPI): return authAPI.path
        case let .userState(userStateAPI): return userStateAPI.path
        case let .journal(journalEndPoint): return journalEndPoint.path
        case let .report(reportEndPoint): return reportEndPoint.path
        case let .diary(diaryEndPoint): return diaryEndPoint.path
        case let .quotes(quotesEndPoint): return quotesEndPoint.path
        }
    }
    
    var method: Moya.Method {
        switch self {
        case let .mainScreen(mainScreenAPI): return mainScreenAPI.method
        case let .auth(authAPI): return authAPI.method
        case let .userState(userStateAPI): return userStateAPI.method
        case let .journal(journalEndPoint): return journalEndPoint.method
        case let .report(reportEndPoint): return reportEndPoint.method
        case let .diary(diaryEndPoint): return diaryEndPoint.method
        case let .quotes(quotesEndPoint): return quotesEndPoint.method
        }
    }
    
    var sampleData: Data {
        switch self {
        case let .mainScreen(mainScreenAPI): return mainScreenAPI.sampleData
        case let .auth(authAPI): return authAPI.sampleData
        case let .userState(userStateAPI): return userStateAPI.sampleData
        case let .journal(journalEndPoint): return journalEndPoint.sampleData
        case let .report(reportEndPoint): return reportEndPoint.sampleData
        case let .diary(diaryEndPoint): return diaryEndPoint.sampleData
        case let .quotes(quotesEndPoint): return quotesEndPoint.sampleData
        }
    }
    
    var task: Task {
        switch self {
        case let .mainScreen(mainScreenAPI): return mainScreenAPI.task
        case let .auth(authAPI): return authAPI.task
        case let .userState(userStateAPI): return userStateAPI.task
        case let .journal(journalEndPoint): return journalEndPoint.task
        case let .report(reportEndPoint): return reportEndPoint.task
        case let .diary(diaryEndPoint): return diaryEndPoint.task
        case let .quotes(quotesEndPoint): return quotesEndPoint.task
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case let .mainScreen(mainScreenAPI): return mainScreenAPI.headers
        case let .auth(authAPI): return authAPI.headers
        case let .userState(userStateAPI): return userStateAPI.headers
        case let .journal(journalEndPoint): return journalEndPoint.headers
        case let .report(reportEndPoint): return reportEndPoint.headers
        case let .diary(diaryEndPoint): return diaryEndPoint.headers
        case let .quotes(quotesEndPoint): return quotesEndPoint.headers
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case let .mainScreen(mainScreenAPI): return mainScreenAPI.authorizationType
        case let .auth(authAPI): return authAPI.authorizationType
        case let .userState(userStateAPI): return userStateAPI.authorizationType
        case let .journal(journalEndPoint): return journalEndPoint.authorizationType
        case let .report(reportEndPoint): return reportEndPoint.authorizationType
        case let .diary(diaryEndPoint): return diaryEndPoint.authorizationType
        case let .quotes(quotesEndPoint): return quotesEndPoint.authorizationType
        }
    }
}
