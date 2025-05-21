# Welcome to Mitigate Academy Entry Task! 🚀

This project is designed to introduce you to Ruby and test your programming skills through a test-driven development approach.

## Prerequisites

### Ruby Installation

You'll need Ruby (version >= 3.0) installed on your system.

For detailed installation instructions for your operating system, visit:
[Ruby Installation Guide](https://www.ruby-lang.org/en/documentation/installation/)

_Tip_: Use a version manager like `asdf`, `mise`, or `rvm` to manage your Ruby installations. This allows you to easily switch between different Ruby versions for different projects.

## Getting Started

1. Clone this repository locally:

   ```bash
   git clone [repository-url]
   cd academy-entry-task
   ```

2. Run the tests to see which ones are failing:
   ```bash
   bin/test
   ```

## The Challenge

Your task is to make all the failing tests pass by fixing the code in the `app` directory. The project simulates a vending machine system with various components:

- `vending_machine.rb`: Main vending machine logic and the entry point of the program
- `coin_manager.rb`: Handles currency operations
- `display_manager.rb`: Manages display output
- `product_catalog.rb`: Manages product inventory
- `transaction_processor.rb`: Processes transactions

### Important Rules

- You are NOT allowed to modify any test files
- Focus on fixing the failing tests by modifying only the implementation files in the `app` directory

### Workflow

1. Run the tests to see which ones are failing:

   ```bash
   bin/test
   ```

   To run a specific test, provide the test name as an argument:

   ```bash
   bin/test test_01_vending_machine_class_exists
   ```

2. Fix tests one by one or in logical groups by the order as they are presented
3. Commit your changes with meaningful messages:

   ```bash
   git add .
   git commit -m "fix: vending machine class definition"
   ```

4. Once all tests are passing (or you've done your best), push your changes:
   ```bash
   git push origin fix/test-group-name
   ```

### Tips

- Read the test file carefully - many test examples include helpful comments with links to documentation
- Look for the "NOTE:" comments in tests for hints and guidance. Though, not all tests will have them. You must use your own judgment to fix the code and make the tests pass.
- Focus on one test at a time in orderly fashion, as fixing later tests often depends on resolving earlier ones.
- Use Git commits to track your progress and organize your work
- It's ok if not all tests may be passable - focus on fixing what you can

## Example

Let's walk through fixing the first failing test to give you an idea of the workflow.

1. First, run the tests to see what's failing:

   ```bash
   bin/test
   ```

   You'll see output similar to this:

   ```
   Run options: --seed 60284

   # Running:

   EEEEEEEEEEEEEEEEEEEEEEEEEEEEE

   Finished in 0.003271s, 8865.7903 runs/s, 0.0000 assertions/s.

     1) Error:
   VendingMachineTest#test_01_vending_machine_class_exists:
   NameError: uninitialized constant VendingMachine
       test/vending_machine_test.rb:11:in 'VendingMachineTest#setup'
   ```

2. Let's analyze the error message:

   - The test `test_01_vending_machine_class_exists` is failing
   - The error is `NameError: uninitialized constant VendingMachine`
   - This means Ruby can't find a class named `VendingMachine`

3. Looking at the test file location (`test/vending_machine_test.rb:11`), we can see this is happening in the test's setup phase.

4. The main class should be defined in `app/vending_machine.rb`. Upon inspection, we might find that the class is defined incorrectly, perhaps as:

   ```ruby
   class Machine
     # ...
   end
   ```

5. The fix is simple - we need to rename the class to match what the test expects:

   ```ruby
   class VendingMachine
     # ...
   end
   ```

6. Run the tests again to verify:

   ```bash
   bin/test
   ```

   You should see the first test passing (but probably others still failing):

   ```
   Run options: --seed 55695

   # Running:

   .FE.EEEEEEEEEEEEEEEEEEEEEE..E

   Finished in 0.003881s, 7472.3010 runs/s, 3349.6522 assertions/s.
   ```

   Notice how the first symbol is now a dot (`.FE.`), indicating our first test is now passing!

7. Commit your changes to track progress:

   ```bash
   git add app/vending_machine.rb
   git commit -m "fix: add vending machine class definition"
   ```

8. Continue with the next failing test following the same pattern:
   - Read the error message carefully
   - Locate the relevant file
   - Make the minimum change needed to make the test pass
   - Run the tests to verify

## Submission

1. Push your code to a new public repository on GitHub
2. Send an email to akademija@mitigate.dev with your repository URL

Good luck! 🍀
