# 🦸🏻‍♂️ Marvelous Squad

<div align=center><img src="demo.gif" height="30%" width="30%"></div>

## 📖 Description

📱 Marvel squad iOS app using Swift and [Marvel API](https://developer.marvel.com/). App mainly done to explore and learn about using UIKit coupled to Combine and Core Data.

Superheroes are retrieved from the API while squads are only on the Core Data side.

## 🛠 Setup

To get it work you should add a file named `Constants.swift` in the `Packages/Backend/Sources/Backend/` package as bellow.

```swift
public struct Constants {
    public static let publicApiKey = "<YOUR_MARVEL_PUBLIC_API_KEY>"
    public static let privateApiKey = "<YOUR_MARVEL_PRIVATE_API_KEY>"
}
```

## 📦 Dependencies

I've tried to use as few external libraries as possible to learn about concepts.

- [Nuke](https://github.com/kean/Nuke): Image loading system

Packages that are in the `Packages` folder are local packages. It improves modularity, maintenance etc... as explained [here](https://developer.apple.com/documentation/swift_packages/organizing_your_code_with_local_packages).

## 👨🏻‍💻 Developer

- Quentin Eude
  - [Github](https://github.com/qeude)
  - [LinkedIn](https://www.linkedin.com/in/quentineude/)
