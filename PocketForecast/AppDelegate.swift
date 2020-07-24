////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var cityDao: CityDao?
    var rootViewController: RootViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        NSLog("application didFinishLaunching")
        ICLoader.setImageName("cloud_icon.png")
        ICLoader.setLabelFontName(UIFont.applicationFontOfSize(size: 10).fontName)
        
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName : UIFont.applicationFontOfSize(size: 20),
            NSForegroundColorAttributeName : UIColor.white
        ]
        
        self.window = UIWindow(frame: UIScreen.main.bounds)

        // Set empty VC.
        self.window?.rootViewController = UIViewController()

        let cloudsOverTheCityTheme = Theme()
        cloudsOverTheCityTheme.backgroundResourceName = "bg3.png"
        cloudsOverTheCityTheme.navigationBarColor = UIColor(hexRGB: 0x641d23)
        cloudsOverTheCityTheme.forecastTintColor = UIColor(hexRGB: 0x641d23)
        cloudsOverTheCityTheme.controlTintColor = UIColor(hexRGB: 0x7f9588)

        let lightsInTheRainTheme = Theme()
        lightsInTheRainTheme.backgroundResourceName = "bg4.png"
        lightsInTheRainTheme.navigationBarColor = UIColor(hexRGB: 0xeaa53d)
        lightsInTheRainTheme.forecastTintColor = UIColor(hexRGB: 0x722d49)
        lightsInTheRainTheme.controlTintColor = UIColor(hexRGB: 0x722d49)

        let beachTheme = Theme()
        beachTheme.backgroundResourceName = "bg5.png"
        beachTheme.navigationBarColor = UIColor(hexRGB: 0x37b1da)
        beachTheme.forecastTintColor = UIColor(hexRGB: 0x37b1da)
        beachTheme.controlTintColor = UIColor(hexRGB: 0x0043a6)

        let sunsetTheme = Theme()
        sunsetTheme.backgroundResourceName = "sunset.png"
        sunsetTheme.navigationBarColor = UIColor(hexRGB: 0x0a1d3b)
        sunsetTheme.forecastTintColor = UIColor(hexRGB: 0x0a1d3b)
        sunsetTheme.controlTintColor = UIColor(hexRGB: 0x606970)

        let themeFactory =
            ThemeFactory(themes: [
                cloudsOverTheCityTheme,
                lightsInTheRainTheme,
                beachTheme,
                sunsetTheme,
            ])

        let weatherReportView = WeatherReportView()
        weatherReportView.theme = themeFactory.sequentialTheme()

        let weatherReportDao = WeatherReportDaoFileSystemImpl()

        let weatherClient = WeatherClientBasicImpl()
        weatherClient.serviceUrl = NSURL(string: "http://ya.ru")
        weatherClient.apiKey = "$asdfc."
        weatherClient.weatherReportDao = weatherReportDao
        weatherClient.daysToRetrieve = 5

        let cityDao = CityDaoUserDefaultsImpl(defaults: UserDefaults.standard)

        let weatherReportViewController =
            WeatherReportViewController(
                view: weatherReportView,
                weatherClient: weatherClient,
                weatherReportDao: weatherReportDao,
                cityDao: cityDao
            )


        self.rootViewController =
            RootViewController(
                mainContentViewController: weatherReportViewController
            )



        self.window?.rootViewController = self.rootViewController

        /*
        
        let selectedCity : String! = cityDao!.loadSelectedCity()
        if selectedCity == nil {
            rootViewController?.showCitiesListController()
        }
        */

        self.window?.makeKeyAndVisible()
                
        return true
    }
    

    
}

