//
//  ViewBottleView.swift
//  Bottlz
//
//  Created by Changyuan Lin on 11/12/22.
//

import SwiftUI

struct ViewBottleView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("View Bottle")
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                    }
                }
                .font(.title2)
            }
            Spacer()
            Rectangle()
                .aspectRatio(1.0, contentMode: .fit)
            Spacer()
            Button {
                print("Pressed Edit")
            } label: {
                Text("Edit")
                    .frame(maxWidth: .infinity)
                    .padding(8)
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

struct ViewBottleView_Previews: PreviewProvider {
    static var previews: some View {
        ViewBottleView()
    }
}
