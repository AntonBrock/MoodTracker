//
//  CutomAlertView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 19.10.2022.
//

import SwiftUI

struct CutomAlertView: View {
    
    @State var customAlert = false
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                Button(action: {
                    
                    withAnimation {
                        customAlert.toggle()
                    }
                    
                }) {
                    Text("Custom AlertView")
                }
                
            }
            
            if customAlert {
                CustomAlertView(show: $customAlert)
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)).combined(with: .opacity))
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(customAlert ? Color.black.opacity(0.6) : .white)
    }
    
}

// MARK: - BlurView
struct BlurView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

// MARK: - CustomAlertView
struct CustomAlertView: View {
    
    @Binding var show: Bool
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
            VStack(spacing: 25) {
                
                Image("second")
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
                    .padding(.top, 20)
                
                VStack(spacing: 5) {
                    Text("You're on a good way!")
                        .font(.title)
                        .foregroundColor(Colors.TextColors.cello900)
                        .font(.system(size: 20, weight: .bold))
                    
                    Text("Youre day is amazing")
                        .font(.title)
                        .foregroundColor(Colors.TextColors.cello900)
                        .font(.system(size: 20, weight: .bold))
                }
                
                Text("Keep tracking your mood to know how to improve your life quality")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Colors.TextColors.slateGray700)
                    .font(.system(size: 16, weight: .medium))
                
                Button(action: {
                    withAnimation {
                        show.toggle()
                    }
                }) {
                    Text("Done")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 100)
                        .background(Colors.Secondary.shamrock600Green)
                        .clipShape(Capsule())
                }
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .frame(width: UIScreen.main.bounds.width - 32)
            .padding(.vertical, 25)
            .background(.white)
            .cornerRadius(25)
            
            Button(action: {
                withAnimation {
                    show.toggle()
                }
            })  {
                
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Colors.TextColors.cello900)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
