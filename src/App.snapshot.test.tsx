// App.snapshot.test.tsx
import { render, act } from "@testing-library/react";
import App from "./App";

test('renders App component snapshot', async () => {
  (global.fetch as jest.Mock).mockResolvedValueOnce({
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
  });

  await act(async () => {
    const { asFragment } = render(<App />);
    expect(asFragment()).toMatchSnapshot();
  });
});