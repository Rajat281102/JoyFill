//
//  SignatureView.swift
//  JoyFill
//
//  Created by Babblu Bhaiya on 10/02/24.
//

import SwiftUI

struct SignatureView: View {
    @State var currentImageIndex: Int
    @State var startingImageIndex: Int
    @State var num: Int = 0
    @State private var lines: [Line] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Signature")
            
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
                .frame(height: 150)
            
            NavigationLink {
                CanvasSignatureView(currentImageIndex: $currentImageIndex, lines: $lines, num: $num)
            } label: {
                Text("Sign")
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            .padding(.top, 10)
        }
        .padding(.horizontal, 16)
    }
}

struct Line {
    var points = [CGPoint]()
    var color: Color = Color.black
    var lineWidth: Double = 2.0
}

struct CanvasView: View {
    @State var currentLine = Line()
    @Binding var lines: [Line]
    @Binding var num: Int

    var body: some View {
            ZStack {
                Canvas{context ,size in
                    for line in lines {
                        var path = Path()
                        path.addLines(line.points)
                        context.stroke(path, with: .color(line.color),style:StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
                    }
                    
                }
                .gesture(DragGesture(minimumDistance: 0,coordinateSpace: .local)
                    .onChanged({value in
                        let newPoint = value.location
                        currentLine.points.append(newPoint)
                        self.lines.append(currentLine)
                    })
                        .onEnded({value in
                            self.currentLine = Line(points: [])
                        }))
            }
        }
        
    private func getDigits(number: Int) -> [Int] {
        guard number > 0 else { return [number] }
        var firstDigit = number
        var digits = [Int]()
        while firstDigit > 0 {
            digits.append(firstDigit%10)
            firstDigit = firstDigit / 10
        }
        return digits.reversed()
    }
  
}

struct CanvasSignatureView: View {
    @State private var enterYourSignName: String = ""
    @Binding var currentImageIndex: Int
    @Binding var lines: [Line]
    @Binding var num: Int
    @Environment(\.presentationMode) private var presentationMode
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Signature")
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark.circle")
                        .foregroundStyle(.black)
                        .fontWeight(.bold)
                })
            }
            
            CanvasView(lines: $lines, num: $currentImageIndex)
                .frame(height: 200)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
        
        
            HStack {
                TextField("Type to sign", text: $enterYourSignName)
                    .padding(.horizontal, 10)
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .cornerRadius(10)
                
                Button(action: {
                    self.lines = []
                }, label: {
                    Text("Clear")
                        .foregroundStyle(.black)
                        .frame(width: screenWidth * 0.3,height: 40)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                })
                
            }
            .padding(.top, 10)
            HStack {
                Spacer()
                Button(action: {
                    
                }, label: {
                    Text("Save")
                })
                .buttonStyle(.borderedProminent)
                Spacer()
            }
            
            Spacer()
        }
        .padding(.horizontal, 16.0)
        .navigationBarBackButtonHidden()
        
    }
}


#Preview {
    SignatureView(currentImageIndex: 0, startingImageIndex: 0)
}
