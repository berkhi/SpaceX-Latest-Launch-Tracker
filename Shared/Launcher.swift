//
//  Launcher.swift
//  SpaceX Latest Launch Tracker
//
//  Created by BerkH on 3.10.2023.
//

import Foundation

class Launcher {
    static let shared = Launcher()
    var launchers: [Modals.LauncherResponse]?

    private init(launchers: [Modals.LauncherResponse]? = nil) {
        if let data = fetchData() {
            self.launchers = data
        }
    }
    private func fetchData() -> [Modals.LauncherResponse]? {
        guard let url = URL(string: "https://api.spacexdata.com/v4/launches/latest") else {
            print("Geçersiz URL")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let launcherResponse = try decoder.decode(Modals.LauncherResponse.self, from: data)
            return [launcherResponse]
        } catch {
            print("Veri çekme hatası: \(error)")
            return nil
        }
    }
}
