//
//  Announcer.swift
//  Coach
//
//  Created by Bradley Lindauer on 3/29/21.
//

import AVFoundation

class Announcer {
    private let synthesizer = AVSpeechSynthesizer()
    
    func speak(_ string: String) {
        let utterance = AVSpeechUtterance(string: string)
        synthesizer.speak(utterance)
    }
}
