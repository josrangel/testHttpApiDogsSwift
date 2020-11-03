//
//  httpApiDogsTests.swift
//  httpApiDogsTests
//
//  Created by KMMX on 03/11/20.
//

import XCTest
@testable import httpApiDogs

class AsynchronousTestCase: XCTestCase {

    var expectation : XCTestExpectation!
    var timeout : TimeInterval!
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        expectation = self.expectation(description: "El servidor responde en un tiempo razonable")
        timeout = 5
        
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNoServerResponse() {
        let url = URL(string: "some")!
        
        URLSession.shared.dataTask(with: url){(data,response, error) in
            defer { self.expectation.fulfill() }
            
            //ya es la respuesta
            XCTAssertNil(data)
            XCTAssertNil(response)
            XCTAssertNotNil(error)
            print(error ?? "no error")
        }.resume()
        waitForExpectations(timeout: timeout)
    }
    
    func testServerResponse() {
        let url = URL(string: "https://dogpatchserver.herokuapp.com/api/v1/dogs")!
        
        URLSession.shared.dataTask(with: url){(data,response, error) in
            defer { self.expectation.fulfill() }
            
            //ya es la respuesta
            XCTAssertNotNil(data)
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            print(error ?? "no error")
        }.resume()
        waitForExpectations(timeout: timeout)
    }
    
    func testDecodeResponseDogs() {
        let url = URL(string: "https://dogpatchserver.herokuapp.com/api/v1/dogs")!
        
        URLSession.shared.dataTask(with: url){(data,response, error) in
            defer { self.expectation.fulfill() }
            
            //ya es la respuesta
            XCTAssertNil(error)
            do{
                let response = try XCTUnwrap(response as? HTTPURLResponse)
                XCTAssertEqual(response.statusCode,200)
                
                let data = try XCTUnwrap(data)
                XCTAssertNoThrow( try JSONDecoder().decode([Dog].self,  from: data))
                
            } catch { }
        }.resume()
        waitForExpectations(timeout: timeout)
    }
    
    func testDecodeResponse404Cats() {
        let url = URL(string: "https://dogpatchserver.herokuapp.com/api/v1/cats")!
        
        URLSession.shared.dataTask(with: url){(data,response, error) in
            defer { self.expectation.fulfill() }
            
            //ya es la respuesta
            XCTAssertNil(error)
            do{
                let response = try XCTUnwrap(response as? HTTPURLResponse)
                XCTAssertEqual(response.statusCode,404)
                
                //let data = try XCTUnwrap(data)
                /*XCTAssertThrowsError( try JSONDecoder().decode([Dog].self,  from: data!) ) { error in
                    guard case DecodingError.typeMismatch = error else {
                        XCTFail("\(error)")
                        return
                    }
                }*/
                
            } catch { }
        }.resume()
        waitForExpectations(timeout: timeout)
    }
    
    func testDecodeDogtor(){
        struct OrthopedicDogtor: Decodable{
            
            let id: String
            let sellerID: String
            let gender: String
            let about: String
            let birthday: Date
            let breed: String
            let breederRating: Double
            let cost: Decimal
            let created: Date
            let imageURL: URL
            let name: String
            let bones: [Int]
        }
        let url = URL(string: "https://dogpatchserver.herokuapp.com/api/v1/dogs")!
        
        URLSession.shared.dataTask(with: url){(data,response, errorResponse) in
            defer { self.expectation.fulfill() }
            
            //ya es la respuesta
            XCTAssertNil(errorResponse)
            do{
                let response = try XCTUnwrap(response as? HTTPURLResponse)
                XCTAssertEqual(response.statusCode,200)
                
                let data = try XCTUnwrap(data)
                do{
                    _ = try JSONDecoder().decode([OrthopedicDogtor].self,  from: data);
                }catch{
                    switch error {
                    case DecodingError.keyNotFound(let key,_):
                        XCTAssertEqual(key.stringValue,"bones")
                    default:
                        XCTFail("\(error)")
                    }
                }
                
                
            } catch { }
        }.resume()
        waitForExpectations(timeout: timeout)
    }
}
