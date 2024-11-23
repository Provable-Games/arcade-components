import { useMemo } from "react";
import { Routes, Route } from "react-router-dom";
import Header from "./components/Header";
import ScreenMenu from "./components/ScreenMenu";
import useUIStore, { ScreenPage } from "./hooks/useUIStore";
import { Menu } from "./lib//types";
import Overview from "./containers/Overview";
import Create from "./containers/Create";
import RegisterToken from "./containers/RegisterToken";
import Tournament from "./containers/Tournament";
import InputDialog from "./components/dialogs/inputs/InputDialog";
import { useDojo } from "./DojoContext";
import { Models } from "./generated/models.gen";
import { getEntityIdFromKeys } from "@dojoengine/utils";
import useModel from "./useModel";

function App() {
  const {
    account,
    setup: { client },
  } = useDojo();

  const entityId = useMemo(
    () => getEntityIdFromKeys([BigInt(account?.account.address)]),
    [account?.account.address]
  );

  const tournament = useModel(entityId, Models.TournamentModel);

  const { inputDialog } = useUIStore();

  const menuItems: Menu[] = useMemo(
    () => [
      {
        id: 1,
        label: "Overview",
        screen: "overview" as ScreenPage,
        path: "/",
        disabled: false,
      },
      {
        id: 2,
        label: "My Tournament",
        screen: "my tournaments" as ScreenPage,
        path: "/my-tournaments",
        disabled: false,
      },
      {
        id: 3,
        label: "Create",
        screen: "create" as ScreenPage,
        path: "/create",
        disabled: false,
      },
      {
        id: 4,
        label: "Register Token",
        screen: "register token" as ScreenPage,
        path: "/register-token",
        disabled: false,
      },
      {
        id: 5,
        label: "Guide",
        screen: "guide" as ScreenPage,
        path: "/guide",
        disabled: false,
      },
    ],
    []
  );
  const menuDisabled = useMemo(
    () => [false, false, false, false, false, false],
    []
  );
  return (
    <div
      suppressHydrationWarning={false}
      className="min-h-screen overflow-hidden text-terminal-green bg-terminal-black bezel-container w-full"
    >
      <img
        src="/crt_green_mask.png"
        alt="crt green mask"
        className="absolute w-full pointer-events-none crt-frame hidden sm:block"
      />
      <div
        className={`min-h-screen container mx-auto flex flex-col sm:pt-8 sm:p-8 lg:p-10 2xl:p-20 `}
      >
        <Header ethBalance={0n} lordsBalance={0n} />
        <div className="w-full h-1 sm:h-6 sm:my-2 bg-terminal-green text-terminal-black px-4" />
        <ScreenMenu buttonsData={menuItems} disabled={menuDisabled} />
        <Routes>
          <Route path="/" element={<Overview />} />
          <Route path="/create" element={<Create />} />
          <Route path="/register-token" element={<RegisterToken />} />
          <Route path="/tournament/:id" element={<Tournament />} />
        </Routes>
        {inputDialog && <InputDialog />}
      </div>
    </div>
  );
}

export default App;
