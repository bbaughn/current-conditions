# "Current Conditions" Weather demo app

Here's my version of the weather app challenge, it should meet the requirements though I'll put a few thoughts here!

The main thing I would do with more time is break things into separate files, as I noted a few places throughout the project. It would benefit from a separate:

LocationManager

PersistenceManager

CurrentConditionsAppViewModel


To demonstrate UIKit, the modal where you select a location is implemented that way. It's wrapped in a SwiftUI for use in this SwiftUI context.

For now the two components handling the logic, WeatherManager and NetworkService, are singletons but with more time I would use dependency injection (Swinject)

I avoided using the Geocoder API because I didn't want to have to wait for two API calls to complete before getting the weather. However that ended up meaning there are two parallel methods to request the weather data (coordinates and city string) and that makes this more complicated than it probably has to be. I think there is some built-in support in iOS for getting coordinates from a city name but I didn't get to that.

Alerts could be handled better with better design.

With more time I would probably use size classes to change font sizes for different orientations/devices but I did check to see that it lays out ok for those anyway.

I look forward to any next steps in the interview process.
Brian