# LocalStorage
Save and load client-side local value in archived file.

# Example
```
// Create a singleton with file name, which is a key for LocalStorage.
class SharedPreference {
    static let `default` = { return LocalStorage(fileName: "preference.db", directoryType: .libraryDirectory) }()
    private init() {}
}

// Save your value or object
SharedPreference.default.save("TEST_STRING", forKey: "MY_STRING_KEY")
SharedPreference.default.save(["TEST_KEY": "TEST_VALUE"], forKey: "MY_DICTIONARY_KEY")
SharedPreference.default.save([100, 10, 1], forKey: "MY_ARRAY_KEY")
        
// Load saved value or object
print("\(SharedPreference.default.load("MY_STRING_KEY").debugDescription)")
print("\(SharedPreference.default.load("MY_DICTIONARY_KEY").debugDescription)")
print("\(SharedPreference.default.load("MY_ARRAY_KEY").debugDescription)")

```

# Installation

VersionCompare is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LocalStorage"
```

# Unlicense
Do whatever you want with this code.
