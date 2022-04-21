//
//  WeatherAPI Service.swift
//  MVVM Demo
//
//  Created by Leo Ho on 2022/4/21.
//  Copyright © 2022 Leo Ho. All rights reserved.
//

import Foundation

class WeatherAPIService: NSObject {
    static let shared = WeatherAPIService()
    
    // MARK: 取得天氣資料
    
    func getWeatherData(city: String, finish: @escaping ((WeatherData) -> Void)) {
        let address = "https://api.openweathermap.org/data/2.5/weather?"
        let apikey = "62ef5eba4eeb4662491645f8f68cc219"
        if let url = URL(string: address + "q=\(city)" + "&appid=" + apikey) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let response = response as? HTTPURLResponse, let data = data {
                    print("Status Code: \(response.statusCode)")
                    let decoder = JSONDecoder()
                    guard let weatherData = try? decoder.decode(WeatherData.self, from: data) else { return }
                    print("============== Weather Data ==============")
                    print(weatherData)
                    print("============== Weather Data ==============")
                    finish(weatherData) // 將查詢結果透過 Closure 回傳到 ViewModel
                }
            }.resume()
        } else {
            print("無效的 URL")
        }
    }
}
