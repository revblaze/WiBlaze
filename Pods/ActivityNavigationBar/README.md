# ActivityNavigationBar

[![CI Status](http://img.shields.io/travis/superpeteblaze/ActivityNavigationBar.svg?style=flat)](https://travis-ci.org/superpeteblaze/ActivityNavigationBar)
[![Version](https://img.shields.io/cocoapods/v/ActivityNavigationBar.svg?style=flat)](http://cocoapods.org/pods/ActivityNavigationBar)
[![License](https://img.shields.io/cocoapods/l/ActivityNavigationBar.svg?style=flat)](http://cocoapods.org/pods/ActivityNavigationBar)
[![Platform](https://img.shields.io/cocoapods/p/ActivityNavigationBar.svg?style=flat)](http://cocoapods.org/pods/ActivityNavigationBar)

## Description
Activity navigation bar provides a custom navigation bar with a build in
activity indicator. The activity indicator is styled like a progress bar,
but is intended to be used to indicate indeterminate activity time.

To achieve this, the activity is started with a 'waitAt' parameter.
The activity bar will then animate progress to this point, and stop.
Then, once our indeterminate activity has finished, we finish the
activity indicator.

## Installation

ActivityNavigationBar is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ActivityNavigationBar"
```

## Usage

* Set the class type of your navigation bar from UINavigationBar to ActivityNavigationBar in your storyboard scene or Xib
* In the view controller class corresponding to your storyboard scene, create an optional var which will allow you to reference the ActivityNavigationBar;

```
var activityNavigationBar: ActivityNavigationBar? {
  return navigationController?.navigationBar as? ActivityNavigationBar
}
```

* Now, use the ActivityNavigationBar as follows. 

Start it;

```
activityNavigationBar?.startActivity(andWaitAt: 0.8)
```

Finish it;

```
activityNavigationBar?.finishActivity(withDuration: duration)
```

Reset it;

```
activityNavigationBar?.reset()
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

![Sample app screenshot](https://raw.githubusercontent.com/superpeteblaze/ActivityNavigationBar/master/Assets/Screenshot.png)

## Author

Pete Smith, peadar81@gmail.com

## License

ActivityNavigationBar is available under the MIT license. See the LICENSE file for more info.
