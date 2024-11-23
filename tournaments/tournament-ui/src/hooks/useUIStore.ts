import { create } from "zustand";
import { FormData } from "../lib/types";
import { CairoOption, CairoOptionVariant } from "starknet";

export type ScreenPage =
  | "overview"
  | "my tournaments"
  | "create"
  | "register token"
  | "guide";

export type InputDialog =
  | "gated token"
  | "gated tournaments"
  | "gated addresses"
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
  formData: FormData;
  setFormData: (value: FormData) => void;
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
  formData: {
    tournamentName: "",
    tournamentDescription: "",
    startTime: undefined,
    endTime: undefined,
    submissionPeriod: 0,
    scoreboardSize: 0,
    gatedType: new CairoOption(CairoOptionVariant.None),
    entryFee: new CairoOption(CairoOptionVariant.None),
    prizes: [],
  },
  setFormData: (value: FormData) => set({ formData: value }),
}));

export default useUIStore;
