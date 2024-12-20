//
//  ContentView.swift
//  ARImageTracking
//
//  Created by Zhenghang Wu on 8/1/21.
//

import ARKit
import RealityKit
import SwiftUI


extension simd_float4x4 {
    static func translation(_ position: SIMD3<Float>) -> simd_float4x4 {
        var matrix = matrix_identity_float4x4
        matrix.columns.3.x = position.x
        matrix.columns.3.y = position.y
        matrix.columns.3.z = position.z
        return matrix
    }
}


// Displays as a SwiftUI View
struct ContentView: View {
    @ObservedObject var sceneManager: SceneManager
    @EnvironmentObject var arView: CustomARView // 引入 ARView 环境对象
    
    let cropRect = CGRect(x: 90, y: 660, width: 1010, height: 1010)
    let uiRect = CGRect(x: 45, y: 310, width: 500, height: 500)
    
    @State private var periodicTask: PeriodicTask?
    
    var body: some View {
        ZStack {
            ARViewContainer()
                .edgesIgnoringSafeArea(.all)
            
            Rectangle()
                .stroke(Color.red, lineWidth: 3) // 红色边框
                .frame(width: uiRect.width, height: uiRect.height) // 设置宽度和高度
                .position(x: uiRect.midX, y: uiRect.midY) // 设置框的中心点位置
            
            VStack {
                Spacer()
                HStack{
                    Button(action: {
                        updateAnchorPos(arView: arView, Dir: xUnit)
                    }) {
                        Text("down")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    Button(action: {
                        updateAnchorPos(arView: arView, Dir: -xUnit)
                    }) {
                        Text("up")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    Button(action: {
                        updateAnchorPos(arView: arView, Dir: zUnit)
                    }) {
                        Text("right")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    Button(action: {
                        updateAnchorPos(arView: arView, Dir: -zUnit)
                    }) {
                        Text("left")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()

                    Button(action: {
                        recordAnchorPos(arView: arView)
                    }) {
                        Text("recordAnchor")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                }
                HStack{
                    
                    Button(action: {
                        if periodicTask == nil {
                            periodicTask = PeriodicTask(arView: arView, cropRect: cropRect)
                        }
                        periodicTask?.startTimer()
                    }) {
                        Text("Start")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    // 停止定时任务
                    Button(action: {
                        periodicTask?.stopTimer()
                        periodicTask = nil // 释放实例
                    }) {
                        Text("Stop")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    Button(action: {
                        currentStep += 1
                    }) {
                        Text("Skip")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    Button(action: {
                        currentStep -= 1
                    }) {
                        Text("Rewind")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
//                    Button(action: {
//                        testColor1(arView: arView, cropRect: cropRect)
//                    }) {
//                        Text("testColor")
//                            .padding()
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    .padding()
                    
                    Button(action: {
                        captureAndCrop(arView: arView, cropRect: cropRect)
                    }) {
                        Text("Capture")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    
//                    Button(action: {
//                        xUnit -= SIMD3<Float>(0.04,0,0)
//                    }) {
//                        Text("-x")
//                            .padding()
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    .padding()
//                    Button(action: {
//                        zUnit -= SIMD3<Float>(0,0,-0.05)
//                    }) {
//                        Text("-z")
//                            .padding()
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    .padding()
                }
                
            }
        }
    }
    
    private func takeScreenshot() {
        arView.snapshot(saveToHDR: false) { image in
            guard let image = image else {
                print("Failed to capture image")
                return
            }
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            print("Screenshot saved to photo library")
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var arView: CustomARView
    
    func makeUIView(context: Context) -> CustomARView {
        guard let referenceImages = ARReferenceImage.referenceImages(
            inGroupNamed: "AR Resources", bundle: nil)
        else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        // Assigns coordinator to delegate the AR View
        arView.session.delegate = arView
        
        let configuration = ARImageTrackingConfiguration()
        configuration.isAutoFocusEnabled = true
        configuration.trackingImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 1
        loadImages()
        // Enables People Occulusion on supported iOS Devices
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            configuration.frameSemantics.insert(.personSegmentationWithDepth)
        } else {
            print("People Segmentation not enabled.")
        }
        
        arView.session.run(configuration)
        return arView
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {}
    
    
}
