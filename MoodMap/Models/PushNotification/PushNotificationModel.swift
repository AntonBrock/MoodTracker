//
//  PushNotificationModel.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 08.07.2023.
//

import Foundation

struct PushNotificationModel  {
    enum PushNotificationModelType: String  {
        case diaryNotes = "diary_notes_daily_notification"
        case threeDaysWithGoodMoodNotification = "3days_with_good_mood_notification"
        case threeDaysWithBadMoodNotification = "3days_with_bad_mood_notification"
        case threeDaysAbsenceNotification = "3day_absence_notification"
        case fiveDaysOfRegularActivityNotification = "5days_of_regular_activity_notification"
        case gratitudesDailyNotification = "gratitudes_daily_notification"
    }
    
    let type: PushNotificationModelType = .diaryNotes
}
