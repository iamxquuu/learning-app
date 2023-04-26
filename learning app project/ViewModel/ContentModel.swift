//
//  ContentModel.swift
//  learning app project
//
//  Created by Marcel Maciaszek on 25/04/2023.
//

import Foundation

class ContentModel: ObservableObject {
    @Published var modules = [Module]()
    //current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    var styleData: Data?
    
    init() {
        
        getLocalData()
        
    }
    
    // MARK: Data methods
    
    func getLocalData() {
        
        let jsonUrl =
        Bundle.main.url(forResource: "data", withExtension: "json")
        
        do {
            let jsonData = try Data(contentsOf: jsonUrl!)
            
            let jsonDecoder = JSONDecoder()
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            self.modules = modules
        }
        catch {
            print("Couldnt parse local data")
        }
        
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        do {
            let styleData = try Data(contentsOf: styleUrl!)
            self.styleData = styleData
        }
        catch{
            print("Couldnt parse style data")
        }
        
        
    }
    
    // MARK: Module navigation methods
    
    func beginModule(_ moduleid:Int){
        
        for index in 0..<modules.count {
            if modules[index].id == moduleid {
                currentModuleIndex = index
                break
            }
        }
        
        currentModule = modules[currentModuleIndex]
        
    }
    
    func beginLesson(_ lessonIndex:Int) {
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        }
        else{
            currentLessonIndex = 0
        }
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
    }
    func nextLesson() {
        currentLessonIndex += 1
        
        if currentLessonIndex < currentModule!.content.lessons.count {
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
        }
        else{
            currentLesson = nil
            currentLessonIndex = 0
        }
    }
    
    func hasNextLesson() -> Bool {
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
    }
}
