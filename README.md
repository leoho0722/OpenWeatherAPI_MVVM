# OpenWeatherAPI_MVVM

iOS App 開發練習 − 天氣 API 練習

開發語言：Swift 5

開發環境：Xcode 13.4.1

App 最低安裝限制：iOS 13.0

API 來源：OpenWeather

### WeatherDataFetchError
```swift
enum WeatherDataFetchError: Error {
    case invalidURL
    case requestFailed
    case responseFailed
    case jsonDecodeFailed
}
```

### Result type Support！
```swift
@available(iOS 14.0, *)
@available(swift 5.0)
func getWeatherData(city: String, completion: @escaping (Result<WeatherData, WeatherDataFetchError>) -> Void) {
    let address = "https://api.openweathermap.org/data/2.5/weather?"
    let apikey = "YOUR_API_KEY"
    
    guard let url = URL(string: address + "q=\(city)" + "&appid=" + apikey) else {
        completion(.failure(.invalidURL))
        return
    }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        guard error == nil else {
            print("Error: \(error?.localizedDescription)")
            completion(.failure(.requestFailed))
            return
        }
        
        guard let response = response as? HTTPURLResponse, let data = data else {
            completion(.failure(.responseFailed))
            return
        }
        print("Status Code: \(response.statusCode)")
        
        let decoder = JSONDecoder()
        guard let weatherData = try? decoder.decode(WeatherData.self, from: data) else {
            completion(.failure(.jsonDecodeFailed))
            return
        }
        
        #if DEBUG
        print("============== Weather Data ==============")
        print(weatherData)
        print("============== Weather Data ==============")
        #endif
        
        completion(.success(weatherData)) // 將 API Response 的資料結構 (Model) 也就是 WeatherData，透過 Closure 回傳給 ViewModel
    }.resume()
}
```

### await/async Support！
```swift
@available(iOS 15.0, *)
@available(swift 5.5)
func getWeatherData(city: String) async throws -> WeatherData {
    let address = "https://api.openweathermap.org/data/2.5/weather?"
    let apikey = "YOUR_API_KEY"
    
    guard let url = URL(string: address + "q=\(city)" + "&appid=" + apikey) else {
        throw WeatherDataFetchError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse else {
        throw WeatherDataFetchError.responseFailed
    }
    print("Status Code: \(response.statusCode)")
    
    let decoder = JSONDecoder()
    guard let weatherData = try? decoder.decode(WeatherData.self, from: data) else {
        throw WeatherDataFetchError.jsonDecodeFailed
    }
    
    #if DEBUG
    print("============== Weather Data ==============")
    print(weatherData)
    print("============== Weather Data ==============")
    #endif
    
    return weatherData
}
```
