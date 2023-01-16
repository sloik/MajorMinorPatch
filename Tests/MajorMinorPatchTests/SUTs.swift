
import Foundation
import MajorMinorPatch


let ver_0_0_0 = Semantic.ver_0_0_0
let ver_1_0_0 = Semantic.ver_1_0_0

let ver_2_0_0 = Semantic.v(ver: .init(major: 2, minor: 0, patch: 0) )
let ver_2_1_0 = Semantic.v(ver: .init(major: 2, minor: 1, patch: 0) )
let ver_2_1_1 = Semantic.v(ver: .init(major: 2, minor: 1, patch: 1) )


let major0 = Semantic.Major(integerLiteral: 0)
let major1 = Semantic.Major(integerLiteral: 1)
let major2 = Semantic.Major(integerLiteral: 2)
let major3 = Semantic.Major(integerLiteral: 3)


let minor0 = Semantic.Minor(integerLiteral: 0)
let minor1 = Semantic.Minor(integerLiteral: 1)
let minor2 = Semantic.Minor(integerLiteral: 2)
let minor3 = Semantic.Minor(integerLiteral: 3)


let patch0 = Semantic.Patch(integerLiteral: 0)
let patch1 = Semantic.Patch(integerLiteral: 1)
let patch2 = Semantic.Patch(integerLiteral: 2)
let patch3 = Semantic.Patch(integerLiteral: 3)


// MARK: - Alpha | Beta

let ver_0_0_0_alpha = Semantic.vi(ver: ver_0_0_0.version, ids: [.alpha])
let ver_1_0_0_alpha = Semantic.vi(ver: ver_1_0_0.version, ids: [.alpha])
let ver_2_0_0_alpha = Semantic.vi(ver: ver_2_0_0.version, ids: [.alpha])
let ver_2_1_0_alpha = Semantic.vi(ver: ver_2_1_0.version, ids: [.alpha])
let ver_2_1_1_alpha = Semantic.vi(ver: ver_2_1_1.version, ids: [.alpha])

let ver_0_0_0_beta = Semantic.vi(ver: ver_0_0_0.version, ids: [.beta])
let ver_1_0_0_beta = Semantic.vi(ver: ver_1_0_0.version, ids: [.beta])
let ver_2_0_0_beta = Semantic.vi(ver: ver_2_0_0.version, ids: [.beta])
let ver_2_1_0_beta = Semantic.vi(ver: ver_2_1_0.version, ids: [.beta])
let ver_2_1_1_beta = Semantic.vi(ver: ver_2_1_1.version, ids: [.beta])

let ver_0_0_0_alpha_beta = Semantic.vi(ver: ver_0_0_0.version, ids: [.alpha, .beta])
let ver_1_0_0_alpha_beta = Semantic.vi(ver: ver_1_0_0.version, ids: [.alpha, .beta])
let ver_2_0_0_alpha_beta = Semantic.vi(ver: ver_2_0_0.version, ids: [.alpha, .beta])
let ver_2_1_0_alpha_beta = Semantic.vi(ver: ver_2_1_0.version, ids: [.alpha, .beta])
let ver_2_1_1_alpha_beta = Semantic.vi(ver: ver_2_1_1.version, ids: [.alpha, .beta])


// MARK: - Build

let ver_0_0_0_b1 = Semantic.vb(ver: ver_0_0_0.version, build: [ .init(string: "1")! ])
let ver_1_0_0_b1 = Semantic.vb(ver: ver_1_0_0.version, build: [ .init(string: "1")! ])

let ver_2_0_0_b1 = Semantic.vb(ver: .init(major: 2, minor: 0, patch: 0), build: [ .init(string: "1")! ] )
let ver_2_1_0_b1 = Semantic.vb(ver: .init(major: 2, minor: 1, patch: 0), build: [ .init(string: "1")! ] )
let ver_2_1_1_b1 = Semantic.vb(ver: .init(major: 2, minor: 1, patch: 1), build: [ .init(string: "1")! ] )

let ver_0_0_0_b2 = Semantic.vb(ver: ver_0_0_0.version, build: [ .init(string: "2")! ])
let ver_1_0_0_b2 = Semantic.vb(ver: ver_1_0_0.version, build: [ .init(string: "2")! ])

let ver_2_0_0_b2 = Semantic.vb(ver: .init(major: 2, minor: 0, patch: 0), build: [ .init(string: "2")! ] )
let ver_2_1_0_b2 = Semantic.vb(ver: .init(major: 2, minor: 1, patch: 0), build: [ .init(string: "2")! ] )
let ver_2_1_1_b2 = Semantic.vb(ver: .init(major: 2, minor: 1, patch: 1), build: [ .init(string: "2")! ] )


