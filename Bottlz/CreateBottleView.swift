//
//  CreateBottleView.swift
//  Bottlz
//
//  Created by Changyuan Lin on 11/5/22.
//

import SwiftUI

struct CreateBottleView: View {
    @EnvironmentObject var bottleFetcher: BottleFetcher
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.dismiss) var dismiss

    @State private var isCreatingBottle = false

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Create New Bottle")
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                    }
                }
                .font(.title2)
                .padding(.bottom, 4.0)
                Text("This will spawn a new bottle on a road near your location")
            }
            Spacer()
            Button {
                print("Pressed Confirm")
                isCreatingBottle = true
                Task {
                    try await bottleFetcher.createBottle(location: locationManager.currentLocation)
                    isCreatingBottle = false
                    dismiss()
                }
            } label: {
                Text("Confirm")
                    .frame(maxWidth: .infinity)
                    .padding(8)
            }
            .buttonStyle(.bordered)
            .disabled(isCreatingBottle)
        }
        .padding()
    }
}

struct CreateBottleView_Previews: PreviewProvider {
    static var previews: some View {
        CreateBottleView()
            .environmentObject(BottleFetcher())
            .environmentObject(LocationManager())
    }
}
