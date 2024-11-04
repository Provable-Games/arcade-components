import { create } from "zustand";

export type ScreenPage =
  | "overview"
  | "my tournaments"
  | "create"
  | "register token"
  | "guide";

export type InputDialog =
  | "gated token"
  | "gated tournaments"
  | "entry fee"
  | "prize";

type State = {
  username: string;
  setUsername: (value: string) => void;
  showProfile: boolean;
  setShowProfile: (value: boolean) => void;
  screen: ScreenPage;
  setScreen: (value: ScreenPage) => void;
  inputDialog: InputDialog | null;
  setInputDialog: (value: InputDialog | null) => void;
};

const useUIStore = create<State>((set) => ({
  username: "",
  setUsername: (value: string) => set({ username: value }),
  showProfile: false,
  setShowProfile: (value: boolean) => set({ showProfile: value }),
  screen: "overview",
  setScreen: (value: ScreenPage) => set({ screen: value }),
  inputDialog: null,
  setInputDialog: (value: InputDialog | null) => set({ inputDialog: value }),
}));

export default useUIStore;
