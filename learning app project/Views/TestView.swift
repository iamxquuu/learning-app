//
//  TestView.swift
//  learning app project
//
//  Created by Marcel Maciaszek on 27/04/2023.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model:ContentModel
    @State var selectedAnswerIndex:Int?
    @State var numCorrect = 0
    @State var submitted = false
    
    var body: some View {
        if model.currentQuestion != nil {
            
            VStack (alignment: .leading){
                Text("Question \(model.currentQuestionIndex + 1) of\(model.currentModule?.test.questions.count ?? 0)").padding(.leading, 20)
                
                
                CodeTextView()
                    .padding(.horizontal, 20)
                
                ScrollView {
                    VStack {
                        ForEach(0..<model.currentQuestion!.answers.count, id: \.self) { index in
                            
                            Button {
                                // track the selected index
                                selectedAnswerIndex = index
                                
                                
                            } label: {
                                ZStack {
                                    if submitted == false{
                                        
                                        RectangleView(color: index == selectedAnswerIndex ? .gray : .white)
                                            .frame(height: 48)
                                        
                                    }else {
                                        //Answer has been submitted
                                        if index == selectedAnswerIndex && index == model.currentQuestion!.correctIndex {
                                            
                                            //user has selected correct answer
                                            RectangleView(color: Color.green)
                                                .frame(height: 48)
                                        }else if index == selectedAnswerIndex && index != model.currentQuestion!.correctIndex {
                                            
                                            //user has selected the wrong answer
                                            RectangleView(color: Color.red)
                                                .frame(height: 48)
                                        }else if index == model.currentQuestion!.correctIndex {
                                            
                                            //This button is the correct answer
                                            RectangleView(color: Color.green)
                                                .frame(height: 48)
                                            
                                        }
                                        else {
                                            RectangleView(color: Color.white)
                                                .frame(height: 48)
                                        }
                                            
                                    }
                                    
                                    
                                    Text(model.currentQuestion!.answers[index])
                                }
                                
                            }
                            .disabled(submitted)
                        }
                    }
                    .accentColor(.black)
                    .padding()
                }
                
                Button {
                    
                    submitted = true
                    
                    if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                        numCorrect += 1
                    }
                    
                } label: {
                    
                    ZStack {
                        
                        RectangleView(color: .green)
                            .frame(height: 48)
                        Text("Submit")
                            
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding()
                }
                .disabled(selectedAnswerIndex == nil)

                
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
            
        }
        else {
            //Test hasnt loaded yet
            ProgressView()
        }
        
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
