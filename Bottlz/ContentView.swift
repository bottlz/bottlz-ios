//
//  ContentView.swift
//  Bottlz
//
//  Created by Changyuan Lin on 11/4/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        BottleMap()
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
