TEST_Number = 1

function TEST_Header(header)
    header = header or tostring(TEST_Number)
    io.write(string.format("Test '%s': ", header))
    TEST_Number = TEST_Number + 1
    TEST_res = true
end

function TEST_Footer()
    if TEST_res then
        print("PASSED")
    else
        print("FAILED")
    end
    print("======================")

    if TEST_ExitOnFail and not TEST_res then os.exit(1) end
end

function TEST_PrintObjects(expected, real, printFunc)
    printFunc = printFunc or print

    print("Expected:")
    printFunc(expected)
    print("Real:")
    printFunc(real)
end

function ExpectTrue(cond, msg)
    if not cond then
        print("\nExpectation failed:")
        print("\t" .. (msg or ""))
        TEST_res = false
    end
end

function ExpectFalse(cond, msg)
    ExpectTrue(not cond, msg)
end

function ExpectSame(o1, o2, msg)
    ExpectTrue(o1 == o2, msg)
end

function ExpectNotSame(o1, o2, msg)
    ExpectFalse(o1 == o2, msg)
end

function ExpectEqual(o1, o2, equalsFunc, msg)
    ExpectTrue(equalsFunc(o1, o2), msg)
end

function ExpectNotEqual(o1, o2, equalsFunc, msg)
    ExpectFalse(equalsFunc(o1, o2), msg)
end