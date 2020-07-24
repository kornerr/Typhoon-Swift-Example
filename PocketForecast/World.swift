
public typealias ApplicationAssembly = World
public typealias ThemeAssembly = World
public typealias CoreComponents = World

public class World {

    // // // //
    // ApplicationAssembly.
    // // // //

    private var rootVC: RootViewController?

    func rootViewController() -> RootViewController {
        if let rootVC = rootVC {
            return rootVC
        }
        rootVC =
            RootViewController(
                mainContentViewController: weatherReportController(),
                assembly: self
            )
        return rootVC!
    }

    func weatherReportController() -> WeatherReportViewController {
        return
            WeatherReportViewController(
                view: weatherReportView(),
                weatherClient: weatherClient(),
                weatherReportDao: weatherReportDao(),
                cityDao: cityDao(),
                assembly: self
            )
    }

    func weatherReportView() -> WeatherReportView {
        let view = WeatherReportView()
        view.theme = currentTheme()
        return view
    }

    func citiesListController() -> CitiesListViewController {
        let vc = CitiesListViewController(cityDao: cityDao(), theme: currentTheme())
        vc.assembly = self
        return vc
    }

    func addCityViewController() -> AddCityViewController {
        let vc = AddCityViewController(nibName: "AddCity", bundle: Bundle.main)
        vc.cityDao = cityDao()
        vc.weatherClient = weatherClient()
        vc.theme = currentTheme()
        vc.rootViewController = rootViewController()
        return vc
    }

    // // // //
    // CoreComponents.
    // // // //

    func weatherClient() -> WeatherClientBasicImpl {
        let client = WeatherClientBasicImpl()
        client.serviceUrl = NSURL(string: "http://ya.ru")
        client.apiKey = "$asdfc."
        client.weatherReportDao = weatherReportDao()
        client.daysToRetrieve = 5
        return client
    }

    func weatherReportDao() -> WeatherReportDaoFileSystemImpl {
        return WeatherReportDaoFileSystemImpl()
    }
    
    func cityDao() -> CityDaoUserDefaultsImpl {
        return CityDaoUserDefaultsImpl(defaults: UserDefaults.standard)
    }

    // // // //
    // ThemeAssembly.
    // // // //

    func currentTheme() -> Theme {
        return themeFactory().sequentialTheme()
    }

    private var tf: ThemeFactory?

    func themeFactory() -> ThemeFactory {
        if let tf = tf {
            return tf
        }
        tf = 
            ThemeFactory(themes: [
                cloudsOverTheCityTheme(),
                lightsInTheRainTheme(),
                beachTheme(),
                sunsetTheme(),
            ])
        return tf!
    }

    func cloudsOverTheCityTheme() -> Theme {
        var theme = Theme()
        theme.backgroundResourceName = "bg3.png"
        theme.navigationBarColor = UIColor(hexRGB: 0x641d23)
        theme.forecastTintColor = UIColor(hexRGB: 0x641d23)
        theme.controlTintColor = UIColor(hexRGB: 0x7f9588)
        return theme
    }

    func lightsInTheRainTheme() -> Theme {
        var theme = Theme()
        theme.backgroundResourceName = "bg4.png"
        theme.navigationBarColor = UIColor(hexRGB: 0xeaa53d)
        theme.forecastTintColor = UIColor(hexRGB: 0x722d49)
        theme.controlTintColor = UIColor(hexRGB: 0x722d49)
        return theme
    }

    func beachTheme() -> Theme {
        var theme = Theme()
        theme.backgroundResourceName = "bg5.png"
        theme.navigationBarColor = UIColor(hexRGB: 0x37b1da)
        theme.forecastTintColor = UIColor(hexRGB: 0x37b1da)
        theme.controlTintColor = UIColor(hexRGB: 0x0043a6)
        return theme
    }

    func sunsetTheme() -> Theme {
        var theme = Theme()
        theme.backgroundResourceName = "sunset.png"
        theme.navigationBarColor = UIColor(hexRGB: 0x0a1d3b)
        theme.forecastTintColor = UIColor(hexRGB: 0x0a1d3b)
        theme.controlTintColor = UIColor(hexRGB: 0x606970)
        return theme
    }
}


