//
//  GoalKeeperApp.swift
//  GoalKeeper
//
//  Created by Vitaly on 18/12/21.
//

import SwiftUI

@main
struct GoalKeeperApp: App {
    
    @StateObject private var viewModel = ViewModel()
    @StateObject private var appTheme = AppTheme()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView(areas: $viewModel.areas) {
                    ViewModel.save(areas: viewModel.areas) { result in
                        if case .failure(let error) = result {
                            fatalError(error.localizedDescription)
                        }
                    }
                }
                .navigationBarHidden(true)
            }
            .navigationViewStyle(.stack)
            .environmentObject(viewModel)
            .environmentObject(appTheme)
            .preferredColorScheme(appTheme.appColorScheme)
            .onAppear {
                ViewModel.load { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(let areas):
                        print("App opened. Data was loaded.")
                        viewModel.areas = areas
                    }
                }
            }
        }
    }
}
