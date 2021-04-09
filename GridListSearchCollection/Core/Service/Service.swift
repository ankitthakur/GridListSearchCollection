//
//  Service.swift
//  GridListSearchCollection
//
//  Created by Ankit Thakur on 09/04/21.
//

import Foundation
import Alamofire

class Service {
    
    static func searchResults(for searchValue:String, atIndex pageIndex: Int = 1) {
        print("url is https://www.omdbapi.com/?apikey=7d58cc52&s=\(searchValue)&page=\(pageIndex)")
        AF.request("https://www.omdbapi.com/?apikey=7d58cc52&s=\(searchValue)&page=\(pageIndex)", method: .get, encoding: JSONEncoding.default)
            .responseJSON { (response) in
//                print("received response \(response)")
                if let error = response.error {
                    print("received response \(response)")
                    ServiceEventManager.shared.didReceiveError(error)
                } else {
                    do {
                        guard let data = response.data else {return}
                        print(String(data: data, encoding: .utf8))
                        let responseJSON = try JSONDecoder().decode(IMDBSearchDataModel.self, from: data)
                        ServiceEventManager.shared.didReceiveSearchResults(responseJSON)
                    } catch let error {
                        print(error)
                        ServiceEventManager.shared.didReceiveError(error)
                    }
                }
            }
    }
}
