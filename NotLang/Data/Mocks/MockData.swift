//
//  MockData.swift
//  NotLang
//
//  Created by Amier Davis on 1/13/26.
//

import Foundation

// MARK: - French Translation Chunks
extension TranslationChunk {
    // Conversational Chunks
    static let bonjour = TranslationChunk(text: "Bonjour", translation: "Hello", isPhrase: false)
    static let commentCaVa = TranslationChunk(text: "comment ça va ?", translation: "how is it going?", isPhrase: true)
    static let caVaBien = TranslationChunk(text: "Ça va bien", translation: "It's going well", isPhrase: true)
    static let tellement = TranslationChunk(text: "tellement", translation: "so much", isPhrase: false)
    static let merci = TranslationChunk(text: "merci", translation: "thank you", isPhrase: false)
    
    // Dining & Requests
    static let jeVoudrais = TranslationChunk(text: "Je voudrais", translation: "I would like", isPhrase: true)
    static let unCroissant = TranslationChunk(text: "un croissant", translation: "a croissant", isPhrase: false)
    static let silVousPlait = TranslationChunk(text: "s'il vous plaît", translation: "please", isPhrase: true)
    
    // Description & Places
    static let laTourEiffel = TranslationChunk(text: "La tour Eiffel", translation: "The Eiffel Tower", isPhrase: true)
    static let estMagnifique = TranslationChunk(text: "est magnifique", translation: "is magnificent", isPhrase: false)
    static let jaime = TranslationChunk(text: "J'aime", translation: "I love", isPhrase: false)
    static let paris = TranslationChunk(text: "Paris", translation: "Paris", isPhrase: false)
    
    // Time & Weather
    static let ilFaitBeau = TranslationChunk(text: "Il fait beau", translation: "The weather is nice", isPhrase: true)
    static let aujourdhui = TranslationChunk(text: "aujourd'hui", translation: "today", isPhrase: false)
}

// MARK: - Multi-Language Translation Chunks
extension TranslationChunk {
    // Spanish Samples
    static let hola = TranslationChunk(text: "Hola", translation: "Hello", isPhrase: false)
    static let comoEstas = TranslationChunk(text: "¿cómo estás?", translation: "how are you?", isPhrase: true)
    static let meGusta = TranslationChunk(text: "Me gusta", translation: "I like", isPhrase: true)
    static let elCafe = TranslationChunk(text: "el café", translation: "the coffee", isPhrase: false)
    
    // Japanese Samples
    static let konnichiwa = TranslationChunk(text: "こんにちは", translation: "Hello", isPhrase: false)
    static let ogenki = TranslationChunk(text: "お元気ですか？", translation: "Are you well?", isPhrase: true)
    
    // Italian Samples
    static let grazie = TranslationChunk(text: "Grazie", translation: "Thank you", isPhrase: false)
    static let mille = TranslationChunk(text: "mille", translation: "a thousand", isPhrase: false)
    
    // French Samples (Additional)
    static let ouEst = TranslationChunk(text: "Où est", translation: "Where is", isPhrase: true)
    static let laBibliotheque = TranslationChunk(text: "la bibliothèque", translation: "the library", isPhrase: false)
    static let enchanté = TranslationChunk(text: "Enchanté", translation: "Nice to meet you", isPhrase: true)
    static let toutLeMonde = TranslationChunk(text: "tout le monde", translation: "everyone", isPhrase: true)
}

// MARK: - LangPost Samples
extension LangPost {
    // French Posts
    static let generalGreeting = LangPost(
        author: "Chloe",
        topic: "Greetings",
        content: [.bonjour, .commentCaVa]
    )
    
    static let bakeryOrder = LangPost(
        author: "Pierre",
        topic: "Dining",
        content: [.jeVoudrais, .unCroissant, .silVousPlait]
    )
    
    static let travelPost = LangPost(
        author: "Amier",
        topic: "Sightseeing",
        content: [.laTourEiffel, .estMagnifique]
    )
    
    static let cityLove = LangPost(
        author: "Lucie",
        topic: "Lifestyle",
        content: [.jaime, .paris, .tellement]
    )
    
    static let weatherUpdate = LangPost(
        author: "Jean",
        topic: "Weather",
        content: [.ilFaitBeau, .aujourdhui]
    )
    
    static let positiveResponse = LangPost(
        author: "Marie",
        topic: "Small Talk",
        content: [.caVaBien, .merci]
    )
    
    // International Posts
    static let spanishGreeting = LangPost(
        author: "Elena",
        topic: "Greetings",
        content: [.hola, .comoEstas]
    )
    
    static let coffeeLover = LangPost(
        author: "Marco",
        topic: "Food & Drink",
        content: [.meGusta, .elCafe]
    )
    
    static let japaneseIntro = LangPost(
        author: "Yuki",
        topic: "Greetings",
        content: [.konnichiwa, .ogenki]
    )
    
    static let italianGratitude = LangPost(
        author: "Luca",
        topic: "Etiquette",
        content: [.grazie, .mille]
    )
    
    static let frenchQuestion = LangPost(
        author: "Sophie",
        topic: "Directions",
        content: [.ouEst, .laBibliotheque]
    )
    
    static let socialMeeting = LangPost(
        author: "Amier",
        topic: "Social",
        content: [.enchanté, .toutLeMonde]
    )
}

extension LangPost {
    static func mockFromAI() -> LangPost {
        let jsonString = #"""
            {
                "author": "Léa, influenceuse lifestyle à Paris",
                "topic": "Un café trop cher et pas bon",
                "content": [
                    { "text": "Franchement,", "translation": "Honestly,", "isPhrase": false },
                    { "text": "le nouveau coffee shop", "translation": "the new coffee shop", "isPhrase": true },
                    { "text": "c’est une grosse douille.", "translation": "it's a total rip-off.", "isPhrase": true }
                ]
            }
            """#
        
        let jsonData = Data(jsonString.utf8)
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(LangPost.self, from: jsonData)
        } catch {
            print("Decoding error: \(error)")
            return LangPost(author: "Error", topic: "N/A", content: [])
        }
    }
}
