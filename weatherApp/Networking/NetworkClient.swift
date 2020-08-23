//
//  NetworkClient.swift
//  weatherApp
//
//  Created by Clement  Wekesa on 23/08/2020.
//

import Foundation

class NetworkClient {
    static let standard = NetworkClient()

    private init() {}

    func get(city: String, completion: @escaping (_ status: Bool, _ data: [String: Any]?) -> ()) {

        guard
            let url = URL(string:
                            "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(Config.apiKey)")
        else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard
                error == nil,
                let responseData = data
            else { return completion(false, nil) }
            
            let decorder = JSONDecoder()
            
            do {
//                let weatherData = try? decorder.decode(WeatherResult.self, from: data!)
//
//
//                print("------------------>>>>>>>>: \(weatherData)")
//
//
                guard
                    let formattedData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                else {
                    completion(false, nil)
                    print("ERROR: Faild to serialize ")
                    return
                }
                guard
                    let status = (response as? HTTPURLResponse)?.statusCode
                else { return completion(false, nil) }
                if String(status).first == "2" {
                    return completion(true, formattedData)
                }
                completion(false, nil)
            } catch {
                completion(false, nil)
            }
        }
        task.resume()
    }
}
