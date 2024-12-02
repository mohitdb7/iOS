//
//  MovieNavigationViewModel.swift
//  HeroNavigationExample
//
//  Created by Mohit Dubey on 22/02/24.
//

import Foundation

class MovieNavigationViewModel: ObservableObject {
    @FileWithData(fileNameWithExtension: "movieData.json")
    private var fileData: Data?
    
    @Published var movies: [MovieModel] = []
    
    func assignBeautifiedJson() {
        if let fileData {
            do {
                let beautifiedJson = try BeautifiedJson(data: fileData)
                for movie in beautifiedJson.movies.array ?? [] {
                    let movieModel = MovieModel(
                        id: movie.Id.string ?? "",
                        poster: movie.Poster.string,
                        title: movie.Title.string,
                        year: movie.Year.string,
                        runtime: movie.Runtime.string)
                    movies.append(movieModel)
                }
            } catch {
                print("Exception \(error.localizedDescription)")
            }
        }
    }
}

struct MovieModel: Hashable {
    var id: String
    var poster: String?
    var title: String?
    var year: String?
    var runtime: String?
}
