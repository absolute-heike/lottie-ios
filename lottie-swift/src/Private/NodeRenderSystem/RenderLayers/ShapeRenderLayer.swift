//
//  RenderLayer.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/18/19.
//

import Foundation
import QuartzCore

/**
 The layer responsible for rendering shape objects
 */
final class ShapeRenderLayer: ShapeContainerLayer {
  
  fileprivate(set) var renderer: Renderable & NodeOutput
  
  let shapeLayer: CAShapeLayer = CAShapeLayer()
  
  init(renderer: Renderable & NodeOutput) {
    self.renderer = renderer
    super.init()
    self.anchorPoint = .zero
    self.actions = [
      "position" : NSNull(),
      "bounds" : NSNull(),
      "anchorPoint" : NSNull(),
      "path" : NSNull(),
      "transform" : NSNull(),
      "opacity" : NSNull(),
      "hidden" : NSNull(),
    ]
    shapeLayer.actions = [
      "position" : NSNull(),
      "bounds" : NSNull(),
      "anchorPoint" : NSNull(),
      "path" : NSNull(),
      "fillColor" : NSNull(),
      "strokeColor" : NSNull(),
      "lineWidth" : NSNull(),
      "miterLimit" : NSNull(),
      "lineDashPhase" : NSNull(),
      "hidden" : NSNull(),
    ]
    addSublayer(shapeLayer)
  }
  
  override init(layer: Any) {
    guard let layer = layer as? ShapeRenderLayer else {
      fatalError("init(layer:) wrong class.")
    }
    self.renderer = layer.renderer
    super.init(layer: layer)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func hasRenderUpdate(forFrame: CGFloat) -> Bool {
    self.isHidden = !renderer.isEnabled
    guard self.isHidden == false else { return false }
    return renderer.hasRenderUpdates(forFrame)
  }
  
  override func rebuildContents(forFrame: CGFloat) {
    shapeLayer.path = renderer.outputPath
    renderer.updateShapeLayer(layer: shapeLayer)
  }
}
