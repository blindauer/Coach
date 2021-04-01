//
//  Announcer.swift
//  Coach
//
//  Created by Bradley Lindauer on 3/29/21.
//

import AVFoundation

// How to use Siri voice?!
// See: https://developer.apple.com/videos/play/wwdc2018/236/

class Announcer {
    func speak(_ string: String) {
        let utterance = AVSpeechUtterance(string: string)
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}
