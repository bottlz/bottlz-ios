//
//  BottleFetcher.swift
//  Bottlz
//
//  Created by Changyuan Lin on 11/6/22.
//

import Foundation

class BottleFetcher: ObservableObject {
    @Published var bottleData: [Bottle] = []

    let baseURL = URL(string: "https://bottlz.azurewebsites.net")
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }()

    enum FetchError: Error {
        case badRequest
    }

    func getAllBottles() async throws {
        guard let url = URL(string: "bottles/getAll", relativeTo: baseURL) else { return }

        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { print("bad request"); throw FetchError.badRequest }

        Task { @MainActor in
            try bottleData = decoder.decode(GetAllBottlesData.self, from: data).bottles
            print("All Bottles", bottleData)
        }
    }

    private struct GetAllBottlesData: Decodable {
        var bottles: [Bottle]
    }
}
