//
//  DateTimeView.swift
//  JoyFill
//
//  Created by Babblu Bhaiya on 10/02/24.
//

import SwiftUI

// Date and time

struct DateTimeView: View {
    @State private var isDatePickerPresented = false
    @State private var selectedDate = Date()
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Date & Time")
            
            Button(action: {
                isDatePickerPresented.toggle()
            }, label: {
                    Text(formattedDate(selectedDate))
                    .padding(.trailing, screenHeight * 0.24)
                    .foregroundStyle(.black)
                    .font(.title3)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                            .frame(width: screenWidth * 0.92)
                            
                    )
            })
            .sheet(isPresented: $isDatePickerPresented, onDismiss: {
                print("DatePicker dismissed")
            }) {
                DatePicker(
                    "Select a date",
                    selection: $selectedDate,
                    in: Date()...,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .onChange(of: selectedDate) { _ in
                    isDatePickerPresented = false
                }
            }
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
}

#Preview {
    DateTimeView()
}
