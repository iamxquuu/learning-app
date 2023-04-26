//
//  ContentDetailView.swift
//  learning app project
//
//  Created by Marcel Maciaszek on 26/04/2023.
//

import SwiftUI
import AVKit


struct ContentDetailView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        let lesson = model.currentLesson
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ??  ""))
        VStack{
            if url != nil {
                VideoPlayer(player: AVPlayer(url: url!))
                    .cornerRadius(10)
            }
            
            // Description
            
            // next lesson button, only if there is a next lesson
            if model.hasNextLesson() {
                Button(action: {
                    model.nextLesson()
                    
                }, label: {
                    
                    ZStack{
                        
                        Rectangle()
                            .frame(height: 48)
                            .foregroundColor(Color.green)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            
                        
                        Text("Next Lesson: \(model.currentModule!.content.lessons[model.currentLessonIndex + 1].title)")
                            .foregroundColor(Color.white)
                            .bold()
                        
                    }
                })
                
            }
            
            
        }
            .padding()
        
        
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
    }
}
