//
//  CreateBottleView.swift
//  Bottlz
//
//  Created by Changyuan Lin on 11/5/22.
//

import SwiftUI

struct CreateBottleView: View {
    @Environment(\.dismiss) var dismiss

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
            } label: {
                Text("Confirm")
                    .frame(maxWidth: .infinity)
                    .padding(8)
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

struct CreateBottleView_Previews: PreviewProvider {
    static var previews: some View {
        CreateBottleView()
    }
}
