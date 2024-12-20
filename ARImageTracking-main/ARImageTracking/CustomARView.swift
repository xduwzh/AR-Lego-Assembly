//
//  CustomARView.swift
//  ARImageTracking
//
//  Created by 吴征航 on 2024/12/4.
//

import Foundation
import ARKit
import RealityKit
import SwiftUI
import simd

func extractPosition(from matrix: simd_float4x4) -> SIMD3<Float> {
    // 提取位置，返回最后一列的前三个元素
    return SIMD3<Float>(matrix.columns.3.x, matrix.columns.3.y, matrix.columns.3.z)
}

var original = SIMD3<Float>(0,0,0)  //左上角
//var zUnit = SIMD3<Float>(0,0,-0.89333)  // 左右，向右
var zUnit = SIMD3<Float>(0,0,-0.6)  // 左右，向右


//var xUnit = SIMD3<Float>(0.68667,0,0)  // 上下，向下
var xUnit = SIMD3<Float>(0.5,0,0)  // 上下，向下

var caliAnchorPos = SIMD3<Float>(0,0,0)
var caliAnchorPoses:[SIMD3<Float>] = []

var vRotationAngle: Float = hRotationAngle + (90 * (.pi / 180))
var hRotationAngle: Float = 103 * (.pi / 180)

var referenceAnchor = AnchorEntity()
var showAnchor = AnchorEntity()
var caliAnchor = AnchorEntity()

var vRotation = simd_quatf(angle: vRotationAngle, axis: SIMD3<Float>(0, 1, 0))
var hRotation = simd_quatf(angle: hRotationAngle, axis: SIMD3<Float>(0, 1, 0))


class CustomARView: ARView, ARSessionDelegate, ObservableObject, Observable{
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        
        for anchor in anchors{

            if let imageAnchor = anchor as? ARImageAnchor{
                referenceAnchor = AnchorEntity(anchor: imageAnchor)
                caliAnchorPos = extractPosition(from: imageAnchor.transform)
                self.scene.addAnchor(referenceAnchor)
                self.scene.addAnchor(showAnchor)
                self.scene.addAnchor(caliAnchor)
                
                
            }
        }
    }
    
    func session(_ session: ARSession, didAdd anchor: ARAnchor) {
        
    }
}
