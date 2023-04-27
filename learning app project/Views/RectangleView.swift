//
//  RectangleView.swift
//  learning app project
//
//  Created by Marcel Maciaszek on 27/04/2023.
//

import SwiftUI



struct RectangleView: View {
    
    var color = Color.white
    var body: some View {
        
        Rectangle()
            .foregroundColor(color)
            .cornerRadius(10)
            .shadow(radius:5)
    }
}

struct RectangleView_Previews: PreviewProvider {
    static var previews: some View {
        RectangleView()
    }
}
