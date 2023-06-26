import { useEffect, useState } from "react";
import Logo from "./components/ui/Logo/Logo";

import { RecoilRoot, useRecoilState } from "recoil";
import { connection } from "./state/connection/connection.atom";
import { getConnectionInfo } from "./services/connection/getConnectionInfo";
import { RouterProvider } from "react-router-dom";
import router from "./router";
import Init from "./components/init/Init";

function App() {
  return (
    <RecoilRoot>
      <div className="App">
        <Init>
          <RouterProvider router={router} />
        </Init>
      </div>
    </RecoilRoot>
  );
}

export default App;
