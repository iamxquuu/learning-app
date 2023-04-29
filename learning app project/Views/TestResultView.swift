//
//  TestResultView.swift
//  learning app project
//
//  Created by Marcel Maciaszek on 29/04/2023.
//

import SwiftUI

struct TestResultView: View {
    
    @EnvironmentObject var model:ContentModel
    
    var numCorrect: Int
    
    var resultHeading: String {
        
        guard model.currentModule != nil else {
            return ""
        }
        
        let pct = Double(numCorrect)/Double(model.currentModule!.test.questions.count)
        
        if pct > 0.5 {
            return "AWESOME"
        }
        else if pct > 0.2 {
            return "Doing great!"
            
        }
        else{
            return "Keep learning"
        }
        
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text(resultHeading)
                .font(.title)
            Spacer()
            Text("You got \(numCorrect) out of \(model.currentModule?.test.questions.count ?? 0) Questions")
            Spacer()
            Button {
                model.currentTestSelected = nil
            } label: {
                ZStack {
                    RectangleView(color: .green)
                        .frame(height: 48)
                    Text("Complete")
                        .foregroundColor(.white)
                }.padding()
            }

        }
    }
}
