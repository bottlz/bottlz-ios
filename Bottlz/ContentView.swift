//
//  ContentView.swift
//  Bottlz
//
//  Created by Changyuan Lin on 11/4/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bottleFetcher: BottleFetcher

    @State private var showCreateBottle = false

    var body: some View {
        VStack(spacing: 0.0) {
            BottleMap()
                .edgesIgnoringSafeArea(.all)
            Button {
                showCreateBottle.toggle()
            } label: {
                Text("Create New Bottle")
                    .frame(maxWidth: .infinity)
                    .padding(8)
            }
            .buttonStyle(.bordered)
            .padding()
        }
        .sheet(isPresented: $showCreateBottle) {
            CreateBottleView()
                .presentationDetents([.fraction(0.3)])
        }
        .task {
            try? await bottleFetcher.getAllBottles()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
