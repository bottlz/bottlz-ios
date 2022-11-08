//
//  BottlzApp.swift
//  Bottlz
//
//  Created by Changyuan Lin on 10/26/22.
//

import SwiftUI

@main
struct BottlzApp: App {
    @StateObject private var bottleFetcher = BottleFetcher()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bottleFetcher)
        }
    }
}
