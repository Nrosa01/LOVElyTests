# LOVELy Tests

This is my test solution. Other solutions are more complex or don't work as I want. This system has room for improvement but as of now I don't need more than that. Check [main.lua](main.lua) for an example on how to use this system

# Show, don't tell

Example code from main.lua file

```lua
local LOVElyTests = require("LOVElyTests")

function love.load() 
    LOVElyTests.register("Test 1", function(test_case)
        test_case("Subtest 1", function(test_case)
            test_case("Test 1", function ()
                assert(true)
            end)

            test_case("Test 2", function ()
                assert(false, "This is a failure")
            end)
        end)
        test_case("Subtest 2", function(test_case)
            assert(true)
        end)
    end)

    LOVElyTests.register("Nested Test", function(test_case)
        test_case("Level 1", function(test_case)
            test_case("Level 2", function(test_case)
                test_case("Level 3", function(test_case)
                    test_case("Level 4", function()
                        assert(true, "Deep level passed")
                    end)

                    test_case("Level 4", function()
                        assert(false, "Deep level failed")
                    end)
                end)
            end)
        end)
    end)

    LOVElyTests.run_all()
end
```

Output:

```
Running test: Nested Test
  - Level 1 [Failure] (Subtest failed)
    - Level 2 [Failure] (Subtest failed)
      - Level 3 [Failure] (Subtest failed)
        - Level 4 [Success]
        - Level 4 [Failure] (main.lua:28: Deep level failed)
Running test: Test 1
  - Subtest 1 [Failure] (Subtest failed)
    - Test 1 [Success]
    - Test 2 [Failure] (main.lua:11: This is a failure)
  - Subtest 2 [Success]
  ```

# Install

Just drop [LOVElyTests.lua](LOVElyTests.lua) wherever you prefer in your project