//
//  Steps.swift
//  ARImageTracking
//
//  Created by 吴征航 on 2024/12/11.
//

import Foundation
import UIKit

var steps: [[[Int]]] = [
    [[6, 16], [7, 16], [8, 16]], //1 red
    [[9,16],[10,16]], //2 red
    [[5,15],[6,15],[7,15],[8,15],[9,15],[10,15],[11,15],[12,15]], //3 red
    [[13,15]],  //4 red
    [[5,14],[6,14],[7,14]], //5 brown
    [[8,14],[9,14]], //6 tan
    [[10,14],[10,13]], //7 black
    [[11,14]], //8 tan
    [[4,13],[4,12]], //9 brown
    [[5,13],[5,12]], //10 tan
    [[6,13],[6,12]], //11 brown
    [[7,13],[8,13],[9,13]], //12 tan
    [[11,13],[12,13],[13,13]], // 13 tan
    [[7,12]], //14 brown
    [[8,12],[9,12],[10,12]], //15 tan
    [[11,12]], //16 black
    [[12,12],[13,12],[14,12]], //17 tan
    [[5,11]], //18 brown
    [[6,11],[7,11],[8,11],[9,11]], //19 tan
    [[10,11],[11,11],[12,11],[13,11]], //20 black
    [[6,10],[7,10],[8,10],[9,10],[10,10],[11,10]], //21 tan
    [[5,9],[5,10]], //22 blue
    [[7,9],[7,8],[7,7]], //23 red
    [[8,9],[8,8],[8,7]], //24 blue
    [[9,9],[9,8],[9,7]], //25 blue
    [[10,9],[10,8],[10,7]], //26 red
    [[4,8],[5,8],[6,8]], //27 blue
    [[11,8],[12,8],[13,8]], //28 blue
    [[3,7],[4,7],[5,7],[6,7]], //29 blue
    [[11,7],[12,7],[13,7],[14,7]], //30 blue
    [[3,6],[4,6]], //31 tan
    [[5,6],[6,6]], //32 blue
    [[7,6],[8,6],[9,6],[10,6]], //33 red
    [[11,6],[12,6]], //34 blue
    [[13,6],[14,6]], //35 tan
    [[3,5],[4,5],[5,5]], //36 tan
    [[6,5]], //37 red
    [[7,5]], //38 yellow
    [[8,5],[9,5]], //39 red
    [[10,5]], //40 yellow
    [[11,5]], //41 red
    [[12,5],[13,5],[14,5]], //42 tan
    [[3,4],[4,4]], //43 tan
    [[5,4],[6,4],[7,4],[8,4],[9,4],[10,4],[11,4],[12,4]], //44 red
    [[13,4],[14,4]], //45 tan
    [[5,3],[6,3],[7,3]], //46 red
    [[10,3],[11,3],[12,3]], //47 red
    [[4,2],[5,2],[6,2]], //48 brown
    [[11,2],[12,2],[13,2]], //49 brown
    [[3,1],[4,1],[5,1],[6,1]], //50 brown
    [[11,1],[12,1],[13,1],[14,1]]  // 51 brown
    
]

