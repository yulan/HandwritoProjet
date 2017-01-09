# HandwritoProjet
A mini project iOS Swift 2 manipulating the Handwriting.io API

## Content
- [Features](#features)
- [Achitecture](#achitecture)
- [Project Structure](#project-structure)
- [Dependencies](#dependencies)
- [TODOS](#todos)


## Features
- Choose from Popular Font
- Validation of user's input
- Handwrited text render as a PNG Image
- Loader while processing
- Error handling  
- CocoaPods to manage dependencies

## Achitecture
This app uses the [Handwriting.io API](https://handwriting.io/) to render user's input text as a handwrited text as a PNG Image.

## Project Structure
This app is based on a MVC pattern. The project app folder is organized as follow:
```
- /
|- Application
|- HWConstant.swift (contains all constants used in the app)
|- API (all managers handle API calls)
|- Controllers (all controllers used by the App)
|- Utils (extensions, helpers, etc.)
|- Models (all models representing the data)
|- Resources
|- Assets.xcassets (contains all images, icons)
|- Languages (contains all localized files)
|- Views (contains all storyboards)
```

## Dependencies
Dependencies are managed by CocoaPods. This project uses the following:
- [Alamofire](https://github.com/Alamofire/Alamofire) HTTP Networking, GET and POST operations
- [SwiftValidator](https://github.com/jpotts18/SwiftValidator) to validate user's inputs

## TODOS
- [ ] Localize
- [ ] Choose font size
- [ ] Choose font color
- [ ] App Icon
- [ ] Launch Screen
- [ ] Select render between PNG image or PDF
- [ ] Support Orientation

---
*Please provide attribution, it is greatly appreciated.*