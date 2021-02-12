//
//  ContentView.swift
//  News
//
//  Created by Ariel Rodriguez on 11/02/2021.
//

import SwiftUI
import Combine



struct NewsCell: View {
    let story: Story
    init(_ story: Story) {
        self.story = story
    }

    var body: some View {
        VStack(alignment: .center, spacing: nil, content: {
            Text(verbatim: story.title)
        })
    }
}

struct ContentView: View {
    @ObservedObject var model: ReaderViewModel
    
    init(model: ReaderViewModel) {
        self.model = model
        
        self.model.fetchStories()
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.model.allStories) { story in
                    NewsCell(story)
                }
            }
            .navigationTitle("News")
        }
    }
}
