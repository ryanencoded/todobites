import { useEffect, useState, useCallback } from "react";

interface ITodo {
  id: number;
  title: string;
  completed: boolean;
}

function App() {
  const [todos, setTodos] = useState<ITodo[]>([]);
  const [error, setError] = useState<string | null>(null);

  const fetchData = useCallback(async () => {
    try {
      
      const response = await fetch("https://jsonplaceholder.typicode.com/todos");

      if (!response.ok) {
        throw new Error(`Failed to fetch todos. Status: ${response.status}`);
      }

      const data = await response.json();
      setTodos(data);
      setError(null);
    } catch (error: any) {
      console.error("Error fetching todos:", error.message);
      setError("Failed to fetch todos. Please try again.");
    }
  }, []);

  useEffect(() => {
    fetchData();
  }, [fetchData]);

  return (
    <div className="bg-slate-200 container mx-auto px-4">
      <h1 className="text-3xl underline p-2">Your Todo's</h1>
      {error ? (
        <p className="text-red-500">{error}</p>
      ) : (
        <ul>
          {todos.map((todo) => (
            <li key={todo.id} className="p-2">
              <h1 className="font-bold">{todo.title}</h1>
              <p className={todo.completed ? 'text-green-400' : 'text-red-400'}>
                {todo.completed ? 'Completed' : 'Incomplete'}
              </p>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}

export default App;
