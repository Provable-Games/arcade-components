import { useEffect, useMemo, useState } from "react";
import { Routes, Route } from "react-router-dom";
import { useAccount } from "@starknet-react/core";
import Header from "@/components/Header";
import ScreenMenu from "@/components/ScreenMenu";
import useUIStore, { ScreenPage } from "@/hooks/useUIStore";
import { Menu } from "@/lib//types";
import Overview from "@/containers/Overview";
import MyTournaments from "@/containers/MyTournaments";
import Create from "@/containers/Create";
import RegisterToken from "@/containers/RegisterToken";
import Tournament from "@/containers/Tournament";
import Guide from "@/containers/Guide";
import LootSurvivor from "@/containers/LootSurvivor";
import InputDialog from "@/components/dialogs/inputs/InputDialog";
import {
  useGetTournamentCountsQuery,
  useGetTokensQuery,
} from "@/hooks/useSdkQueries";
import { useDojoSystem } from "@/hooks/useDojoSystem";
import { useSystemCalls } from "@/useSystemCalls";

function App() {
  const { account } = useAccount();
  const tournament_mock = useDojoSystem("tournament_mock");
  const { getEthBalance, getLordsBalance } = useSystemCalls();
  const [tokenBalance, setTokenBalance] = useState<Record<string, bigint>>({});

  useGetTournamentCountsQuery(tournament_mock.contractAddress);
  useGetTokensQuery();

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
        label: "My Tournaments",
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
      {
        id: 6,
        label: "Loot Survivor",
        screen: "loot survivor" as ScreenPage,
        path: "/loot-survivor",
        disabled: false,
      },
    ],
    []
  );
  const menuDisabled = useMemo(
    () => [false, false, false, false, false, false],
    []
  );

  const getTestETHBalance = async () => {
    const balance = await getEthBalance(account?.address!);
    if (balance !== undefined) {
      setTokenBalance((prev) => ({
        ...prev,
        eth: balance as bigint,
      }));
    }
  };

  const getTestLordsBalance = async () => {
    const balance = await getLordsBalance(account?.address!);
    if (balance !== undefined) {
      setTokenBalance((prev) => ({
        ...prev,
        lords: balance as bigint,
      }));
    }
  };

  useEffect(() => {
    if (account) {
      getTestETHBalance();
      getTestLordsBalance();
    }
  }, [account]);

  useEffect(() => {
    if (account) {
      getTestETHBalance();
      getTestLordsBalance();
    }
  }, [account]);

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
        <Header
          ethBalance={tokenBalance.eth}
          lordsBalance={tokenBalance.lords}
        />
        <div className="w-full h-1 sm:h-6 sm:my-2 bg-terminal-green text-terminal-black px-4" />
        <ScreenMenu buttonsData={menuItems} disabled={menuDisabled} />
        <Routes>
          <Route path="/" element={<Overview />} />
          <Route path="/my-tournaments" element={<MyTournaments />} />
          <Route path="/create" element={<Create />} />
          <Route path="/register-token" element={<RegisterToken />} />
          <Route path="/tournament/:id" element={<Tournament />} />
          <Route path="/guide" element={<Guide />} />
          <Route path="/loot-survivor" element={<LootSurvivor />} />
        </Routes>
        {inputDialog && <InputDialog />}
      </div>
    </div>
  );
}

export default App;
