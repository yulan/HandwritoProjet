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
- Handwrited text render as a PNG Image
- Loader while processing
- Error handling  
- CocoaPods to manage dependencies

## Achitecture
This app uses the [Handwriting.io API](https://handwriting.io/) to render user's input text with a font chosen as a handwrited text as a PNG Image.

## Project Structure
This app is based on a MVC pattern. The project app folder is organized as follow:
```
- /
|- Application
|- API (all managers API calls)
|- Controllers (all controllers used by the App)
|- Models (all models representing the data)
|- Views (all views like UITableViewCell...)
|- Resources
|- Assets.xcassets (contains all images, icons)
```

## Dependencies
Dependencies are managed by CocoaPods. This project uses the following:
- [Alamofire](https://github.com/Alamofire/Alamofire) HTTP Networking, GET and POST operations
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) easy to deal with JSON data in Swift.

## TODOS
- [ ] Localize
- [ ] Choose font size
- [ ] Choose font color
- [ ] Validator input text
- [ ] Save or delete png image local
- [ ] App Icon
- [ ] Launch Screen
- [ ] Select render between PNG image or PDF
- [ ] Support Orientation

---