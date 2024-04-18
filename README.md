# Cat Cafe Manager on SwiftUI MVVM

[![Build Status](https://img.shields.io/badge/platforms-iOS-green.svg)](https://github.com/VitaliusSch/SwiftUi-MVVM-Cafe-Manager-WithCatApi)
[![Swift](https://img.shields.io/badge/Swift-5.7-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-14.0-blue.svg)](https://developer.apple.com/xcode)
[![MIT](https://img.shields.io/badge/licenses-MIT-red.svg)](https://opensource.org/licenses/MIT)

## About
Cat Cafe Manager is a training game project for learning SwiftUi.
The following is implemented in this project:
- MVVM
- Asynchronous navigation
- Asynchronous work of URLSession with Rest-API
- Pagination works with/without API-KEY
- Actors
- MapKit
- SQLight with GRDB https://github.com/groue/GRDB.swift
- DI with Swinjcet https://github.com/Swinject/Swinject

## Screenshots
<br />_Main View_ <br />
<img src = "https://github.com/VitaliusSch/SwiftUi-MVVM-Cafe-Manager-WithCatApi/blob/main/Screenshots/IMG_0004.PNG" width="243" height="466" />
<img src = "https://github.com/VitaliusSch/SwiftUi-MVVM-Cafe-Manager-WithCatApi/blob/main/Screenshots/IMG_0005.PNG" width="243" height="466" />

<br />_CafeList View_ <br />
<img src = "https://github.com/VitaliusSch/SwiftUi-MVVM-Cafe-Manager-WithCatApi/blob/main/Screenshots/IMG_0009.PNG" width="243" height="466" />
<img src = "https://github.com/VitaliusSch/SwiftUi-MVVM-Cafe-Manager-WithCatApi/blob/main/Screenshots/IMG_0006.PNG" width="243" height="466" />

<br />_CafeDetails View_ <br />
<img src = "https://github.com/VitaliusSch/SwiftUi-MVVM-Cafe-Manager-WithCatApi/blob/main/Screenshots/IMG_0007.PNG" width="243" height="466" />
<img src = "https://github.com/VitaliusSch/SwiftUi-MVVM-Cafe-Manager-WithCatApi/blob/main/Screenshots/IMG_0014.PNG" width="243" height="466" />

<br />_FetchingList View_ <br />
<img src = "https://github.com/VitaliusSch/SwiftUi-MVVM-Cafe-Manager-WithCatApi/blob/main/Screenshots/IMG_0010.PNG" width="243" height="466" />
<img src = "https://github.com/VitaliusSch/SwiftUi-MVVM-Cafe-Manager-WithCatApi/blob/main/Screenshots/IMG_0011.PNG" width="243" height="466" />
<img src = "https://github.com/VitaliusSch/SwiftUi-MVVM-Cafe-Manager-WithCatApi/blob/main/Screenshots/IMG_0012.PNG" width="243" height="466" />

## Asynchronous navigation
<br />You need to wrap the module's main page in a CustomControllerRepresentable and add a new CustomNavigationController to it<br />
```Swift
@main
struct CatCafeManagerApp: App {
    private var navigation: CustomNavigationController
    init() {
        // Init App, setUp DI
        AppFactory.shared.setUp(customContainer: nil)
        // Main navigation controller. You can add another navigation: just resolve CustomNavigationController with another name!
        navigation = AppFactory.shared.resolve(CustomNavigationController.self, name: NavigationType.main.rawValue)
    }
    
    var body: some Scene {
        WindowGroup {
            CustomControllerRepresentable(
                nav: navigation,
                rootView: MainView()
            )
        }
    }
}
```
<br />Next, you can use asynchronous navigation in the view model as follows<br />
```Swift
@MainActor func adoptCat() async {
	var selectedCat = CatModel.aNewCat
	await navigation.pushViewAsync(
		view: CatAdoptView(
			onCatSelect: { cat in
				selectedCat = cat
				self.navigation.popViewAsync()
			}
		),
		animated: true
	)
	if selectedCat.isEmpty {
		return
	}
}
```

## API KEY
To use this application please enter you API KEY in *AppConstants file* in the field marked: *"AccessKey"* <br />
The API will return a list of cats in random order unless you enter an API KEY.
Just register and get a free API-KEY https://thecatapi.com/

## Suggestions
* The code involved in the above example is in this repository code. It is recommended to download and run the view.
* If you have better usage and suggestions about SwiftUI, look forward to sharing it!
* If there are omissions and errors in the examples in this article,  please create a [**Issue**](https://github.com/VitaliusSch/SwiftUi-MVVM-Cafe-Manager-WithCatApi/issues/new) !
* The example API is the cat API. https://thecatapi.com/

## Requirements

- Xcode 14.0
- iOS 15.2
 
## License	

SwiftUI is released under the [MIT license](LICENSE). See LICENSE for details.

## Links

https://github.com/groue/GRDB.swift   
https://github.com/Swinject/Swinject
https://matteomanferdini.com/swiftui
