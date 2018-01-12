# Swiftly Attributed Strings
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) 

"Swiftly Attributed Strings" uses most of the Swift syntactic sugar to provide an easier way to instantiate NSAttributedStrings.

## Example

```swift
import SwiftlyAttributedStrings
// ...
@IBOutlet weak var label: UILabel!
// ...
label.attributedText = BNUnderline() { BNColor(.blue) { "Hello, " + BNFont(.boldSystemFont(ofSize: 18)) { "World" } + "!" } }.attributedString()
```

<img src="/1.jpg?raw=true" width="132">

## How to create your own string attributes
All you need to do is subclass ```BNNode``` and create one ```init()``` that takes an array of  ```BNStringNode``` and another one that takes a closure ```() -> BNStringNode```. These initializers will have to set the ```params``` dictionary accordingly (access [Character Attributes](https://developer.apple.com/reference/foundation/nsattributedstring/character_attributes) for more information).

### Example

```swift
import UIKit
import SwiftlyAttributedStrings

class Kern: BNNode {
    
    init(_ kern: Float = 0, nodes: [BNStringNode]) {
        var params: [String: Any] = [:]
        if kern >= 0 { params[NSKernAttributeName] = kern }
        super.init(params: params, nodes: nodes)
    }
    
    convenience init(_ kern: Float = 0, closure: () -> BNStringNode) {
        self.init(kern, nodes: [closure()])
    }
}
```

```swift
label.attributedText = Kern(5) { BNColor(.green) { "Hello, " } + BNColor(.blue) { "World!" } }.attributedString()
```

<img src="/2.jpg?raw=true" width="182">

## How to install

### CocoaPods

Add this line to your `Podfile`:

```
pod 'SwiftlyAttributedStrings', :git => 'https://github.com/fabio914/swiftly-attributed-strings.git', :tag => '0.0.1'
``` 

### Carthage

Add this line to your `Cartfile`:

```
github "fabio914/swiftly-attributed-strings" ~> 0.0
```

## Requirements
Swift 3.1, iOS 9.3+

## License
```Swiftly Attributed Strings``` is released under the ```MIT``` license.


