//
//  CircleProgressView.swift
//  Circle Progress Bar
//
//  Created by Luis Gustavo Oliveira Silva on 10/04/20.
//  Copyright © 2020 Luis Gustavo Oliveira Silva. All rights reserved.
//

import UIKit

class CircleProgressView: UIView {
    
    var progressColor: UIColor
    var trackColor: UIColor
    var borderOrPulsatingColor: UIColor
    var colorBackground: UIColor
    var ispulsating: Bool
    var textColor: UIColor
    var valuePercent: Int
    var durationAnimation: Float
    var isAnimation: Bool
    var isBackgroudTransparent: Bool
    
    init(
        progressColor: UIColor? = nil,
        trackColor: UIColor? = nil,
        borderOrPulsatingColor: UIColor? = nil,
        colorBackground: UIColor? = nil,
        ispulsating: Bool? = nil,
        textColor: UIColor? = nil,
        valuePercent: Int? = nil,
        durationAnimation: Float? = nil,
        frame: CGRect? = nil,
        isAnimation: Bool? = nil,
        isBackgroudTransparent: Bool? = nil
    ) {
        self.progressColor = progressColor ?? UIColor.red
        self.trackColor = trackColor ?? UIColor.lightGray
        self.borderOrPulsatingColor = borderOrPulsatingColor ?? UIColor.black
        self.colorBackground = colorBackground ?? UIColor.clear
        self.ispulsating = ispulsating ?? false
        self.textColor = textColor ?? UIColor.black
        self.valuePercent = valuePercent ?? 0
        self.durationAnimation = durationAnimation ?? 2.0
        self.isAnimation = isAnimation ?? false
        self.isBackgroudTransparent = isBackgroudTransparent ?? false
        super.init(frame: frame ?? CGRect(x: 0, y: 0, width: 100, height: 100))
        self.setupCircleLayers()
        self.setupContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var progressLayer = CAShapeLayer()
    var borderOrPulsatingLayer = CAShapeLayer()
    var trackLayer = CAShapeLayer()
    
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius:(frame.size.width - setupSize())/2, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = setupLineWidth()
        layer.fillColor = fillColor.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        layer.position = self.center
        return layer
    }
    
    private func setupCircleLayers() {
        layer.frame = self.bounds
        setupBorderAndPulsatingColorLayer()
        setupTrackLayer()
        setupProgressLayer()
        
        if isAnimation {
            start(duration: durationAnimation, value: valuePercent)
        }
    }
    
    func setupBorderAndPulsatingColorLayer() {
        borderOrPulsatingLayer = createCircleShapeLayer(strokeColor:
            borderOrPulsatingColor, fillColor: .clear)
        if ispulsating {
            animatePulsatingLayer()
        } else {
            borderOrPulsatingLayer.lineWidth = CGFloat(setupLineWidth() * 2)
        }
        layer.addSublayer(borderOrPulsatingLayer)
    }
    
    func setupTrackLayer() {
        trackLayer = createCircleShapeLayer(strokeColor: trackColor, fillColor: colorBackground)
        if isBackgroudTransparent {
            trackLayer.opacity = 0.5
        }
        layer.addSublayer(trackLayer)
    }
    
    func setupProgressLayer() {
        progressLayer = createCircleShapeLayer(strokeColor: progressColor, fillColor: .clear)
        progressLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
    }
    
    func start(duration: Float, value: Int) {
        setProgressWhithAnimation(duration: TimeInterval(duration), value: Float(value) / 100)
        startTimer(valuePercent: value, durationAnimation: duration)
    }
    
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.17
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        borderOrPulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    func setProgressWhithAnimation(duration: TimeInterval, value: Float){
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = value
        progressLayer.strokeEnd = CGFloat(value)
        progressLayer.add(animation, forKey: "animateprogress")
    }
    
    func setupSizelabel() -> CGFloat {
        let sizeLabel = frame.size.width * 0.3
        return sizeLabel
    }
    
    func setupSizePercent(sizeLabel: CGFloat) -> CGFloat {
        let fontPorcent = sizeLabel * 0.35
        return fontPorcent
    }
    
    func setupLineWidth() -> CGFloat{
        let lineWidth = frame.size.width * 0.06
        return lineWidth
    }
    
    func setupSize() -> CGFloat {
        let setupSize = frame.size.width * 0.2
        return setupSize
    }
    
    private lazy var valueLabel: UILabel = {
        var label = UILabel()
        label.textColor = textColor
        label.textAlignment = .center
        label.text = "0"
        label.font = .systemFont(ofSize: setupSizelabel())
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var percentLabel: UILabel = {
        var percentLabel = UILabel()
        percentLabel.textColor = textColor
        percentLabel.text = "%"
        percentLabel.font = .systemFont(ofSize: setupSizePercent(sizeLabel: setupSizelabel()))
        percentLabel.textAlignment = .center
        percentLabel.numberOfLines = 0
        return percentLabel
    }()
    
    private lazy var view: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupContraints() {
        addSubview(view)
        let viewCenterY = view.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let viewCenterX = view.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        NSLayoutConstraint.activate([viewCenterY, viewCenterX])
        
        
        view.addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        let labelTop = valueLabel.topAnchor.constraint(equalTo: view.topAnchor)
        let labelLeading = valueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let labelBottom = valueLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([labelTop, labelLeading, labelBottom])
        
        
        view.addSubview(percentLabel)
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        let porcentTop = percentLabel.topAnchor.constraint(equalTo: valueLabel.topAnchor)
        let porcentLeading = percentLabel.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor)
        let porcentTrailing = percentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        NSLayoutConstraint.activate([porcentTop, porcentLeading,porcentTrailing])
    }
    
    func startTimer(valuePercent: Int, durationAnimation: Float) {
        let value = durationAnimation / Float(valuePercent)
        let durationAnimation = TimeInterval(value)
        let userInfo: NSMutableDictionary = [
            "counter": 0,
            "howManyCounts": valuePercent

        ]
        var timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: durationAnimation, target: self, selector: #selector(timerHandler), userInfo: userInfo, repeats: true)
    }
    
    @objc func timerHandler(timer: Timer) {
        guard let info = timer.userInfo as? NSMutableDictionary else {
            return
        }
        var counter = info["counter"] as? Int ?? 0
        let howManyCounts = info["howManyCounts"] as? Int ?? 0
        
        counter += 1
        
        if counter >= howManyCounts {
            timer.invalidate()
            valueLabel.text = String(counter)
        } else {
            info["counter"] = counter
            valueLabel.text = String(counter)
        }
    }
    
}
