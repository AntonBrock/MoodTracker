//
//  LoginCoordinatorView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 15.01.2023.
//

import SwiftUI

struct LoginCoordinatorView: View {
    
    @ObservedObject var coordinator: LoginViewCoordinator
    
    var body: some View {
        LoginView(container: .live, coordinator: coordinator)
    }
}
