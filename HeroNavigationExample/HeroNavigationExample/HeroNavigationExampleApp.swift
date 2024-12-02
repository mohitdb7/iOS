//
//  HeroNavigationExampleApp.swift
//  HeroNavigationExample
//
//  Created by Mohit Dubey on 22/02/24.
//

import SwiftUI

@main
struct HeroNavigationExampleApp: App {
    var body: some Scene {
        WindowGroup {
            HeroMovieListUI(vm: MovieNavigationViewModel())
        }
    }
}
