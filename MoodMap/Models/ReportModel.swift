//
//  ReportModel.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 17.03.2023.
//

import Foundation

struct ReportModel: Decodable {
    
    let chartData: [ChartData]
    let emotionCountData: EmotionCountData
    let timeData: TimeData
    let goodActivitiesReportData: GoodActivitiesReportData
    let badActivitiesReportData: BadActivitiesReportData
    
    enum CodingKeys: String, CodingKey {
        case chartData = "for_main"
        case emotionCountData = "for_count"
        case timeData = "for_time_of_day"
        case goodActivitiesReportData = "for_good_activities_report"
        case badActivitiesReportData = "for_bad_activities_report"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        chartData = try container.decode([ChartData].self, forKey: .chartData)
        emotionCountData = try container.decode(EmotionCountData.self, forKey: .emotionCountData)
        timeData = try container.decode(TimeData.self, forKey: .timeData)
        goodActivitiesReportData = try container.decode(GoodActivitiesReportData.self, forKey: .goodActivitiesReportData)
        badActivitiesReportData = try container.decode(BadActivitiesReportData.self, forKey: .badActivitiesReportData)
    }
    
    // MARK: - ChartData
    struct ChartData: Decodable {
        let date: String
        let dayRate: Int
        let description: [ChartDataDescription]
        
        enum CodingKeys: String, CodingKey {
            case date
            case dayRate = "day_rate"
            case description
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            date = try container.decode(String.self, forKey: .date)
            dayRate = try container.decode(Int.self, forKey: .dayRate)
            description = try container.decode([ChartDataDescription].self, forKey: .description)
        }
        
        struct ChartDataDescription: Decodable {
            let stateText: String
            let rate: Int
            let count: Int
            
            enum CodingKeys: String, CodingKey {
                case stateText = "state_text"
                case rate
                case count
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                stateText = try container.decode(String.self, forKey: .stateText)
                rate = try container.decode(Int.self, forKey: .rate)
                count = try container.decode(Int.self, forKey: .count)
            }
        }
    }
    
    // MARK: - EmotionCountData
    struct EmotionCountData: Decodable {
        let total: Int
        let common: String
        let state: [EmotionCountDataState]
        
        struct EmotionCountDataState: Decodable {
            let text: String
            let count: Int
        }
    }
    
    // MARK: - TimeData
    struct TimeData: Decodable {
        let bestTime: String
        let worstTime: String
        let dayParts: String?
        
        enum CodingKeys: String, CodingKey {
            case bestTime = "best_time"
            case worstTime = "worst_time"
            case dayParts = "day_parts"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            bestTime = try container.decode(String.self, forKey: .bestTime)
            worstTime = try container.decode(String.self, forKey: .worstTime)
            dayParts = try? container.decode(String.self, forKey: .dayParts)
        }
    }
    
    // MARK: - GoodActivitiesReportData
    struct GoodActivitiesReportData: Decodable {
        let bestActivity: String
        let activities: [GoodActivitiesReportDataActivities]
        
        enum CodingKeys: String, CodingKey {
            case bestActivity = "best_activity"
            case activities
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            bestActivity = try container.decode(String.self, forKey: .bestActivity)
            activities = try container.decode( [GoodActivitiesReportDataActivities].self, forKey: .activities)
        }
        
        struct GoodActivitiesReportDataActivities: Decodable {
            let id: String
            let text: String
            let language: String
            let createdAt: Date
            let updatedAt: Date?
            let image: String
            let count: Int
            
            enum CodingKeys: String, CodingKey {
                case id
                case text
                case language
                case image
                case count
                case createdAt = "created_at"
                case updatedAt = "updated_at"
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                id = try container.decode(String.self, forKey: .id)
                text = try container.decode(String.self, forKey: .text)
                language = try container.decode(String.self, forKey: .language)
                image = try container.decode(String.self, forKey: .image)
                count = try container.decode(Int.self, forKey: .count)
                createdAt = try container.decode(Date.self, forKey: .createdAt)
                updatedAt = try? container.decode(Date.self, forKey: .updatedAt)
            }
        }
    }
    
    // MARK: - BadActivitiesReportData
    struct BadActivitiesReportData: Decodable {
        let worstActivity: String
        let activities: [BadActivitiesReportDataActivities]
        
        enum CodingKeys: String, CodingKey {
            case worstActivity = "worst_activity"
            case activities
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            worstActivity = try container.decode(String.self, forKey: .worstActivity)
            activities = try container.decode( [BadActivitiesReportDataActivities].self, forKey: .activities)
        }
        
        struct BadActivitiesReportDataActivities: Decodable {
            let id: String
            let text: String
            let language: String
            let createdAt: Date
            let updatedAt: Date?
            let image: String
            let count: Int
            
            enum CodingKeys: String, CodingKey {
                case id
                case text
                case language
                case image
                case count
                case createdAt = "created_at"
                case updatedAt = "updated_at"
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                id = try container.decode(String.self, forKey: .id)
                text = try container.decode(String.self, forKey: .text)
                language = try container.decode(String.self, forKey: .language)
                image = try container.decode(String.self, forKey: .image)
                count = try container.decode(Int.self, forKey: .count)
                createdAt = try container.decode(Date.self, forKey: .createdAt)
                updatedAt = try? container.decode(Date.self, forKey: .updatedAt)
            }
        }
    }
}

struct ReportCurrentDateModel: Decodable {
    
    let stateRate: Int
    let stressRate: Int
    let time: Date
    let activities: [ReportCurrentDateActivitiesModel]
    
    enum CodingKeys: String, CodingKey {
        case stateRate = "state_rate"
        case stressRate = "stress_id"
        case time
        case activities
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        stateRate = try container.decode(Int.self, forKey: .stateRate)
        stressRate = try container.decode(Int.self, forKey: .stressRate)
        time = try container.decode(Date.self, forKey: .time)
        activities = try container.decode([ReportCurrentDateActivitiesModel].self, forKey: .activities)
    }

    struct ReportCurrentDateActivitiesModel: Decodable {
        let id: String
        let text: String
        let language: String
        let createdAt: Date
        let updatedAt: Date?
        let image: String
        let count: Int?
        
        enum CodingKeys: String, CodingKey {
            case id
            case text
            case language
            case image
            case count
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(String.self, forKey: .id)
            text = try container.decode(String.self, forKey: .text)
            language = try container.decode(String.self, forKey: .language)
            image = try container.decode(String.self, forKey: .image)
            count = try? container.decode(Int.self, forKey: .count)
            createdAt = try container.decode(Date.self, forKey: .createdAt)
            updatedAt = try? container.decode(Date.self, forKey: .updatedAt)
        }
    }
}
