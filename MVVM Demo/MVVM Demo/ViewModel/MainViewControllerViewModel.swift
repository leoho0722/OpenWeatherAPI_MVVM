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
        WeatherAPIService.shared.getWeatherData(city: city) { weatherData in
            self.mainViewControllerViewModelDelegate?.didFetchWeatherData(data: weatherData)
        }
    }
    
}

// MARK: - MainViewControllerViewModelDelegate

protocol MainViewControllerViewModelDelegate {
    func didFetchWeatherData(data: WeatherData) // API Response 回傳後要的事情
}
