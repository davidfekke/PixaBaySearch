//
//  PixaBayDatasource.swift
//  PixaBaySearch
//
//  Created by David Fekke on 5/9/22.
//

import Foundation

@MainActor
class PixaBayDataSource: ObservableObject {
    
    let pixabayUrlString = "https://pixabay.com/api/?key=25943873-b3fceda0a6c2bc909346ff60a&q={searchplaceholder}&image_type=photo&safesearch=true&page=1&per_page=30"
    
    @Published var previewImages: [String] = []
    
    public func searchForPixaBayImages(text searchText: String) async throws -> Void {
        let newURL = pixabayUrlString.replacingOccurrences(of: "{searchplaceholder}", with: searchText)
        let url = URL(string: newURL)!
        let (data, response) = try await URLSession.shared.data(from: url)

        // Handle response etc by throwing error
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.server
        }
        let pixahits = try JSONDecoder().decode(PixaBayHits.self, from: data)
        
        let hits = pixahits.hits
        //DispatchQueue.main.async {
            previewImages = hits.map { hit in
                hit.previewURL
            }
        //}
        
    }
    
}

enum NetworkError: Error {
    case url
    case server
    case timeout
}
