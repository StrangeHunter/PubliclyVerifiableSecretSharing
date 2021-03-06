//
//  MathFunctionsTest.swift
//  PVSS
//
//  Created by Fabio Tacke on 27.04.17.
//
//

import XCTest
import BigInt
import CryptoSwift
import PVSS
import Bignum

class MathFunctionsTest: XCTestCase {
  
  func testPrimeGenerator() {
    for _ in 0...10 {
      XCTAssert(BigUInt.randomPrime(length: 128).isPrime(), "Generated integer that is not prime.")
    }
  }
  
  func testDLEQ() {
    let g1: Bignum = 8443
    let h1: Bignum = 531216
    let g2: Bignum = 1299721
    let h2: Bignum = 14767239

    let w: Bignum = 81647
    let q: Bignum = 15487469
    let alpha: Bignum = 163027
    let length: Int = 64
    
    var dleq: DLEQ = DLEQ(g1: g1, h1: h1, g2: g2, h2: h2, length: length, q: q, alpha: alpha, w: w)
    
    let a1: Bignum = 14735247
    let a2: Bignum = 5290058
    
    XCTAssertEqual(a1, dleq.a1)
    XCTAssertEqual(a2, dleq.a2)
    
    let c: Bignum = 127997
    dleq.c = c
    
    let r: Bignum = 10221592
    
    XCTAssertEqual(r, dleq.r!)
    
    XCTAssertEqual(a1, (mod_exp(dleq.g1, dleq.r!, dleq.q) * mod_exp(h1, dleq.c!, dleq.q)) % q)
    XCTAssertEqual(a2, (mod_exp(dleq.g2, dleq.r!, dleq.q) * mod_exp(h2, dleq.c!, dleq.q)) % q)
  }
  
  func testPolynomial() {
    let q: Bignum = 15486967
    let coefficients: [Bignum] = [105211, 1548877	, 892134, 3490857, 324, 14234735]
    let x: Bignum = 278
    
    let polynomial = Polynomial(coefficients: coefficients)

    XCTAssertEqual(polynomial.getValue(x: x) % q, 4115179)
  }
  
  func testHashing() {
    let value1: Bignum = Bignum("43589072349864890574839")
    let value2: Bignum = Bignum("14735247304952934566")
    
    var digest = SHA2(variant: .sha256)
    let _ = try! digest.update(withBytes: Array(value1.description.data(using: .utf8)!))
    let _ = try! digest.update(withBytes: Array(value2.description.data(using: .utf8)!))
    let result = try! digest.finish()
    
    XCTAssertEqual(result.toHexString(), "e25e5b7edf4ea66e5238393fb4f183e0fc1593c69a522f9255a51bd0bc2b7ba7")
    XCTAssertEqual(Bignum(hex: result.toHexString()), Bignum("102389418883295205726805934198606438410316463205994911160958467170744727731111"))
  }
  
  func testXor() {
    let a = BigUInt(1337)
    let b = BigUInt(42)
    let xor = a ^ b
    
    XCTAssertEqual(xor, BigUInt(1299))
  }
  
  func testLagrange() {
    let lagrangeCoefficient = PVSSInstance.lagrangeCoefficient(i: 3, values: [1, 3, 4])
    
    XCTAssertEqual(lagrangeCoefficient.numerator, 4)
    XCTAssertEqual(lagrangeCoefficient.denominator, -2)
  }
}
