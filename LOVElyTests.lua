local tests = {}

---@alias TestCase fun(subname: string, subtest: fun(test_case: TestCase))

---@class LOVElyTests
local TestSystem = {}
TestSystem.__index = TestSystem

--- Creates a new TestHelper instance
---@return LOVElyTests
function TestSystem.new()
    local self = setmetatable({
        results = {} -- Stores hierarchical test results
    }, TestSystem)
    return self
end

--- Checks if a table is empty
---@param tbl table
---@return boolean
function TestSystem:is_empty_table(tbl)
    return type(tbl) == "table" and next(tbl) == nil
end

--- Runs a test case internally
---@param name string
---@param test function|nil
function TestSystem:run(name, test)
    local entry = {name = name, success = true, subtests = {}}
    table.insert(self.results, entry)

    if test then
        local success, err = pcall(function()
            test(function(subname, subtest)
                local subhelper = TestSystem.new()
                subhelper.results = entry.subtests
                subhelper:run(subname, subtest)
                -- Propagate failure to parent if any subtest fails
                if not subhelper.results[#subhelper.results].success then
                    entry.success = false
                end
            end)
        end)

        if not success then
            entry.success = false
            entry.error = err
        end
    end
end

--- Prints test results recursively
---@param results table
---@param level number
local function print_results(results, level)
    level = level or 0
    local indent = string.rep("  ", level)
    for _, result in ipairs(results) do
        if result.success then
            print(indent .. "- " .. result.name .. " [Success]")
        else
            print(indent .. "- " .. result.name .. " [Failure] (" .. (result.error or "Subtest failed") .. ")")
        end

        if #result.subtests > 0 then
            print_results(result.subtests, level + 1)
        end
    end
end

--- Runs all registered tests.
-- Now each test function receives a single "test_case" function used to register subtests.
function TestSystem.run_all()
    for name, test_func in pairs(tests) do
        print("Running test: " .. name)
        local helper = TestSystem.new()
        ---@type TestCase
        local test_case = function(subname, subtest)
            helper:run(subname, subtest)
        end
        test_func(test_case)
        print_results(helper.results, 1)
    end

    -- Clear tests
    tests = {}
end

--- Registers a new test.
---@param name string
---@param test_func fun(test_case: TestCase)
function TestSystem.register(name, test_func)
    tests[name] = test_func
end

return TestSystem