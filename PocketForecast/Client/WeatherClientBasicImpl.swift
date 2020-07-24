////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

import Foundation

public class WeatherClientBasicImpl: NSObject, WeatherClient {

    var weatherReportDao: WeatherReportDao?
    var serviceUrl: NSURL?
    var daysToRetrieve: NSNumber?

    var apiKey: String? {
        willSet(newValue) {
            assert(newValue != "$$YOUR_API_KEY_HERE$$", "Please get an API key (v2) from: http://free.worldweatheronline.com, and then " +
                    "edit 'Configuration.plist'")
        }
    }

    public func loadWeatherReportFor(city: String!, onSuccess successBlock: @escaping ((WeatherReport) -> Void), onError errorBlock: @escaping ((String) -> Void)) {


        /*
        DispatchQueue.global(priority: .high).async() {
            let url = self.queryURL(city: city)
            let data : Data! = try! Data(contentsOf: url)
            
            let dictionary = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary

            if let error = dictionary.parseError() {
                DispatchQueue.main.async() {
                    errorBlock(error.rootCause())
                    return
                }
            } else {
                let weatherReport: WeatherReport = dictionary.toWeatherReport()
                self.weatherReportDao!.saveReport(weatherReport: weatherReport)
                DispatchQueue.main.async() {
                    successBlock(weatherReport)
                    return
                }
            }
        }
        */

        let nsnow = NSDate()
        let now = Date()
        let temperature = Temperature(celciusString: "33 C")

        let conditions =
            CurrentConditions(
                summary: "Солнечно",
                temperature: temperature,
                humidity: "77",
                wind: "ЮЗ",
                imageUri: "https://www.nastol.com.ua/pic/201406/2560x1440/nastol.com.ua-101323.jpg"
            )

        let forecast =
            ForecastConditions(
                date: now,
                low: nil,
                high: nil,
                summary: "Будущее интересно",
                imageUri: "http://ftp.habermark.com/upload/fotograf/cache/520x500/fotograf_c26dd6ade609362d4d0e8c2552b70e42ecb72cfa.jpg"
            )
        let forecasts = [forecast]

        let weatherReport =
            WeatherReport(
                city: city,
                date: nsnow,
                currentConditions: conditions,
                forecast: forecasts
            )
        self.weatherReportDao!.saveReport(weatherReport: weatherReport)
        successBlock(weatherReport)
    }


    private func queryURL(city: String) -> URL {

        let serviceUrl: NSURL = self.serviceUrl!
        return serviceUrl.uq_URL(byAppendingQueryDictionary: [
            "q": city,
            "format": "json",
            "num_of_days": daysToRetrieve!.stringValue,
            "key": apiKey!
        ])
    }


}
