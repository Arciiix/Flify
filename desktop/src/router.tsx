import { createBrowserRouter, createHashRouter } from "react-router-dom";
import HomePage from "./pages/Home/HomePage";
import AppPage from "./pages/App/AppPage";

const router = createHashRouter([
  {
    path: "/",
    element: <HomePage />,
  },
  {
    path: "/app",
    element: <AppPage />,
  },
  {
    path: "/add",
    element: <HomePage alreadyConnected />,
  },
]);

export default router;
