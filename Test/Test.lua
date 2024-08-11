Test = {
    number                   = 1,
    success                  = true,
    exitOnExpectationFailure = false
}

function Test.Header(header)
    header = header or tostring(Test.number)
    io.write(string.format("Test '%s':\n", header))
    Test.number = Test.number + 1
    Test.success = true
end

function Test.Footer()
    if Test.success then
        print("PASSED")
    else
        print("FAILED")
    end
    print("======================")

    if Test.exitOnExpectationFailure and not Test.success then
        os.exit(1)
    end
end

local function PrintComparedObjects(expected, real, PrintFunc)
    if PrintFunc then
        ExpectedPrintFunc = PrintFunc
        RealPrintFunc     = PrintFunc
    else
        ExpectedPrintFunc = (getmetatable(expected) or {}).print
        RealPrintFunc     = (getmetatable(real)     or {}).print

        if not ExpectedPrintFunc and not RealPrintFunc then
            ExpectedPrintFunc = print
            RealPrintFunc     = print
        elseif not ExpectedPrintFunc then
            ExpectedPrintFunc = RealPrintFunc
        else
            RealPrintFunc = ExpectedPrintFunc
        end
    end

    print("==== EXPECTED ====:")
    ExpectedPrintFunc(expected)
    print("==== REAL ====:")
    RealPrintFunc(real)
end

-- is there a nicer way?
local function GetCallerLocationInfo(level)
    _, msg = pcall(error, "", level + 2) -- + 2 means error() + pcall() levels
    return msg
end

-- expceted call stack to be: ... -> your testing function -> Test.Expect function -> reportExpectationError
-- level:                                    3                         2                         1
function Test.reportExpectationError(msg)
    print("\nExpectation failed:")
    io.write("\t"..GetCallerLocationInfo(3).."\n")
    if msg then
        print("\t"..msg)
    end
    Test.success = false
end

-- Expectations

function Test.ExpectTrue(condition, msg)
    if not condition then
        Test.reportExpectationError(msg)
    end
end

function Test.ExpectFalse(condition, msg)
    if condition then
        Test.reportExpectationError(msg)
    end
end

function Test.ExpectEqual(expected, real, msg)
    if expected ~= real then
        Test.reportExpectationError(msg)
        PrintComparedObjects(expected, real)
    end
end

function Test.ExpectNotEqual(expected, real, msg)
    if expected == real then
        Test.reportExpectationError(msg)
        PrintComparedObjects(expected, real)
    end
end

function Test.ExpectContains(container, item, msg)
    if type(container) ~= "table" then
        Test.reportExpectationError(msg..": Container is not a table")
        return
    end

    for k,v in pairs(container) do
        if v == item then
            return
        end
    end

    Test.reportExpectationError(msg)
    io.write("Expected to find item: "); ((getmetatable(item) or {}).print or print)(item)
    print("Among:")
    for k,v in pairs(container) do
        ((getmetatable(v) or {}).print or print)(v)
    end
end

function Test.ExpectContainsKey(container, key, msg)
    if type(container) ~= "table" then
        Test.reportExpectationError(msg..": Container is not a table")
        return
    end

    for k,v in pairs(container) do
        if k == key then
            return
        end
    end

    Test.reportExpectationError(msg)
    io.write("Expected to find key: "); ((getmetatable(key) or {}).print or print)(key)
    print("Among:")
    for k,v in pairs(container) do
        ((getmetatable(k) or {}).print or print)(k)
    end
end

-- Assertions

-- expceted call stack to be: ... -> your testing function -> Test.Expect function -> reportAssertionError
-- level:                                    3                         2                       1
function Test.reportAssertionError(msg)
    print("\nAssertion failed:")
    io.write("\t"..GetCallerLocationInfo(3).."\n")
    if msg then
        print("\t"..msg)
    end
end

local function AssertionFooter()
    Test.success = false
    Test.Footer()
    os.exit(1)
end

function Test.AssertTrue(condition, msg)
    if not condition then
        Test.reportAssertionError(msg)
    end
    AssertionFooter()
end

function Test.AssertFalse(condition, msg)
    if condition then
        Test.reportAssertionError(msg)
    end
    AssertionFooter()
end

function Test.AssertEqual(expected, real, msg)
    if expected ~= real then
        Test.reportAssertionError(msg)
        PrintComparedObjects(expected, real)
    end
    AssertionFooter()
end

function Test.AssertNotEqual(expected, real, msg)
    if expected == real then
        Test.reportAssertionError(msg)
        PrintComparedObjects(expected, real)
    end
    AssertionFooter()
end

function Test.AssertContains(container, item, msg)
    if type(container) ~= "table" then
        Test.reportAssertionError(msg..": Container is not a table")
        return
    end

    for k,v in pairs(container) do
        if v == item then
            return
        end
    end

    Test.reportAssertionError(msg)
    io.write("Expected to find item: "); ((getmetatable(item) or {}).print or print)(item)
    print("Among:")
    for k,v in pairs(container) do
        ((getmetatable(v) or {}).print or print)(v)
    end
    AssertionFooter()
end

function Test.AssertContainsKey(container, key, msg)
    if type(container) ~= "table" then
        Test.reportAssertionError(msg..": Container is not a table")
        return
    end

    for k,v in pairs(container) do
        if k == key then
            return
        end
    end

    Test.reportAssertionError(msg)
    io.write("Expected to find key: "); ((getmetatable(key) or {}).print or print)(key)
    print("Among:")
    for k,v in pairs(container) do
        ((getmetatable(k) or {}).print or print)(k)
    end
    AssertionFooter()
end
