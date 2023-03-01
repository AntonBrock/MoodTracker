//
//  Services.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 23.10.2022.
//

struct Services {
    
    let mainScreenService: MainScreenService
    
    init(
        mainScreenService: MainScreenService
    ) {
        self.mainScreenService = mainScreenService
    }
    
    static var stub: Self {
        .init(
            mainScreenService: MainScreenService()
        )
    }
}
