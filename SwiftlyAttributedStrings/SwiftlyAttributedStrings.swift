//
//  SwiftlyAttributedStrings.swift
//  SwiftlyStrings
//
//  Created by Fabio Dela Antonio on 2017-04-22.
//  Copyright © 2017 bluenose. All rights reserved.
//

import UIKit

public protocol BNStringNode {
}

extension String: BNStringNode {
}

open class BNNode: BNStringNode {
    
    public var params: [String: Any]
    public var nodes: [BNStringNode]
    
    public init(params: [String: Any], nodes: [BNStringNode]) {
        self.nodes = nodes
        self.params = params
    }
    
    public convenience init(params: [String: Any], closure: () -> BNStringNode) {
        self.init(params: params, nodes: [closure()])
    }
}

public func +(lhs: BNStringNode, rhs: BNStringNode) -> BNNode {
    return BNNode(params: [:], nodes: [lhs, rhs])
}

fileprivate class BNStack<T> {
    
    private var array: Array<T> = []
    
    func push(_ element: T) {
        array.append(element)
    }
    
    func pop() -> T? {
        
        if array.last != nil {
            return array.removeLast()
        }
        return nil
    }
    
    func top() -> T? {
        return array.last
    }
}

public enum BNAttributedStringBuilderError: Error {
    case InvalidNodeInstance
}

public class BNAttributedStringBuilder {
    
    private var contextStack: BNStack<[String: Any]> = BNStack()
    private var rootNode: BNStringNode
    
    init(rootNode: BNStringNode) {
        self.rootNode = rootNode
    }
    
    public class func build(_ rootNode: BNStringNode) throws -> NSAttributedString {
        return try BNAttributedStringBuilder(rootNode: rootNode).attributedString()
    }
    
    private func attributedString() throws -> NSAttributedString {
        contextStack = BNStack()
        contextStack.push([:])
        let result = try attributedString(forNode: rootNode)
        _ = contextStack.pop()
        return result
    }
    
    private func attributedString(forNode node: BNStringNode) throws -> NSAttributedString {
        
        if let string = node as? String {
            
            return NSAttributedString(string: string, attributes: contextStack.top())
        }
            
        else if let node = node as? BNNode {
            
            let localAttributed = NSMutableAttributedString()
            let currentAttributes = contextStack.top() ?? [:]
            
            contextStack.push(mergeAttributes(currentAttributes, node.params))
            
            for node in node.nodes {
                
                localAttributed.append(try attributedString(forNode: node))
            }
            
            _ = contextStack.pop()
            
            return NSAttributedString(attributedString: localAttributed)
        }
            
        else {
            
            throw BNAttributedStringBuilderError.InvalidNodeInstance
        }
    }
    
    private func mergeAttributes(_ first: [String: Any], _ second: [String: Any]) -> [String: Any] {
        
        var merge = first
        
        for key in second.keys {
            merge[key] = second[key]
        }
        
        return merge
    }
}

public extension BNStringNode {
    
    public func attributedString() -> NSAttributedString? {
        return try? BNAttributedStringBuilder.build(self)
    }
}

//
// String Attribute Classes
//

public class BNFont: BNNode {
    
    public init(_ font: UIFont?, nodes: [BNStringNode]) {
        var params: [String: Any] = [:]
        if let font = font { params[NSFontAttributeName] = font }
        super.init(params: params, nodes: nodes)
    }
    
    public convenience init(_ font: UIFont?, closure: () -> BNStringNode) {
        self.init(font, nodes: [closure()])
    }
}

public class BNColor: BNNode {
    
    public init(_ color: UIColor, nodes: [BNStringNode]) {
        super.init(params: [NSForegroundColorAttributeName: color], nodes: nodes)
    }
    
    public convenience init(_ color: UIColor, closure: () -> BNStringNode) {
        self.init(color, nodes: [closure()])
    }
}

public class BNUnderline: BNNode {
    
    public init(_ style: NSUnderlineStyle = .styleSingle, nodes: [BNStringNode]) {
        super.init(params: [NSUnderlineStyleAttributeName: style.rawValue], nodes: nodes)
    }
    
    public convenience init(_ style: NSUnderlineStyle = .styleSingle, closure: () -> BNStringNode) {
        self.init(style, nodes: [closure()])
    }
}
