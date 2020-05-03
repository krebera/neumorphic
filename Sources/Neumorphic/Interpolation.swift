//
//  File.swift
//  
//
//  Created by Keenan Rebera on 5/1/20.
//

import Foundation

func linearInterpolate(x: Double, y: Double, t: Double) -> Double {
    var t_corr = t
    if(t > 1.0) {
        t_corr = 1.0
    }
    if(t < 0.0) {
        t_corr = 0.0
    }
    return x * (1.0 - t_corr) + y * t_corr
}

func cosineInterpolate(x: Double, y: Double, t: Double) -> Double {
    let t2 = (1.0 - cos(x * .pi)) / 2.0
    return x * (1.0 - t2) + y * t2
}
