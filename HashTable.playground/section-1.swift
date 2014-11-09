import Foundation

class HashBucket {
    var key: String?
    var value: AnyObject?
    var next: HashBucket?
}

class HashTable {
    
    var size: Int = 0
    var hashArray: [HashBucket]!
    var count: Int = 0
    
    init() {
        self.hashArray = Array(count: 10, repeatedValue: HashBucket())
        self.size = 10
    }
    
    func hash(key: String) -> Int {
        var total = 0
        for character in key.unicodeScalars {
            var asc = Int(character.value)
            total += asc
        }
        return total % self.size
    }
    
    private func checkArraySize() {
        let threshold = Double(self.size) * 0.7
        if self.count >= Int(round(threshold)) {
            let oldArray = self.hashArray
            let newSize = self.size * 2
            self.hashArray = Array(count: newSize, repeatedValue: HashBucket())
            self.size = newSize
            self.count = 0
            
            for bucket in hashArray {
                var currentBucket: HashBucket? = bucket
                while currentBucket != nil && currentBucket?.key != nil {
                    self[currentBucket!.key!] = currentBucket!.value
                    if let nextBucket = currentBucket?.next {
                        currentBucket = nextBucket
                    } else {
                        currentBucket = nil
                    }
                    
                }
            }
        }
    }
    
    subscript(key: String) -> AnyObject? {
        get {
            let index = self.hash(key)
            var currentBucket = self.hashArray[index]
            
            while currentBucket.key != nil {
                if currentBucket.key == key {
                    return currentBucket.value
                } else if let nextBucket = currentBucket.next {
                    currentBucket = nextBucket
                } else {
                    return nil
                }
            }
            // If first bucket empty
            return nil
        }
        
        set(newValue) {
            let index = self.hash(key)
            var currentBucket: HashBucket? = self.hashArray[index]
            
            while currentBucket != nil {
                if currentBucket!.key == nil {
                    currentBucket!.key = key
                    currentBucket!.value
                    ++self.count
                    self.checkArraySize()
                    return
                } else if currentBucket!.key == key {
                    currentBucket!.value = newValue
                    return
                } else if let nextBucket = currentBucket!.next {
                    currentBucket = nextBucket
                } else {
                    let nextBucket = HashBucket()
                    currentBucket!.next = nextBucket
                    nextBucket.key = key
                    nextBucket.value = newValue
                    ++self.count
                    self.checkArraySize()
                    return
                }

            }
        }
    }

}




