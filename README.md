# Eventer
![Swift version](https://img.shields.io/badge/swift-5.0-orange.svg)
![Platforms](https://img.shields.io/badge/platforms-iOS%20-lightgrey.svg)

## Demo

<img src=https://fetch-rewards-challenge-screenshots.s3-us-west-1.amazonaws.com/fetchrewardspictures/5C506015-B689-4EBA-9A69-B8D59319D033.png width="250"><img src=https://fetch-rewards-challenge-screenshots.s3-us-west-1.amazonaws.com/fetchrewardspictures/9AD71B86-CCD8-4AB4-8989-CE7514454293.png width="250">
<img src=https://fetch-rewards-challenge-screenshots.s3-us-west-1.amazonaws.com/fetchrewardspictures/E63B4414-B2BD-403B-8077-113F17C85FCF.png width="250"><img src=https://fetch-rewards-challenge-screenshots.s3-us-west-1.amazonaws.com/fetchrewardspictures/ED848D90-0070-4EA7-A8CE-6091D746374C.png width="250"> 
<img src=https://fetch-rewards-challenge-screenshots.s3-us-west-1.amazonaws.com/fetchrewardspictures/E2FFDFCD-66F6-4A2B-B53E-4316EBCF53F1.png width="250"> 

## Getting Started

```bash
$ git clone https://github.com/stantraub/Eventer.git
$ cd Eventer
$ pod install
$ open Eventer.xcworkspace/
```

## Technologies Used

1. UIKit (Programmatic)
2. Alamofire
3. SwiftyJSON
4. SDWebImage
5. RealmSwift
6. JGProgressHud

## Features

- [x] Events fetched from the SeatGeek API and displayed on the Events search page 
  - Event images are cached with SDWebImage to ensure quick image loading
- [x] Dark mode (iOS 13+) support! 
- [x] iOS 12+ supported
- [x] Events can be liked/unliked from both the event search and detail screens
  - Favorited events are persisted into memory with Realm
- [x] Events can be searched by title on the event search page
- [x] Progress indicator during the duration of the API call to fetch event information

## Architecure 

The app was built with an MVVM architecture.

* Alamofire for the network layer.

* Realm for the storage layer.

## Author

Stanley Traub - Contact me at <stanley.traub@gmail.com>  



