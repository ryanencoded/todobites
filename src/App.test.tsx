// App.test.tsx
import { render, screen, act } from "@testing-library/react";
import App from "./App";

describe("App", () => {
  it("renders App component with mocked data", async () => {
    // Mock the fetch function for success scenario
    jest.spyOn(global, "fetch").mockResolvedValueOnce({
      ok: true,
      status: 200,
      json: () =>
        Promise.resolve([
          {
            userId: 1,
            id: 1,
            title: "Mocked Todo",
            completed: false,
          },
        ]),
    } as Response);

    render(<App />);
    
    const linkElement = await screen.findByText(/Mocked Todo/i);
    expect(linkElement).toBeTruthy();
  });

  it("renders error message when fetch fails", async () => {
    // Mock the fetch function to simulate an error
    const mockError = new Error("Failed to fetch");
    jest.spyOn(global, "fetch").mockRejectedValueOnce(mockError);
  
    // Create a spy for console.error to capture the error
    const consoleErrorSpy = jest.spyOn(console, 'error').mockImplementation(() => {});
  
    // Render the component
    render(<App />);
  
    // Assert that the error message is displayed
    const errorMessage = await screen.findByText(
      /Failed to fetch todos\. Please try again\./i
    );
  
    // Assert against the error without logging it to the console
    expect(errorMessage).toBeTruthy();
  
    // Assert that console.error was called with the expected error message
    expect(consoleErrorSpy).toHaveBeenCalledWith(
      "Error fetching todos:",
      mockError.message
    );
  
    // Restore the original console.error implementation after the test
    consoleErrorSpy.mockRestore();
  });

  it("renders error message and logs detailed error when fetch response status is not OK", async () => {
    // Mock the fetch function for a failed scenario
    jest.spyOn(global, "fetch").mockResolvedValueOnce({
      ok: false,
      status: 404,
      statusText: "Not Found",
      json: () =>
        Promise.resolve({
          message: "Resource not found",
        }),
    } as Response);

    // Create a spy for console.error to capture the error
    const consoleErrorSpy = jest.spyOn(console, 'error').mockImplementation(() => {});

    await act(async () => {
      render(<App />);
      
      // Allow some time for asynchronous operations to complete
      await new Promise(resolve => setTimeout(resolve, 0));
    });

    // Assert that the error message is rendered
    const errorMessage = screen.getByText(
      /Failed to fetch todos\. Please try again\./i
    );
  
    expect(errorMessage).toBeTruthy();

    // Assert that console.error was called with the expected error message
    expect(consoleErrorSpy).toHaveBeenCalledWith(
      "Error fetching todos:",
      expect.stringContaining("Failed to fetch todos. Status: 404")
    );

    // Restore the original console.error implementation after the test
    consoleErrorSpy.mockRestore();
  });

  it("renders todo as completed", async () => {
    // Mock the fetch function for success scenario with completed todo
    jest.spyOn(global, "fetch").mockResolvedValueOnce({
      ok: true,
      status: 200,
      json: () =>
        Promise.resolve([
          {
            userId: 1,
            id: 1,
            title: "Mocked Todo",
            completed: true,
          },
        ]),
    } as Response);

    render(<App />);

    const completedStatus = await screen.findByText(/Completed/i);
    expect(completedStatus).toBeTruthy();
  });

  it("renders todo as incomplete", async () => {
    // Mock the fetch function for success scenario with incomplete todo
    jest.spyOn(global, "fetch").mockResolvedValueOnce({
      ok: true,
      status: 200,
      json: () =>
        Promise.resolve([
          {
            userId: 1,
            id: 1,
            title: "Mocked Todo",
            completed: false,
          },
        ]),
    } as Response);

    render(<App />);

    const incompleteStatus = await screen.findByText(/Incomplete/i);
    expect(incompleteStatus).toBeTruthy();
  });
});
