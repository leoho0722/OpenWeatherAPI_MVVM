//
//  MainViewControllerViewModel.swift
//  MVVM Demo
//
//  Created by Leo Ho on 2022/4/21.
//  Copyright © 2022 Leo Ho. All rights reserved.
//

import Foundation

class MainViewControllerViewModel {
    
    let cityList = ["Taipei", "New Taipei", "Taoyuan", "Taichung", "Tainan", "Kaohsiung", "New York"]
    
    let cityListURL = ["Taipei", "New%20Taipei", "Taoyuan", "Taichung", "Tainan", "Kaohsiung", "New%20York"]
    
    var mainViewControllerViewModelDelegate: MainViewControllerViewModelDelegate?
    
    // 將 URL 支援的格式轉為常見的名稱
    func cityNameURLFormatter(city: String) -> String {
        switch city {
        case "Taipei": return "Taipei"
        case "New%20Taipei": return "New Taipei"
        case "Taoyuan": return "Taoyuan"
        case "Taichung": return "Taichung"
        case "Tainan": return "Tainan"
        case "Kaohsiung": return "Kaohsiung"
        case "New%20York": return "New York"
        default: return "No city has been selected"
        }
    }
    
    // 呼叫 ViewModel 的 WeatherAPIService 來執行 API 查詢
    func fetchWeatherData(city: String) {
        if #available(iOS 15.0, *) {
            Task {
                do {
                    let weatherData = try await WeatherAPIService.shared.getWeatherData(city: city)
                    self.mainViewControllerViewModelDelegate?.didFetchWeatherData(data: weatherData)
                } catch WeatherAPIService.WeatherDataFetchError.invalidURL {
                    print("無效的 URL")
                } catch WeatherAPIService.WeatherDataFetchError.requestFailed {
                    print("Request Error")
                } catch WeatherAPIService.WeatherDataFetchError.responseFailed {
                    print("Response Error")
                } catch WeatherAPIService.WeatherDataFetchError.jsonDecodeFailed {
                    print("JSON Decode 失敗")
                }
            }
        } else if #available(iOS 14.0, *) {
            WeatherAPIService.shared.getWeatherData(city: city) { result in
                switch result {
                case .success(let weatherData):
                    self.mainViewControllerViewModelDelegate?.didFetchWeatherData(data: weatherData)
                case.failure(let fetchError):
                    switch fetchError {
                    case .invalidURL:
                        print("無效的 URL")
                    case .requestFailed:
                        print("Request Error")
                    case .responseFailed:
                        print("Response Error")
                    case .jsonDecodeFailed:
                        print("JSON Decode 失敗")
                    }
                }
            }
        } else {
            WeatherAPIService.shared.getWeatherData(city: city) { weatherData in
                self.mainViewControllerViewModelDelegate?.didFetchWeatherData(data: weatherData)
            } failure: { weatherFetchError in
                switch weatherFetchError {
                case .invalidURL:
                    print("無效的 URL")
                case .requestFailed:
                    print("Request Error")
                case .responseFailed:
                    print("Response Error")
                case .jsonDecodeFailed:
                    print("JSON Decode 失敗")
                }
            }
        }
    }
    
}

// MARK: - MainViewControllerViewModelDelegate

protocol MainViewControllerViewModelDelegate {
    func didFetchWeatherData(data: WeatherData) // API Response 回傳後要的事情
}
