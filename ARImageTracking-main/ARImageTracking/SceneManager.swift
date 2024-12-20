//
//  SceneManager.swift
//  ARImageTracking
//
//  Created by 吴征航 on 2024/12/11.
//

import Foundation
import ARKit
import RealityKit

class SceneManager: ObservableObject{
    let arView: CustomARView
    init(arView: CustomARView) {
        self.arView = arView
    }
}

