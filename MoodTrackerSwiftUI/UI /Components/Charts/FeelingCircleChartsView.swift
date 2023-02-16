//
//  FeelingCircleChartsView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 14.10.2022.
//

import SwiftUI
import WrappingStack

struct FeelingCircleChartsView: View {
    
    @State var completed: Int
    @State var color: Color = .green

    var elements = [ CircularBarProgressView(completed: 4, color: .green),
                     CircularBarProgressView(completed: 4, color: .green),
                     CircularBarProgressView(completed: 4, color: .green),
                     CircularBarProgressView(completed: 7, color: .red)]
    
    #warning("TODO: Не хватает выравнивания по центру, когда элемент один в колонке")
    let columns = [
        GridItem(.flexible(minimum: 120, maximum: 120)),
        GridItem(.flexible(minimum: 120, maximum: 120)),
        GridItem(.flexible(minimum: 120, maximum: 120))
   ]
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Feeling")
                .font(.system(size: 32))
                .fontWeight(.medium)
                .foregroundColor(Colors.TextColors.cello900)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 24, leading: 20, bottom: 0, trailing: 0))
            
            LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                ForEach(0..<elements.count, id: \.self) { item in
                    CircularBarProgressView(completed: elements[item].completed, color: elements[item].color)
                }
            }
            .frame(alignment: .center)
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 25, trailing: 0))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .fixedSize(horizontal: true, vertical: true)
        .background(Color.white)
        .compositingGroup()
        .cornerRadius(15)
        .padding(.horizontal, 16)
        .shadow(color: Colors.TextColors.mystic400, radius: 10, x: 0, y: 0)
    }
}

// MARK: - CircularBarProgressView
struct CircularBarProgressView: View {
    
    let total: Int = 10
    @State var completed: Int
    
    @State var lineWidth: CGFloat = 10
    @State var color: Color
    
    var shortDashSize: CGFloat { 1 }
    func longDashSize(circleWidth: CGFloat) -> CGFloat {
        .pi * circleWidth / CGFloat(total) - shortDashSize
    }
    
    var body: some View {
        
        VStack {
            ZStack {
                GeometryReader { geometry in
                    Circle()
                        .stroke(color.opacity(0.1),
                                style: StrokeStyle(
                                    lineWidth: lineWidth,
                                    lineCap: .butt,
                                    lineJoin: .miter,
                                    miterLimit: 0,
                                    dash: [
                                        longDashSize(circleWidth: geometry.size.width),
                                        shortDashSize
                                    ],
                                    dashPhase: 0))
                        .rotationEffect(.degrees(-90))
                }
                .padding(lineWidth / 2)

                RollingText(total: total, numberValue: $completed)

                CircularProgressBarProgressView(total: total, completed: completed, color: $color)
                
            }
            .frame(width: 120, height: 120, alignment: .center)
            
            Text("Happy")
                .font(.system(size: 16))
                .foregroundColor(Colors.TextColors.cello900)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - CircularProgressBarProgressView
struct CircularProgressBarProgressView: View {
    
    let total: Int
    var completed: Int
    
    @State var showRing: Bool = false
    
    @Binding var color: Color
    @State var lineWidth: CGFloat = 10
    
    var animation: Animation {
        Animation.linear
        .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        Circle()
            .trim(from: 0, to: showRing ? CGFloat(completed) / CGFloat(total) : 0)
            .stroke(color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    ))
            .rotationEffect(.degrees(-90))
            .padding(lineWidth/2)
        
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.interactiveSpring(response: 1, dampingFraction: 1, blendDuration: 1).delay(Double(1) * 0.1)) {
                        showRing = true
                    }
                }
            }
    }
}

// MARK: - RollingText
struct RollingText: View {
    
    var total: Int
    
    @Binding var numberValue: Int
    @State var animationRange: [Int] = []
    
    var body: some View {
        HStack(spacing: numberValue == 0 ? 0 : -16) {
            ForEach(0..<animationRange.count, id: \.self) { index in
                Text("88") // "\((completed * 100) / total)% ")
                    .font(.system(size: 20))
                    .foregroundColor(Colors.TextColors.cello900)
                    .fontWeight(.bold)
                    .opacity(0)
                    .multilineTextAlignment(.trailing)
                    .overlay {
                        GeometryReader { proxy in
                            let size = proxy.size
                            
                            VStack(spacing: 0) {
                                ForEach(0...10, id: \.self) { number in
                                    Text("\(number * 10)") //
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                        .foregroundColor(Colors.TextColors.cello900)
                                        .frame(width: size.width, height: size.height, alignment: .trailing)
                                }
                            }
                            .offset(y: -CGFloat(animationRange[index]) * size.height)
                        }
                        .clipped()
                    }
            }
           
            Text("%")
                .font(.system(size: 20))
                .foregroundColor(Colors.TextColors.cello900)
                .fontWeight(.bold)
                .padding(.leading, numberValue == 0 ? 0 : 18)
        }
        .onAppear {
            animationRange = Array(repeating: 0, count: "\(numberValue)".count)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
                updateText()
            }
        }
        .onChange(of: numberValue) { newValue in
            let extra = "\(numberValue)".count - animationRange.count
            if extra > 0 {
                for _ in 0..<extra {
                    withAnimation(.easeIn(duration: 0.1)) { animationRange.append(0)}
                }
            } else {
                for _ in 0..<(-extra) {
                    withAnimation(.easeIn(duration: 0.1)) { animationRange.removeLast()}
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                updateText()
            }
        }
    }
    
    func updateText() {
        let stringValue = "\(numberValue)" // \((numberValue * 100) / total) %
    
        for (index, numberValue) in zip(0..<stringValue.count, stringValue) {
            var fraction = Double(index) * 0.15
            fraction = (fraction > 0.5 ? 0.5 : fraction)
            
            
            withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 1 + fraction, blendDuration: 1 + fraction)) {
                animationRange[index] = (String(numberValue) as NSString).integerValue
            }
        }
    }
}
