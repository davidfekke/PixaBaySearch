//
//  ContentView.swift
//  PixaBaySearch
//
//  Created by David Fekke on 5/9/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var pixaBarDatasource = PixaBayDataSource()
    @State private var searchString = "Apple"
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(pixaBarDatasource.previewImages, id: \.self) { imageURL in
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 200, height: 200)
                }
    //
             }.navigationTitle("Image Search")
        }
        .searchable(text: $searchString, prompt: "Search images")
        .onChange(of: searchString, perform: { newValue in
            Task {
                if newValue.count > 3 {
                    try await pixaBarDatasource.searchForPixaBayImages(text: newValue)
                }
                
            }
        })
        .onAppear(perform: {
             Task {
                 try await pixaBarDatasource.searchForPixaBayImages(text: searchString)
             }
         })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
