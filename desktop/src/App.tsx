import { useState } from "react";
import Logo from "./components/ui/Logo/Logo";

function App() {
  const [count, setCount] = useState(0);
  return (
    <div className="App">
      <span>Hello Flify!</span>

      <Logo isAnimated width={150} />
    </div>
  );
}

export default App;
