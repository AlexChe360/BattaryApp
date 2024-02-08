//
//  BattaryView.swift
//  BattaryApp
//
//  Created by Alex on 08.02.2024.
//

import UIKit
import CoreGraphics

class BattaryView: UIView {
    
    private var thresholdLinePath: UIBezierPath!
    private var batteryBorderPath: UIBezierPath!
    private var batteryLevelPath: UIBezierPath!
    private var path: UIBezierPath!
    private var fillPath: UIBezierPath!
    private var blackPaint: CAShapeLayer!
    private var thresholdLinePaint: CAShapeLayer!
    private var batteryBorderPaint: CAShapeLayer!
    private var batteryFillPaint: CAShapeLayer!
    private var batteryLevelPaint: CAShapeLayer!
    private var fillPaint: CAShapeLayer!
    private var whiteFillPaint: CAShapeLayer!
    private var max: Int? = nil
    private var points: Array<Int>? = nil
    private var currentPosition: Int? = nil
    
    func showBattary(points: Array<Int>, max: Int, currentPosition: Int) {
        self.max = max
        self.currentPosition = currentPosition
        self.points = points
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.sublayers = nil
        
        if max == nil && currentPosition == nil && points == nil {
            return
        }
        
        let right = rect.width * 0.05
        let rectX = rect.width * 0.06
        let rectY = rect.width * 0.315
        let bottom = rectX + (right * 1.44)
        
        
        thresholdLinePaint = CAShapeLayer()
        thresholdLinePaint.strokeColor = UIColor.magenta.cgColor
        thresholdLinePaint.lineWidth = rect.width * 0.004
        thresholdLinePaint.fillColor = nil
        
        blackPaint = CAShapeLayer()
        blackPaint.strokeColor = UIColor.black.cgColor
        blackPaint.lineWidth = rect.width * 0.008
        blackPaint.fillColor = nil
        
        let precentTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "SF Pro Text", size: rect.width * 0.07) ?? UIFont.systemFont(ofSize: rect.width * 0.07),
            .foregroundColor: UIColor.black
        ]
        
        batteryBorderPaint = CAShapeLayer()
        batteryBorderPaint.strokeColor = UIColor.gray.cgColor
        batteryBorderPaint.lineWidth = rect.width * 0.0018
        batteryBorderPaint.fillColor = nil
        
        batteryFillPaint = CAShapeLayer()
        batteryFillPaint.fillColor = UIColor.lightGray.cgColor
        
        batteryLevelPaint = CAShapeLayer()
        batteryLevelPaint.fillColor = UIColor.green.cgColor
        
        fillPaint = CAShapeLayer()
        fillPaint.fillColor = UIColor.black.cgColor
        
        whiteFillPaint = CAShapeLayer()
        whiteFillPaint.strokeColor = UIColor.white.cgColor
        whiteFillPaint.lineWidth = rect.width * 0.023
        whiteFillPaint.fillColor = nil
        
