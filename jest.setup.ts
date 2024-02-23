// setupTests.ts
import "@testing-library/jest-dom";

// global setup for tests here
beforeAll(() => {
  // Mock the fetch function
  global.fetch = jest.fn();
});

// clean up resources after all tests
afterAll(() => {
  // Restore the original fetch function after all tests
  (global.fetch as jest.Mock).mockReset();
});
