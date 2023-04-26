//
//  ContentView.swift
//  learning app project
//
//  Created by Marcel Maciaszek on 23/04/2023.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading){
                Text("What do you want to do today?")
                    .padding(.leading, 20)
                ScrollView {
                    
                    LazyVStack {
                        
                        ForEach(model.modules) { module in
                            //lesson card
                            NavigationLink(
                                destination:
                                    ContentView()
                                    .onAppear(perform: {
                                        model.beginModule(module.id)
                                    }),
                                label: {
                                    HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, count: "\(module.content.lessons.count) Lessons", time: module.content.time)
                                })
                            
                            
                            
                            //test card
                            HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, count: "\(module.test.questions.count) Lessons", time: module.test.time)
                        }
                    }
                        .accentColor(.black)
                        .padding()
                }
            }
            .navigationTitle("Get Started")
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}
