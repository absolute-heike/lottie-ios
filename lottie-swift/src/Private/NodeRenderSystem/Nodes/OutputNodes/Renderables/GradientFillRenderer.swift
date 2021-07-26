//
//  GradientFillRenderer.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/30/19.
//

import Foundation
import QuartzCore

private final class GradientFillLayer: CALayer {

  override func draw(in ctx: CGContext) {
    super.draw(in: ctx)

    var alphaColors = [CGColor]()
    var alphaLocations = [CGFloat]()

    var gradientColors = [CGColor]()
    var colorLocations = [CGFloat]()
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let maskColorSpace = CGColorSpaceCreateDeviceGray()
    for i in 0..<numberOfColors {
      let ix = i * 4
        if colors.count > ix, let color = CGColor(colorSpace: colorSpace, components: [colors[ix + 1], colors[ix + 2], colors[ix + 3], 1]) {
        gradientColors.append(color)
        colorLocations.append(colors[ix])
      }
    }

    var drawMask = false
    for i in stride(from: (numberOfColors * 4), to: colors.endIndex, by: 2) {
      let alpha = colors[i + 1]
      if alpha < 1 {
        drawMask = true
      }
      if let color = CGColor(colorSpace: maskColorSpace, components: [alpha, 1]) {
        alphaLocations.append(colors[i])
        alphaColors.append(color)
      }
    }

    ctx.setAlpha(CGFloat(opacity))
    ctx.clip()

    /// First draw a mask is necessary.
    if drawMask {
      guard let maskGradient = CGGradient(colorsSpace: maskColorSpace,
                                          colors: alphaColors as CFArray,
                                          locations: alphaLocations),
        let maskContext = CGContext(data: nil,
                                    width: ctx.width,
                                    height: ctx .height,
                                    bitsPerComponent: 8,
                                    bytesPerRow: ctx.width,
                                    space: maskColorSpace,
                                    bitmapInfo: 0) else { return }
      let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: CGFloat(maskContext.height))
      maskContext.concatenate(flipVertical)
      maskContext.concatenate(ctx.ctm)
      if type == .linear {
        maskContext.drawLinearGradient(maskGradient, start: start, end: end, options: [.drawsAfterEndLocation, .drawsBeforeStartLocation])
      } else {
        maskContext.drawRadialGradient(maskGradient, startCenter: start, startRadius: 0, endCenter: start, endRadius: start.distanceTo(end), options: [.drawsAfterEndLocation, .drawsBeforeStartLocation])
      }
      /// Clips the gradient
      if let alphaMask = maskContext.makeImage() {
        ctx.clip(to: ctx.boundingBoxOfClipPath, mask: alphaMask)
      }
    }

    /// Now draw the gradient
    guard let gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors as CFArray, locations: colorLocations) else { return }
    if type == .linear {
      ctx.drawLinearGradient(gradient, start: start, end: end, options: [.drawsAfterEndLocation, .drawsBeforeStartLocation])
    } else {
      ctx.drawRadialGradient(gradient, startCenter: start, startRadius: 0, endCenter: start, endRadius: start.distanceTo(end), options: [.drawsAfterEndLocation, .drawsBeforeStartLocation])
    }
  }

  var start: CGPoint = .zero {
    didSet {
      setNeedsDisplay()
    }
  }

  var numberOfColors: Int = 0 {
    didSet {
      setNeedsDisplay()
    }
  }

  var colors: [CGFloat] = [] {
    didSet {
      setNeedsDisplay()
    }
  }

  var end: CGPoint = .zero {
    didSet {
      setNeedsDisplay()
    }
  }

  var type: GradientType = .none {
    didSet {
      setNeedsDisplay()
    }
  }
}

/// A rendered for a Path Fill
final class GradientFillRenderer: PassThroughOutputNode, Renderable {

  private let gradientLayer: GradientFillLayer = GradientFillLayer()
  private let maskLayer: CAShapeLayer = CAShapeLayer()

  override init(parent: NodeOutput?) {
    super.init(parent: parent)

    maskLayer.fillColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1, 1, 1, 1])
    gradientLayer.mask = maskLayer
  }

  func updateShapeLayer(layer: CAShapeLayer) {
    hasUpdate = false

    guard let path = outputPath else {
      return
    }

    if gradientLayer.superlayer != layer {
      layer.addSublayer(gradientLayer)
    }
    maskLayer.path = path
    gradientLayer.bounds = path.boundingBox
    maskLayer.bounds = gradientLayer.bounds
    
    gradientLayer.start = start
    gradientLayer.numberOfColors = numberOfColors
    gradientLayer.colors = colors
    gradientLayer.end = end
    gradientLayer.opacity = Float(opacity)
    gradientLayer.type = type
  }
  
  var start: CGPoint = .zero {
    didSet {
      hasUpdate = true
    }
  }
  
  var numberOfColors: Int = 0 {
    didSet {
      hasUpdate = true
    }
  }
  
  var colors: [CGFloat] = [] {
    didSet {
      hasUpdate = true
    }
  }
  
  var end: CGPoint = .zero {
    didSet {
      hasUpdate = true
    }
  }
  
  var opacity: CGFloat = 0 {
    didSet {
      hasUpdate = true
    }
  }
  
  var type: GradientType = .none {
    didSet {
      hasUpdate = true
    }
  }
  
}
