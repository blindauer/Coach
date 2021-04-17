//
//  Announcer.swift
//  Coach
//
//  Created by Bradley Lindauer on 3/29/21.
//

import AVFoundation

// How to use Siri voice?!
// See: https://developer.apple.com/videos/play/wwdc2018/236/

protocol AnnouncerDelegate: class {
    func didFinishSpeaking(_ string: String)
}

class Announcer: NSObject {
    weak var delegate: AnnouncerDelegate?
    
    func speak(_ string: String) {
        let utterance = AVSpeechUtterance(string: string)
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.delegate = self
        synthesizer.speak(utterance)
    }
}

extension Announcer: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        delegate?.didFinishSpeaking(utterance.speechString)
    }
}
