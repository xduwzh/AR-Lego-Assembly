//
//  ImageProcess.swift
//  ARImageTracking
//
//  Created by 吴征航 on 2024/12/11.
//
import Foundation
import UIKit
import ARKit
import RealityKit


var currentStep = 1
var testPixels: [[(UInt8, UInt8, UInt8)]] = []

func calculateCropRect(arViewFrame: CGRect, cropSize: CGSize) -> CGRect {
    let cropOrigin = CGPoint(
        x: (arViewFrame.width - cropSize.width) / 2,
        y: (arViewFrame.height - cropSize.height) / 2
    )
    return CGRect(origin: cropOrigin, size: cropSize)
}

func captureAndCrop(arView: CustomARView, cropRect: CGRect) {
    // 捕获截图
    for anchor in arView.scene.anchors{
        anchor.isEnabled = false
    }
    arView.snapshot(saveToHDR: false) { image in
        guard let image = image else {
            print("Failed to capture image")
            return
        }
        
        // 裁切图片
        guard let croppedImage = cropImage(image: image, cropRect: cropRect) else {
            print("Failed to crop image")
            return
        }
        
        // 保存裁切后的图片到相册
        UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil)
        print("Cropped screenshot saved to photo library")
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        for anchor in arView.scene.anchors {
            anchor.isEnabled = true
        }
    }

}

func cropImage(image: UIImage, cropRect: CGRect) -> UIImage? {
    // 确保有有效的 CGImage
    guard let cgImage = image.cgImage else { return nil }
    
    // 按比例缩放裁切区域到图片的实际像素大小
    let scale = image.scale
    let scaledCropRect = CGRect(
        x: cropRect.origin.x * scale,
        y: cropRect.origin.y * scale,
        width: cropRect.size.width * scale,
        height: cropRect.size.height * scale
    )
    
    // 裁切 CGImage
    guard let croppedCGImage = cgImage.cropping(to: scaledCropRect) else { return nil }
    
    // 转换为 UIImage 并返回
    return UIImage(cgImage: croppedCGImage, scale: image.scale, orientation: image.imageOrientation)
}


func getCropImg(arView: CustomARView, cropRect: CGRect, completion: @escaping (UIImage?) -> Void) {
    
    for anchor in arView.scene.anchors{
        anchor.isEnabled = false
    }
    
    // 捕获截图
    arView.snapshot(saveToHDR: false) { image in
        guard let image = image else {
            print("Failed to capture image")
            completion(nil) // 返回 nil 作为失败的结果
            return
        }
        
        // 裁切图片
        let croppedImage = cropImage(image: image, cropRect: cropRect)
        if let croppedImage = croppedImage {
            completion(croppedImage) // 返回裁切后的图片
        } else {
            print("Failed to crop image")
            completion(nil) // 返回 nil 作为失败的结果
        }
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        for anchor in arView.scene.anchors {
            anchor.isEnabled = true
        }
    }
}



func testColor(arView: CustomARView, cropRect: CGRect) {
    if !caliComplete{
        return
    }
    testPixels.removeAll()
    for anchor in arView.scene.anchors{
        anchor.isEnabled = false
    }
    // 捕获截图
    arView.snapshot(saveToHDR: false) { image in
        guard let image = image else {
            print("Failed to capture image")
            return
        }
        // 裁切图片
        guard let croppedImage = cropImage(image: image, cropRect: cropRect) else {
            print("Failed to crop image")
            return
        }
        
        // 创建上下文以在图像上绘制
        UIGraphicsBeginImageContext(croppedImage.size)
        croppedImage.draw(at: .zero) // 将裁切的图像绘制到上下文
        
        // 获取上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            print("Failed to get graphics context")
            return
        }
        
        // 设置画笔颜色为绿色
        context.setFillColor(UIColor.green.cgColor)
        

        for i in 0..<steps.count {
                    var stepPixelData: [(UInt8, UInt8, UInt8)] = [] // 存储当前步骤的像素值
                    
                    for j in 0..<steps[i].count {
                        let coord = steps[i][j]
                        let pixel = getPixelValue(in: croppedImage, coordinate: (coord[0], coord[1]))
                        //print("Pixel Value at \(coord): \(pixel)")
                        
                        // 保存测试结果为 (R, G, B)
                        stepPixelData.append((pixel.0, pixel.1, pixel.2))
                        
                        // 根据坐标计算实际位置
                        let gridSize = 16 // 假设为 16x16 网格
                        let imageWidth = croppedImage.size.width
                        let imageHeight = croppedImage.size.height
                        let pixelWidth = imageWidth / CGFloat(gridSize)
                        let pixelHeight = imageHeight / CGFloat(gridSize)
                        
                        let x = CGFloat(coord[1] - 1) * pixelWidth + pixelWidth / 2
                        let y = CGFloat(coord[0] - 1) * pixelHeight + pixelHeight / 2
                        
                        // 绘制点
                        context.fillEllipse(in: CGRect(x: x - 2, y: y - 2, width: 4, height: 4))
                    }
                    
                    // 将当前步骤的像素数据添加到 testPixels 中
                    testPixels.append(stepPixelData)
                }

        validateSteps(testPixels: testPixels, imageArray: imageArray)
        updateModel(arView: arView)
        print(currentStep)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for anchor in arView.scene.anchors {
                anchor.isEnabled = true
            }
        }
    }
}


