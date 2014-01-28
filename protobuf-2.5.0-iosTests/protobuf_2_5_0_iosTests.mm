//
//  protobuf_2_5_0_iosTests.m
//  protobuf-2.5.0-iosTests
//
//  Created by Keiji Oenoki on 1/27/14.
//  Copyright (c) 2014 Keiji Oenoki. All rights reserved.
//

#import <XCTest/XCTest.h>
#include <fstream>
#include "addressbook.pb.h"

using namespace std;

@interface protobuf_2_5_0_iosTests : XCTestCase

@end

@implementation protobuf_2_5_0_iosTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *filename = [NSString stringWithFormat:@"%@/addressbook.dat", documentDirectory];
    
    ifstream input([filename UTF8String], ios::in | ios::binary);
    
    tutorial::AddressBook address_book;
    bool succeeded = address_book.ParseFromIstream(&input);

    int count = address_book.person_size();
    if (count > 0) {
        XCTAssert(succeeded, "ParseFromIstream is expected to succeed");

        tutorial::Person p = address_book.person(0);
        XCTAssert(p.id() == 42, @"All person have ID of 42");
        XCTAssert(p.name() == "raymond" , @"All person should be named Raymond");
    }
    
    tutorial::Person *person = address_book.add_person();
    person->set_id(42);
    person->set_name("raymond");
    person->set_email("raymond@gmail.com");
    
    tutorial::Person_PhoneNumber *pn = person->add_phone();
    pn->set_type(tutorial::Person_PhoneType_WORK);
    pn->set_number("12345678");
    
    fstream output([filename UTF8String], ios::out | ios::trunc | ios::binary);
    succeeded = address_book.SerializeToOstream(&output);
    XCTAssert(succeeded, @"SerializeToOstream is expected to succeed");
}

@end
