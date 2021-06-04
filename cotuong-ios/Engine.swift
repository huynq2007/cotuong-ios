//
//  Luna.swift
//  cotuong-ios
//
//  Created by hnguyen on 6/2/21.
//

import Foundation

struct EleeyeMove {
    var x1: Int8
    var y1: Int8
    var x2: Int8
    var y2: Int8
}

extension StringProtocol {
    var asciiValues: [UInt8] { compactMap(\.asciiValue) }
}

extension AIController {
    internal func asyncTask(task: @escaping (@escaping () -> Void) -> Void) {
        self.taskQueue.async { [weak self] in
            self?.taskSignal.wait()
            DispatchQueue.main.async {
                task() {
                    self?.taskSignal.signal()
                }
            }
        }
    }
}

class AIController {
    private let taskQueue: DispatchQueue = DispatchQueue(label: "taskQueue")
    private let taskSignal: DispatchSemaphore = DispatchSemaphore(value: 1)
    private var thinkingTime: Int32 = 5

    init(thinkingTime: Int32){
        engineInit("OPENBOOK.DAT")
        let fen = "rnbakabnr/9/1c5c1/p1p1p1p1p/9/9/P1P1P1P1P/1C5C1/9/RNBAKABNR w"
        engineSetFEN(fen)
        self.thinkingTime = thinkingTime
    }

    func tryThink() -> (from: Point, to: Point)? {
        var bestMove = engineThink(self.thinkingTime)
        if (bestMove > 0) {
            let data = Data(bytes:  &bestMove, count: MemoryLayout<EleeyeMove>.stride)
            let x1 = UInt8(data[0]) - "a".asciiValues[0]
            let y1 = "9".asciiValues[0] - UInt8(data[1])
            let x2 = UInt8(data[2]) - "a".asciiValues[0]
            let y2 = "9".asciiValues[0] - UInt8(data[3])
            return (Point(x: Int(x1), y: Int(y1)), Point(x: Int(x2), y: Int(y2)))
        }
        return nil
    }
    
    func makeEngineMove(from: Point, to: Point) -> Bool {
        let x1 = "a".asciiValues[0] + UInt8(from.x)
        let y1 = String(9 - from.y).asciiValues[0]
        let x2 = "a".asciiValues[0] + UInt8(to.x)
        let y2 = String(9 - to.y).asciiValues[0]
        var gridMove = EleeyeMove(x1: Int8(x1), y1: Int8(y1), x2: Int8(x2), y2: Int8(y2))
        
        let data = Data(bytes:  &gridMove, count: MemoryLayout<EleeyeMove>.stride)
        let eleeyeMove = data.withUnsafeBytes { pointer in
            return pointer.load(as: UInt32.self)
        }
        return doEngineMove(eleeyeMove)
    }

    func quitEngine() {
        engineQuit();
    }
}