func testColor1(arView: CustomARView, cropRect: CGRect) {
    testPixels.removeAll()

    // 捕获截图
    arView.snapshot(saveToHDR: false) { image in
        guard let image = image else {
            print("Failed to capture image")
            return
        }
        // 裁切图片
        guard let croppedImage = cropImage(image: image, cropRect: cropRect) else {
            print("Failed to crop image")
            return
        }
        
        // 创建上下文以在图像上绘制
        UIGraphicsBeginImageContext(croppedImage.size)
        croppedImage.draw(at: .zero) // 将裁切的图像绘制到上下文
        
        // 获取上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            print("Failed to get graphics context")
            return
        }
        
        // 设置画笔颜色为绿色
        context.setFillColor(UIColor.green.cgColor)
        

        for i in 0..<steps.count {
                    var stepPixelData: [(UInt8, UInt8, UInt8)] = [] // 存储当前步骤的像素值
                    
                    for j in 0..<steps[i].count {
                        let coord = steps[i][j]
                        let pixel = getPixelValue(in: croppedImage, coordinate: (coord[0], coord[1]))
                        print("Pixel Value at \(coord): \(pixel)")
                        
                        // 保存测试结果为 (R, G, B)
                        stepPixelData.append((pixel.0, pixel.1, pixel.2))
                        
                        // 根据坐标计算实际位置
                        let gridSize = 16 // 假设为 16x16 网格
                        let imageWidth = croppedImage.size.width
                        let imageHeight = croppedImage.size.height
                        let pixelWidth = imageWidth / CGFloat(gridSize)
                        let pixelHeight = imageHeight / CGFloat(gridSize)
                        
                        let x = CGFloat(coord[1] - 1) * pixelWidth + pixelWidth / 2
                        let y = CGFloat(coord[0] - 1) * pixelHeight + pixelHeight / 2
                        
                        // 绘制点
                        context.fillEllipse(in: CGRect(x: x - 2, y: y - 2, width: 4, height: 4))
                    }
                    
                    // 将当前步骤的像素数据添加到 testPixels 中
                    testPixels.append(stepPixelData)
                }
        // 获取绘制后的图像
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            print("Failed to create new image")
            return
        }
        UIGraphicsEndImageContext() // 结束上下文
        
        // 保存到相册
        UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil)
        print("Image saved to photo library")
        //print("Test Pixels: \(testPixels)")
//        validateSteps(testPixels: testPixels, imageArray: imageArray)
//        updateModel(arView: arView)
//        print(currentStep)
        for i in 0...2 {
            let coord = steps[4][i]
            let pixel = getPixelValue(in: imageArray[7], coordinate: (coord[0], coord[1]))
            print("Pixel Value at \(coord): \(pixel)")
        }
    }
}



func getPixelValue(in image: UIImage, legoGridSize: Int = 16, coordinate: (Int, Int)) -> (UInt8, UInt8, UInt8) {
    guard let cgImage = image.cgImage else {
        print("Invalid image")
        return (0,0,0)
    }
    
    // 获取图片的宽高和像素数据
    let imageWidth = cgImage.width
    let imageHeight = cgImage.height
    guard let dataProvider = cgImage.dataProvider,
          let pixelData = dataProvider.data else {
        print("Unable to access pixel data")
        return (0,0,0)
    }
    
    // 计算网格尺寸
    let pixelWidth = imageWidth / legoGridSize
    let pixelHeight = imageHeight / legoGridSize
    
    
    let col = coordinate.1
    let row = coordinate.0
    let targetX = (col - 1) * pixelWidth + pixelWidth / 2
    let targetY = (row - 1) * pixelHeight + pixelHeight / 2
    
    // 转换到像素数组索引
    let bytesPerPixel = 4 // RGBA 每个像素占 4 字节
    let pixelIndex = (targetY * imageWidth + targetX) * bytesPerPixel
    
    // 提取 RGBA 值
    let buffer = CFDataGetBytePtr(pixelData)
    let red = buffer?[pixelIndex]
    let green = buffer?[pixelIndex + 1]
    let blue = buffer?[pixelIndex + 2]
    
    return (red!, green!, blue!)
}


