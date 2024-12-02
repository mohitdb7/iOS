//
//  TransformExtension.swift
//  photosAppExample
//
//  Created by Mohit Dubey on 08/08/24.
//

import UIKit

extension CGRect {
    func aspectFit(to frame: CGRect) -> CGRect {
        let ratio = width / height
        let frameRatio = frame.width / frame.height
        if frameRatio < ratio {
            return aspectFitWidth(to: frame)
        } else {
            return aspectFitHeight(to: frame)
        }
    }

    func aspectFitWidth(to frame: CGRect) -> CGRect {
        let ratio = width / height
        let height = frame.width * ratio
        let offsetY = (frame.height - height) / 2
        let origin = CGPoint(x: frame.origin.x, y: frame.origin.y + offsetY)
        let size = CGSize(width: frame.width, height: height)
        return CGRect(origin: origin, size: size)
    }

    func aspectFitHeight(to frame: CGRect) -> CGRect {
        let ratio = height / width
        let width = frame.height * ratio
        let offsetX = (frame.width - width) / 2
        let origin = CGPoint(x: frame.origin.x + offsetX, y: frame.origin.y)
        let size = CGSize(width: width, height: frame.height)
        return CGRect(origin: origin, size: size)
    }
}

extension CGAffineTransform {
    static func transform(from frameA: CGRect, to frameB: CGRect) -> Self {
        let scale = scale(from: frameA, to: frameB)
        let translation = translate(from: frameA, to: frameB)
        return scale.concatenating(translation)
    }

    static func translate(from frameA: CGRect, to frameB: CGRect) -> Self {
        let centerA = CGPoint(x: frameA.midX, y: frameA.midY)
        let centerB = CGPoint(x: frameB.midX, y: frameB.midY)
        return CGAffineTransform(
            translationX: centerB.x - centerA.x,
            y: centerB.y - centerA.y
        )
    }

    static func scale(from frameA: CGRect, to frameB: CGRect) -> Self {
        let scaleX = frameB.width / frameA.width
        let scaleY = frameB.height / frameA.height
        return CGAffineTransform(scaleX: scaleX, y: scaleY)
    }

    static func transform(parent: CGRect, soChild child: CGRect, matches rect: CGRect) -> Self {
        let scaleX = rect.width / child.width
        let scaleY = rect.height / child.height

        let offsetX = rect.midX - parent.midX
        let offsetY = rect.midY - parent.midY
        let centerOffsetX = (parent.midX - child.midX) * scaleX
        let centerOffsetY = (parent.midY - child.midY) * scaleY

        let translateX = offsetX + centerOffsetX
        let translateY = offsetY + centerOffsetY

        let scaleTransform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        let translateTransform = CGAffineTransform(translationX: translateX, y: translateY)

        return scaleTransform.concatenating(translateTransform)
    }

    static func transform(parent: CGRect, soChild child: CGRect, aspectFills rect: CGRect) -> Self {
        let childRatio = child.width / child.height
        let rectRatio = rect.width / rect.height

        let scaleX = rect.width / child.width
        let scaleY = rect.height / child.height

        let scaleFactor = rectRatio < childRatio ? scaleY : scaleX

        let offsetX = rect.midX - parent.midX
        let offsetY = rect.midY - parent.midY
        let centerOffsetX = (parent.midX - child.midX) * scaleFactor
        let centerOffsetY = (parent.midY - child.midY) * scaleFactor

        let translateX = offsetX + centerOffsetX
        let translateY = offsetY + centerOffsetY

        let scaleTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let translateTransform = CGAffineTransform(translationX: translateX, y: translateY)

        return scaleTransform.concatenating(translateTransform)
    }
}
