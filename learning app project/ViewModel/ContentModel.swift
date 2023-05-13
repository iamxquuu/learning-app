
import Foundation

class ContentModel: ObservableObject {
    
    // List of modules
    @Published var modules = [Module]()
    
    // Current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // Current lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    //current question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0 
    
    //current lesson explanation
    @Published var codeText = NSAttributedString()
    
    // current selected content and test
    @Published var currentContentSelected:Int?
    @Published var currentTestSelected:Int?
    
    
    var styleData: Data?
    
    init() {
        
        getLocalData()
        getRemoteData()
    }
    
    // MARK: - Data methods
    //parse local included json data
    func getLocalData() {
        
        // Get a url to the json file
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do {
            // Read the file into a data object
            let jsonData = try Data(contentsOf: jsonUrl!)
            
            // Try to decode the json into an array of modules
            let jsonDecoder = JSONDecoder()
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            
            // Assign parsed modules to modules property
            self.modules = modules
        }
        catch {
            // TODO log error
            print("Couldn't parse local data")
        }
        
        // Parse the style data
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do {
            
            // Read the file into a data object
            let styleData = try Data(contentsOf: styleUrl!)
            
            self.styleData = styleData
        }
        catch {
            // Log error
            print("Couldn't parse style data")
        }
        
    }
    //download remote json file and parse data
    func getRemoteData() {
        //string path
        let urlString = "https://iamxquuu.github.io/learning-app-data/data2.json"
        
        let url = URL(string: urlString)
        
        guard url != nil else {
            return
        }
        
        let request = URLRequest(url: url!)
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                //There was an error
                return
            }
            do{
                
                let decoder = JSONDecoder()
                
                let modules = try decoder.decode([Module].self, from: data!)
                
                DispatchQueue.main.async {
                    self.modules += modules
                }
                
               
                
            }
            catch {
                
            }
            
            
        }
        //kick off data task
        dataTask.resume()
        
    }
    
    // MARK: - Module navigation methods
    
    func beginModule(_ moduleid:Int) {
        
        // Find the index for this module id
        for index in 0..<modules.count {
            
            if modules[index].id == moduleid {
            
                // Found the matching module
                currentModuleIndex = index
                break
            }
        }
        
        // Set the current module
        currentModule = modules[currentModuleIndex]
    }
    
    func beginLesson(_ lessonIndex:Int) {
        
        // Check that the lesson index is within range of module lessons
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        }
        else {
            currentLessonIndex = 0
        }
        
        // Set the current lesson
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        codeText = addStyling(currentLesson!.explanation)
        
    }
    
    func nextLesson() {
        
        // Advance the lesson index
        currentLessonIndex += 1
        
        // Check that it is within range
        if currentLessonIndex < currentModule!.content.lessons.count {
            
            // Set the current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
        }
        else {
            // Reset the lesson state
            currentLessonIndex = 0
            currentLesson = nil
        
        }
    }
    
    func beginTest(_ moduleId:Int) {
        beginModule(moduleId)
        
        currentQuestionIndex = 0
        
        if currentModule?.test.questions.count ?? 0 > 0 {
            
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            
            codeText = addStyling(currentQuestion!.content)
            
        }
        
    }
    
    func nextQuestion() {
        //Advance the question index
        currentQuestionIndex += 1
        
        if currentQuestionIndex < currentModule!.test.questions.count {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
            
        }else{
            currentQuestionIndex = 0
            currentQuestion = nil
        }
    }
    
    func hasNextLesson() -> Bool {
        
        guard currentModule != nil else {
            return false
        }
        
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
    }
    
    
    //MARK : code styling
    private func addStyling(_ htmlString: String) -> NSAttributedString {
        var resultString = NSAttributedString()
        var data = Data()
        
        if styleData != nil{
            data.append(self.styleData!)
        }
        
        data.append(Data(htmlString.utf8))
        
        do {
            
            let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            
            resultString = attributedString
            
            
        }
        catch{
            print("Couldnt turn html into attributed string")
        }

        return resultString
    }
    
}