// MARK: - Alpha | Beta | Build
let ver_0_0_0_alpha_b1 = Semantic.vib(ver: ver_0_0_0.version, ids: [.alpha], build: [ .init(string: "1")! ])
let ver_1_0_0_alpha_b1 = Semantic.vib(ver: ver_1_0_0.version, ids: [.alpha], build: [ .init(string: "1")! ])
let ver_2_0_0_alpha_b1 = Semantic.vib(ver: ver_2_0_0.version, ids: [.alpha], build: [ .init(string: "1")! ])
let ver_2_1_0_alpha_b1 = Semantic.vib(ver: ver_2_1_0.version, ids: [.alpha], build: [ .init(string: "1")! ])
let ver_2_1_1_alpha_b1 = Semantic.vib(ver: ver_2_1_1.version, ids: [.alpha], build: [ .init(string: "1")! ])

let ver_0_0_0_beta_b1 = Semantic.vib(ver: ver_0_0_0.version, ids: [.beta], build: [ .init(string: "1")! ])
let ver_1_0_0_beta_b1 = Semantic.vib(ver: ver_1_0_0.version, ids: [.beta], build: [ .init(string: "1")! ])
let ver_2_0_0_beta_b1 = Semantic.vib(ver: ver_2_0_0.version, ids: [.beta], build: [ .init(string: "1")! ])
let ver_2_1_0_beta_b1 = Semantic.vib(ver: ver_2_1_0.version, ids: [.beta], build: [ .init(string: "1")! ])
let ver_2_1_1_beta_b1 = Semantic.vib(ver: ver_2_1_1.version, ids: [.beta], build: [ .init(string: "1")! ])

let ver_0_0_0_alpha_beta_b1 = Semantic.vib(ver: ver_0_0_0.version, ids: [.alpha, .beta], build: [ .init(string: "1")! ])
let ver_1_0_0_alpha_beta_b1 = Semantic.vib(ver: ver_1_0_0.version, ids: [.alpha, .beta], build: [ .init(string: "1")! ])
let ver_2_0_0_alpha_beta_b1 = Semantic.vib(ver: ver_2_0_0.version, ids: [.alpha, .beta], build: [ .init(string: "1")! ])
let ver_2_1_0_alpha_beta_b1 = Semantic.vib(ver: ver_2_1_0.version, ids: [.alpha, .beta], build: [ .init(string: "1")! ])
let ver_2_1_1_alpha_beta_b1 = Semantic.vib(ver: ver_2_1_1.version, ids: [.alpha, .beta], build: [ .init(string: "1")! ])

let ver_0_0_0_alpha_b2 = Semantic.vib(ver: ver_0_0_0.version, ids: [.alpha], build: [ .init(string: "2")! ])
let ver_1_0_0_alpha_b2 = Semantic.vib(ver: ver_1_0_0.version, ids: [.alpha], build: [ .init(string: "2")! ])
let ver_2_0_0_alpha_b2 = Semantic.vib(ver: ver_2_0_0.version, ids: [.alpha], build: [ .init(string: "2")! ])
let ver_2_1_0_alpha_b2 = Semantic.vib(ver: ver_2_1_0.version, ids: [.alpha], build: [ .init(string: "2")! ])
let ver_2_1_1_alpha_b2 = Semantic.vib(ver: ver_2_1_1.version, ids: [.alpha], build: [ .init(string: "2")! ])

let ver_0_0_0_beta_b2 = Semantic.vib(ver: ver_0_0_0.version, ids: [.beta], build: [ .init(string: "2")! ])
let ver_1_0_0_beta_b2 = Semantic.vib(ver: ver_1_0_0.version, ids: [.beta], build: [ .init(string: "2")! ])
let ver_2_0_0_beta_b2 = Semantic.vib(ver: ver_2_0_0.version, ids: [.beta], build: [ .init(string: "2")! ])
let ver_2_1_0_beta_b2 = Semantic.vib(ver: ver_2_1_0.version, ids: [.beta], build: [ .init(string: "2")! ])
let ver_2_1_1_beta_b2 = Semantic.vib(ver: ver_2_1_1.version, ids: [.beta], build: [ .init(string: "2")! ])

let ver_0_0_0_alpha_beta_b2 = Semantic.vib(ver: ver_0_0_0.version, ids: [.alpha, .beta], build: [ .init(string: "2")! ])
let ver_1_0_0_alpha_beta_b2 = Semantic.vib(ver: ver_1_0_0.version, ids: [.alpha, .beta], build: [ .init(string: "2")! ])
let ver_2_0_0_alpha_beta_b2 = Semantic.vib(ver: ver_2_0_0.version, ids: [.alpha, .beta], build: [ .init(string: "2")! ])
let ver_2_1_0_alpha_beta_b2 = Semantic.vib(ver: ver_2_1_0.version, ids: [.alpha, .beta], build: [ .init(string: "2")! ])
let ver_2_1_1_alpha_beta_b2 = Semantic.vib(ver: ver_2_1_1.version, ids: [.alpha, .beta], build: [ .init(string: "2")! ])
