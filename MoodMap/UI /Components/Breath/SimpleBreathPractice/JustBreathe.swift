//
//  JustBreathe.swift
//  Just Breath
//
//  ANIMATION AND MEANING: Guiding Users. In guided meditation, animations are normally used to guide users to complete tasks.
//

import SwiftUI

struct JustBreathe: View {
        
    var callDismissAction: (() -> Void)

    @State private var grow = false // Scale the middle from 0.5 to 1
    @State private var rotateFarRight = false
    @State private var rotateFarLeft = false
    @State private var rotateMiddleLeft = false
    @State private var rotateMiddleRight = false
    @State private var showShadow = false
    @State private var showRightStroke = false
    @State private var showLeftStroke = false
    @State private var changeColor = false
    
    @State private var breatheIn = true
    @State private var breatheOut = false
    
    @State private var isStarted: Bool = false
    
    var body: some View {
        ZStack {
            Image("bg-mb-defaultCover")
            .resizable()
            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                Rectangle()
                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .background(
                        LinearGradient(colors: [Color(hex: "BBBAFF"), Color(hex: "973FF4")], startPoint: .top, endPoint: .bottom)
                    )
                    .opacity(0.4)
            )
            
            VStack {
                VStack {
                    ZStack {
                        Text("Выдыхай..")
                            .opacity(breatheOut ? 0 : 1) // Opacity animation
                            .animation(.easeInOut(duration: 2).delay(2).repeatForever(autoreverses: true), value: breatheOut)
                            .foregroundColor(.white)
                            .font(.system(size: 26, weight: .bold))
                        
                        Text("Вдыхай..")
                            .opacity(breatheIn ? 0 : 1)
                            .scaleEffect(breatheIn ? 0 : 1, anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .animation(.easeInOut(duration: 2).delay(2).repeatForever(autoreverses: true), value: breatheIn)
                            .foregroundColor(.white)
                            .font(.system(size: 26, weight: .bold))
                    }
                    .padding(.top, 50)
                }
                .opacity(isStarted ? 1 : 0)
                .transition(.opacity)
                
                Spacer()
                
                ZStack {
                    Image("flower") // Middle
                        .scaleEffect(grow ? 1 : 0.5, anchor: .bottom)
                        .animation(.easeInOut(duration: 2).delay(2).repeatForever(autoreverses: true), value: grow)
                    
                    Image("flower")  // Middle left
                        .rotationEffect(.degrees( rotateMiddleLeft ? -25 : -5), anchor: .bottom)
                        .animation(.easeInOut(duration: 2).delay(2).repeatForever(autoreverses: true), value: rotateMiddleLeft)
//                        .onAppear {
//                            rotateMiddleLeft.toggle()
//                        }
                    
                    Image("flower")  // Middle right
                        .rotationEffect(.degrees( rotateMiddleRight ? 25 : 5), anchor: .bottom)
                        .animation(.easeInOut(duration: 2).delay(2).repeatForever(autoreverses: true), value: rotateMiddleRight)
                    
                    
                    Image("flower")  // Left
                        .rotationEffect(.degrees( rotateFarLeft ? -50 : -10), anchor: .bottom)
                        .animation(.easeInOut(duration: 2).delay(2).repeatForever(autoreverses: true), value: rotateFarLeft)
                    
                    Image("flower")  // Right
                        .rotationEffect(.degrees( rotateFarRight ? 50 : 10), anchor: .bottom)
                        .animation(.easeInOut(duration: 2).delay(2).repeatForever(autoreverses: true), value: rotateFarRight)
                    
                    Circle()  // Quarter dotted circle left
                        .trim(from: showLeftStroke ? 0 : 1/4, to: 1/4)
                        .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, dash: [1, 14]))
                        .frame(width: 215, height: 215, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                        .rotationEffect(.degrees(-180), anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .offset(x: 0, y: -25)
                        .animation(.easeInOut(duration: 2).delay(2).repeatForever(autoreverses: true), value: showLeftStroke)
                    
                    Circle()  // Quarter dotted circle right
                        .trim(from: 0, to: showRightStroke ? 1/4 : 0)
                        .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, dash: [1, 14]))
                        .frame(width: 215, height: 215, alignment: .center)
                        .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                        .rotationEffect(.degrees(-90), anchor: .center)
                        .offset(x: 0, y: -25)
                        .animation(.easeInOut(duration: 2).delay(2).repeatForever(autoreverses: true), value: showRightStroke)
                    
                }
                .shadow(radius: showShadow ? 20 : 0)
                .hueRotation(Angle(degrees: changeColor ? -235 : 45))
                .animation(.easeInOut(duration: 2).delay(2).repeatForever(autoreverses: true), value: changeColor)
                
                Spacer()
                
                Button(isStarted ? "Завершить" : "Начать") {
                    
                    if isStarted {
                      
                        withAnimation {
                            isStarted = false
                            breatheOut = false
                            breatheIn = true
                            
                            grow = false
                            rotateFarRight = false
                            rotateFarLeft = false
                            rotateMiddleLeft = false
                            rotateMiddleRight = false
                            showShadow = false
                            showRightStroke = false
                            showLeftStroke = false
                            changeColor = false
                        }
                        
                        callDismissAction()
                    } else {
                        withAnimation {
                            isStarted = true
                            
                            breatheOut.toggle()
                            breatheIn.toggle()
                            
                            grow.toggle()
                            rotateFarRight.toggle()
                            rotateFarLeft.toggle()
                            rotateMiddleLeft.toggle()
                            rotateMiddleRight.toggle()
                            showShadow.toggle()
                            showRightStroke.toggle()
                            showLeftStroke.toggle()
                            changeColor.toggle()
                        }
                    }
                }
                .frame(width: 240, height: 60)
                .background(Colors.Primary.lavender500Purple)
                .cornerRadius(20)
                
                Spacer()
                
            }
        }
    }
}
