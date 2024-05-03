import { create } from "zustand";

interface State {
  clientId: number | undefined;
}

export const useElementStore = create<State>((set) => ({
  clientId: null,
  developerId: null,
}));
