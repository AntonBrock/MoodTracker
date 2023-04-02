//
//  Services.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 23.10.2022.
//

struct Services {
    
    static let mainScreenService: MainScreenService = MainScreenService()
    static var authService: AuthService = AuthService()
    static var userStateService: UserStateService = UserStateService()
    static var journalService: JournalService = JournalService()
    static var reportService: ReportService = ReportService()
    static var diaryService: DiaryService = DiaryService()
}