func validateSteps(testPixels: [[(UInt8, UInt8, UInt8)]], imageArray: [UIImage], threshold: Int = 90) {
    guard testPixels.count == steps.count else {
        print("Error: testPixels count does not match steps count")
        return
    }
    
    guard imageArray.count == steps.count else {
        print("Error: imageArray count does not match steps count")
        return
    }

    for stepIndex in currentStep-1..<steps.count {
        // 获取当前步骤的坐标和测试像素值
        let stepCoordinates = steps[stepIndex]
        let stepTestPixels = testPixels[stepIndex]
        
        // 获取对应的参考图片
        let referenceImage = imageArray[stepIndex]
        
        // 检查参考图片的颜色数据
        var referenceColors: [(UInt8, UInt8, UInt8)] = []
        for coord in stepCoordinates {
            let pixelColor = getPixelValue(in: referenceImage, coordinate: (coord[0], coord[1]))
            referenceColors.append(pixelColor)
        }
        
        // 验证每个积木块的颜色
        var isStepCorrect = true
        var colorDifference = 0
        for (index, testPixel) in stepTestPixels.enumerated() {
            let referenceColor = referenceColors[index]
            
            // 检查颜色差异是否在允许阈值内
            colorDifference = abs(Int(testPixel.0) - Int(referenceColor.0)) +
                                  abs(Int(testPixel.1) - Int(referenceColor.1)) +
                                  abs(Int(testPixel.2) - Int(referenceColor.2))
            if colorDifference > threshold {
                isStepCorrect = false
                break
            }
        }
        
        // 输出结果
        if !isStepCorrect {
            print("Step \(stepIndex + 1) is incorrect")
            print(colorDifference)
            currentStep = stepIndex + 1
            return
        } 
    }
    currentStep = steps.count

}


//func showModel(arView: CustomARView){
//    let modelEntity = try! ModelEntity.loadModel(named: "Black1.usdz")
//    
//    // Create an anchor at a relative position
//    let anchorEntity = AnchorEntity()
//    anchorEntity.name = "brick"
//    anchorEntity.addChild(modelEntity)
//    
//    // Set position of the model relative to the anchor
//    modelEntity.position = SIMD3(x: 0, y: -0.03, z: 0) // Adjust z to position the model in front
//    modelEntity.scale = SIMD3(x: 0.0015, y: 0.0015, z: 0.0015) // 调整缩放因子，根据需要增大或减小
//
//    // Add the anchor to the scene
//    arView.scene.addAnchor(anchorEntity)
//}

func updateModel(arView: CustomARView){
    referenceAnchor.children.removeAll()
    showAnchor.children.removeAll()
    
    guard let referenceModel = try? ModelEntity.load(named: modelNames[currentStep-1]) else {
                    print("无法加载模型")
                    return
                }
    referenceModel.scale = SIMD3<Float>(0.13, 0.13, 0.13) // 缩小到 10%
    
    
    referenceAnchor.addChild(referenceModel)
    
    guard let showModel = try? ModelEntity.load(named: modelNames[currentStep-1]) else {
        print("无法加载模型")
        return
    }
    showModel.scale = SIMD3<Float>(0.09, 0.09, 0.09) // 缩小到 10%
    
    let currentCoordinate = coordinates[currentStep-1]
    // 拆分计算
    let xComponent = (currentCoordinate[0] - 1) * xUnit
    let zComponent = (currentCoordinate[1] - 1) * zUnit

     //计算最终位置
    let showModelPosition = original + xComponent + zComponent
    showModel.position = showModelPosition
    
     //应用旋转到模型
    if currentCoordinate[2] == 1 {
        showModel.transform.rotation = vRotation
    }
    else {
        showModel.transform.rotation = hRotation
    }
        
    showAnchor.addChild(showModel)
}

func updateAnchorPos(arView: CustomARView, Dir: SIMD3<Float>){
    caliAnchor.children.removeAll()
    
    guard let caliModel = try? ModelEntity.load(named: "Black1.usdz") else {
                    print("无法加载模型")
                    return
                }
    caliModel.scale = SIMD3<Float>(0.09, 0.09, 0.09) // 缩小到 10%
    caliAnchorPos += Dir
    caliModel.position = caliAnchorPos
    caliModel.transform.rotation = vRotation
    caliAnchor.addChild(caliModel)
}

func updateAnchorRotation (arView: CustomARView, dir: Int){
    if dir == 1{
        hRotationAngle += 5 * (.pi / 180)
    }
    else {
        hRotationAngle -= 5 * (.pi / 180)
    }

}

var caliComplete = false
func recordAnchorPos(arView:CustomARView){
    if caliComplete {
        return
    }
    caliAnchorPoses.append(caliAnchorPos)
    if caliAnchorPoses.count == 3{
        original = caliAnchorPoses[0]
        xUnit = (caliAnchorPoses[2] - caliAnchorPoses[1]) / 15
        zUnit = (caliAnchorPoses[1] - caliAnchorPoses[0]) / 15
        caliComplete = true
        arView.scene.removeAnchor(caliAnchor)
        return
    }
}

class PeriodicTask {
    var timer: Timer?
    var arView: CustomARView
    var cropRect: CGRect
    init(timer: Timer? = nil, arView: CustomARView, cropRect: CGRect) {
        self.timer = timer
        self.arView = arView
        self.cropRect = cropRect
    }
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            testColor(arView: self.arView, cropRect: self.cropRect)
            
//            validateSteps(testPixels: testPixels, imageArray: imageArray)
        }
    }
    

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}


