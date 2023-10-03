//
//  LauncherServices.swift
//  SpaceX Latest Launch Tracker
//
//  Created by BerkH on 2.10.2023.
//
import Foundation
import Alamofire
import Shared

public class LauncherServices {
    static func fetchLatestLauncher(completion: @escaping (Result<LauncherResponse, Error>) -> Void) {
        let url = "https://api.spacexdata.com/v4/launches/latest"
        
        AF.request(url).responseDecodable(of: LauncherResponse.self) { response in
            switch response.result {
            case .success(let launcherResponse):
                completion(.success(launcherResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
