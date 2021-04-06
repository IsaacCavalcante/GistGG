# GistGG

<a href="https://imgflip.com/gif/54jj70"><img src="https://i.imgflip.com/54jj70.gif" title="made at imgflip.com"/></a>

## Installation

Open your terminal and type in

```sh
$ git clone https://github.com/IsaacCavalcante/GistGG.git
$ cd GistGG
$ pod install
```

## How to use

After download or clone the project:
In order to run on device you need to change the signing team:

After install pods dependencies open GistGG.xcworkspace
Select GistGG.xodeproj in Project Navigator
Select GistGG target in Project and targets list
Select Signing and Capabilities tab and change the team

After finish the above checklist:
1) After open the app will ask by sigin with your github account that allow app to use gist and get profile read-only informations
2) Scan a QRCode like this:
<a href="https://i.imgur.com/xWq1XyM"><img src="https://i.imgur.com/xWq1XyM.png" title="made at imgur.com"/></a>
3) If QRCode was created from a valid URL a gist screen information will open and allow you to comment gist


## Bugs

Alamofire is caching some requests, so sometimes whe you back to Scan screen and advance to Gist Screen the comment doesnt appear, but few seconds later it will appear