// 0-horizontal   1-vertical
var coordinates: [[Float]] = [
    [1, 7, 0],    // 1 red
    [1, 9.5, 0],  // 2 red
    [2, 8.5, 0],  // 3 red
    [2, 13, 0],   // 4 red
    [3, 6, 0],    // 5 brown
    [3, 8.5, 0],  // 6 tan
    [3.5, 10, 1], // 7 black
    [3, 11, 0],   // 8 tan
    [4.5, 4, 1],  // 9 brown
    [4.5, 5, 1],  // 10 tan
    [4.5, 6, 1],  // 11 brown
    [4, 8, 0],    // 12 tan
    [4, 12, 0],   // 13 tan
    [5, 7, 0],    // 14 brown
    [5, 9, 0],    // 15 tan
    [5, 11, 0],   // 16 black
    [5, 13, 0],   // 17 tan
    [6, 5, 0],    // 18 brown
    [6, 7.5, 0],  // 19 tan
    [6, 11.5, 0], // 20 black
    [7, 8.5, 0],  // 21 tan
    [8, 5.5, 0],  // 22 blue
    [9, 7, 1],    // 23 red
    [9, 8, 1],    // 24 blue
    [9, 9, 1],    // 25 blue
    [9, 10, 1],   // 26 red
    [9, 5, 0],    // 27 blue
    [9, 12, 0],   // 28 blue
    [10, 4.5, 0], // 29 blue
    [10, 12.5, 0],// 30 blue
    [11, 3.5, 0], // 31 tan
    [11, 5.5, 0], // 32 blue
    [11, 8.5, 0], // 33 red
    [11, 11.5, 0],// 34 blue
    [11, 13.5, 0],// 35 tan
    [12, 4, 0],   // 36 tan
    [12, 6, 0],   // 37 red
    [12, 7, 0],   // 38 yellow
    [12, 8.5, 0], // 39 red
    [12, 10, 0],  // 40 yellow
    [12, 11, 0],  // 41 red
    [12, 13, 0],  // 42 tan
    [13, 3.5, 0], // 43 tan
    [13, 8.5, 0], // 44 red
    [13, 13.5, 0],// 45 tan
    [14, 6, 0],   // 46 red
    [14, 11, 0],  // 47 red
    [15, 5, 0],   // 48 brown
    [15, 12, 0],  // 49 brown
    [16, 4.5, 0], // 50 brown
    [16, 12.5, 0] // 51 brown
]

var modelNames = ["Red3.usdz", //1 red
                  "Red2.usdz", //2 red
                  "Red8.usdz", //3 red
                  "Red1.usdz", //4 red
                  "Brown3.usdz",//5 brown
                  "Tan2.usdz",  //6 tan
                  "Black2.usdz",//7 black
                  "Tan1.usdz",  //8 tan
                  "Brown2.usdz",//9 brown
                  "Tan2.usdz",  //10 tan
                  "Brown2.usdz",//11 brown
                  "Tan3.usdz",  //12 tan
                  "Tan3.usdz",  //13 tan
                  "Brown1.usdz",//14 brown
                  "Tan3.usdz",  //15 tan    
                  "Black1.usdz",//16 black
                  "Tan3.usdz",  //17 tan
                  "Brown1.usdz",//18 brown
                  "Tan4.usdz",  //19 tan
                  "Black4.usdz",//20 black
                  "Tan6.usdz",  //21 tan
                  "Blue2.usdz", //22 blue
                  "Red3.usdz",  //23 red
                  "Blue3.usdz", //24 blue
                  "Blue3.usdz", //25 blue
                  "Red3.usdz",  //26 red
                  "Blue3.usdz", //27 blue
                  "Blue3.usdz", //28 blue
                  "Blue4.usdz", //29 blue
                  "Blue4.usdz", //30 blue
                  "Tan2.usdz",  //31 tan
                  "Blue2.usdz", //32 blue
                  "Red4.usdz",  //33 red
                  "Blue2.usdz", //34 blue
                  "Tan2.usdz",  //35 tan2
                  "Tan3.usdz",  //36 tan
                  "Red1.usdz",  //37 red
                  "Yellow1.usdz", //38 yellow
                  "Red2.usdz",  //39 red
                  "Yellow1.usdz", //40 yellow
                  "Red1.usdz",  //41 red
                  "Tan3.usdz",  //42 tan
                  "Tan2.usdz",  //43 tan2
                  "Red8.usdz",  //44 red
                  "Tan2.usdz",  //45 tan
                  "Red3.usdz",  //46 red
                  "Red3.usdz",  //47 red
                  "Brown3.usdz", //48 brown
                  "Brown3.usdz", //49 brown
                  "Brown4.usdz", //50 brown
                  "Brown4.usdz"  //51 brown
                    ]


var imageArray: [UIImage] = []

func loadImages(){
    for i in 1...steps.count {
        if let image = UIImage(named: "52.JPG") {
                imageArray.append(image)
            } else {
                print("无法加载图片: \(i).jpg")
            }
    }
}



