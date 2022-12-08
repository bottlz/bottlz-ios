//
//  BottleFetcher.swift
//  Bottlz
//
//  Created by Changyuan Lin on 11/6/22.
//

import CoreLocation

class BottleFetcher: ObservableObject {
    @Published var bottleData: [Bottle] = []
    @Published var selectedBottle: Bottle? = nil

    static let baseURL = URL(string: "https://bottlz.azurewebsites.net")!
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }()

    init(bottleData: [Bottle] = [], selectedBottle: Bottle? = nil) {
        self.bottleData = bottleData
        self.selectedBottle = selectedBottle
    }

    enum FetchError: Error {
        case badRequest
    }

    var selectedBottleDrawingURL: URL {
        URL(string: "drawings/get/\(selectedBottle?.id.uuidString.lowercased() ?? "")", relativeTo: BottleFetcher.baseURL)!
    }

    func getAllBottles() async throws {
        guard let url = URL(string: "bottles/getAll", relativeTo: BottleFetcher.baseURL) else { return }

        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print("getAllBottles error", String(data: data, encoding: .utf8)!)
            throw FetchError.badRequest
        }

        Task { @MainActor in
            try bottleData = decoder.decode(GetAllBottlesData.self, from: data).bottles
            print("All Bottles", bottleData)
        }
    }

    func createBottle(location: CLLocationCoordinate2D) async throws {
        guard let url = URL(string: "bottles/create", relativeTo: BottleFetcher.baseURL) else { return }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let payload = try JSONEncoder().encode([
            "location": [
                "lat": location.latitude,
                "lon": location.longitude
            ]
        ])

        let (data, response) = try await URLSession.shared.upload(for: urlRequest, from: payload)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print("createBottle error", String(data: data, encoding: .utf8)!)
            throw FetchError.badRequest
        }

        Task { @MainActor in
            let createdBottle = try decoder.decode(Bottle.self, from: data)
            print("Created Bottle", createdBottle)
            bottleData.append(createdBottle)
        }
    }

    private struct GetAllBottlesData: Codable {
        var bottles: [Bottle]
    }
}