//        thresholdLinePath = UIBezierPath()
//        batteryBorderPath = UIBezierPath()
//        batteryLevelPath = UIBezierPath()
//        path = UIBezierPath()
//        fillPath = UIBezierPath()
        
        let batRadius = rect.width * 0.041
        var points = points ?? []
        points.append(max ?? 0)
        points.reverse()
        
        let currentPos = currentPosition ?? 0
        let sectionSize = points.count
        let rectRatioS = rect.width * 0.022
        let batBottom = ((bottom - rectRatioS) - (rectX + rectRatioS)) / CGFloat(sectionSize)
        
        path = UIBezierPath(roundedRect: CGRect(x: rectX + right * 0.25, y: rectY - (rect.width * 0.055), width: right * 0.75, height: rectY), cornerRadius: 15)
        fillPath = UIBezierPath(roundedRect: CGRect(x: rectX + right * 0.25, y: rectY - (rect.width * 0.055), width: right * 0.56, height: rectY), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 15, height: 15))
        
        var textYPoints = [CGFloat]()
        
        points.enumerated().forEach { index, value in
            
            let sector = index + 1
            var batLevel: CGFloat = 0.0
            
            if let currentPos = points.indices.first(where: { _ in points[0] == value }) {
                if currentPos < value {
                    batLevel = (1.0 / CGFloat((value - currentPos))) * CGFloat((currentPos - currentPos))
                } else {
                    batLevel = (1.0 / CGFloat(value)) * CGFloat(currentPos)
                }
                
                if batLevel > 1.0 {
                    batLevel = 1.0
                }
                
                if currentPos >= currentPos {
                    batLevel = 0.0
                }
            }
            
            if sector == 1 {
                let bottomCorner = sectionSize == 1 ? batRadius : 0.0
                let progressBottom = rectY + (rect.width * 0.018) + batBottom
                let progressTop = rectY + (rect.width * 0.023)
                let levelPoint = (progressBottom - progressTop) * (1.0 - batLevel)
                
//                batteryBorderPath = UIBezierPath(roundedRect: CGRect(x: Int(rectX) + Int(rectRatioS), y: Int(rectY + rectRatioS) + (Int(batBottom) * index), width: Int(right - rectRatioS), height: Int((rectY + (rect.width * 0.019)) + batBottom)), byRoundingCorners: .allCorners, cornerRadii: [batRadius, batRadius, batRadius, batRadius, bottomCorner, bottomCorner, bottomCorner, bottomCorner])
                
                batteryLevelPath = UIBezierPath(roundedRect: CGRect(x: rectX + (rect.width * 0.023), y: progressTop + levelPoint, width: right - (rect.width * 0.023), height: progressBottom), cornerRadius: 0.0)
                
                thresholdLinePath.move(to: CGPoint(x: rectX + (rect.width * 0.06), y: rectY + (rect.width * 0.018)))
                thresholdLinePath.addQuadCurve(to: CGPoint(x: right + (rect.width * 0.03), y: rectY + (rect.width * 0.018)), controlPoint: CGPoint(x: right + (rect.width * 0.03), y: rectY + (rect.width * 0.018)))
                thresholdLinePath.addQuadCurve(to: CGPoint(x: right + (rect.width * 0.07), y: rectY - (rect.width * 0.02)), controlPoint: CGPoint(x: right + (rect.width * 0.07), y: rectY - (rect.width * 0.02)))
                thresholdLinePath.addQuadCurve(to: CGPoint(x: right + (rect.width * 0.35), y: rectY - (rect.width * 0.02)), controlPoint: CGPoint(x: right + (rect.width * 0.35), y: rectY - (rect.width * 0.02)))
                
                textYPoints.append(CGFloat(progressTop + (progressBottom - progressTop) * 0.7))
                
            } else if sector == sectionSize {
                let progressBottom = (rectY + (rect.width * 0.021)) + batBottom * CGFloat(sector)
                let progressTop = (rectY + (rect.width * 0.026)) + batBottom * (sector - 1)
                let levelPoint = (progressBottom - progressTop) * (1.0 - batLevel)
                
                batteryBorderPath = UIBezierPath(roundedRect: CGRect(x: rectX + rectRatioS, y: (rectY + (rect.width * 0.025)) + (batBottom * index), width: right - rectRatioS, height: (rectY + (rect.width * 0.022)) + batBottom * sector), cornerRadii: [0.0, 0.0, 0.0, 0.0, batRadius, batRadius, batRadius, batRadius])
                
                batteryBorderPath = UIBezierPath(roundedRect: CGRect(x: rectX + (rect.width * 0.023), y: progressTop + levelPoint, width: right - (width * 0.023), height: progressBottom), cornerRadius: 0.0)
                                
                thresholdLinePath.move(to: CGPoint(x: rectX + rectRatioS, y: (rectY + (rect.width * 0.023)) + (batBottom * index)))
                thresholdLinePath.addQuadCurve(to: CGPoint(x: right + (rect.width * 0.03), y: (rectY + (rect.width * 0.023)) + (batBottom * index)), controlPoint: CGPoint(x: right + (rect.width * 0.03), y: (rectY + (rect.width * 0.023)) + (batBottom * index)))
                thresholdLinePath.addQuadCurve(to: CGPoint(x: right + (rect.width * 0.07), y: (rectY - (rect.width * 0.04)) + (batBottom * index)), controlPoint: CGPoint(x: right + (rect.width * 0.07), y: (rectY - (rect.width * 0.04)) + (batBottom * index)))
                thresholdLinePath.addQuadCurve(to: CGPoint(x: right + (rect.width * 0.35), y: (rectY - (rect.width * 0.04)) + (batBottom * index)), controlPoint: CGPoint(x: right + (rect.width * 0.35), y: (rectY - (rect.width * 0.04)) + (batBottom * index)))
                
                textYPoints.append(CGFloat(progressTop + (progressBottom - progressTop) * 0.7))
            } else {
                let progressBottom = (rectY + (rect.width * 0.0195)) + batBottom * sector
                let progressTop = (rectY + (rect.width * 0.0245)) + batBottom * (sector - 1)
                let levelPoint = (progressBottom - progressTop) * (1.0 - batLevel)
                
                
//                batteryBorderPath.addRoundedRect(rectX + rectRatioS, (rectY + (width * 0.0235)) + (batBottom * index), right - rectRatioS, (rectY + (width * 0.0205)) + batBottom * sector, cornerRadii: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], transform: .identity)
//                        
//                        batteryLevelPath.addRoundedRect(rectX + (width * 0.023), progressTop + levelPoint, right - (width * 0.023), progressBottom, cornerRadius: 0.0, transform: .identity)
//                        
//                        thresholdLinePath.move(to: CGPoint(x: rectX + rectRatioS, y: (rectY + (width * 0.023)) + (batBottom * index)))
//                        thresholdLinePath.addQuadCurve(to: CGPoint(x: right + (width * 0.03), y: (rectY + (width * 0.023)) + (batBottom * index)), controlPoint: CGPoint(x: right + (width * 0.03), y: (rectY + (width * 0.023)) + (batBottom * index)))
//                        thresholdLinePath.addQuadCurve(to: CGPoint(x: right + (width * 0.07), y: (rectY - (width * 0.04)) + (batBottom * index)), controlPoint: CGPoint(x: right + (width * 0.07), y: (rectY - (width * 0.04)) + (batBottom * index)))
//                        thresholdLinePath.addQuadCurve(to: CGPoint(x: right + (width * 0.35), y: (rectY - (width * 0.04)) + (batBottom * index)), controlPoint: CGPoint(x: right + (width * 0.35), y: (rectY - (width * 0.04)) + (batBottom * index)))
//                        
//                        textYPoints += progressTop + (progressBottom - progressTop) * 0.7
            }
        }
        
    }
    
}


