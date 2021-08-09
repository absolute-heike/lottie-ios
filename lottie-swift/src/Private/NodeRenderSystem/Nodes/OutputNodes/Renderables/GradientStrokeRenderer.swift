//
//  GradientStrokeRenderer.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/30/19.
//

import Foundation
import QuartzCore

// MARK: - Renderer

final class GradientStrokeRenderer: PassThroughOutputNode, Renderable {
  func setupSublayers(layer: CAShapeLayer) {
    // TODO: Implement Strike rendering
  }

  override func hasOutputUpdates(_ forFrame: CGFloat) -> Bool {
    let updates = super.hasOutputUpdates(forFrame)
    return updates || strokeRender.hasUpdate || gradientRender.hasUpdate
  }
  
  let strokeRender: StrokeRenderer
  let gradientRender: GradientFillRenderer
  
  override init(parent: NodeOutput?) {
    self.strokeRender  = StrokeRenderer(parent: parent)
    self.gradientRender = GradientFillRenderer(parent: parent)
    self.strokeRender.color = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1, 1, 1, 1])
    super.init(parent: parent)
  }

  func updateShapeLayer(layer: CAShapeLayer) {
//    gradientRender.updateShapeLayer(layer: layer)
    strokeRender.updateShapeLayer(layer: layer)
  }
}
