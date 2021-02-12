//
//  NewsApp.swift
//  News
//
//  Created by Ariel Rodriguez on 11/02/2021.
//

import SwiftUI

@main
struct NewsApp: App {
    let model = ReaderViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(model: model)
        }
    }
}
