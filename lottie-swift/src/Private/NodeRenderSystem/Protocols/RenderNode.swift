//
//  RenderNode.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/17/19.
//

import Foundation
import CoreGraphics
import QuartzCore

/// A protocol that defines a node that holds render instructions
protocol RenderNode {
  var renderer: Renderable & NodeOutput { get }
}

/// A protocol that defines anything with render instructions
protocol Renderable {
  
  /// The last frame in which this node was updated.
  var hasUpdate: Bool { get }
  
  func hasRenderUpdates(_ forFrame: CGFloat) -> Bool
  
  /// Passes in the CAShapeLayer to update
  func updateShapeLayer(layer: CAShapeLayer)
}

extension RenderNode where Self: AnimatorNode {
  
  var outputNode: NodeOutput {
    return renderer
  }
  
}
