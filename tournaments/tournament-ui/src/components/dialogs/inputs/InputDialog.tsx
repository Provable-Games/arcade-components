import useUIStore from "@/hooks/useUIStore";
import CreatePrizeDialog from "@/components/dialogs/inputs/CreateTournamentPrize";
import AddPrizeDialog from "@/components/dialogs/inputs/AddPrize";
import GatedTokenDialog from "@/components/dialogs/inputs/GatedToken";
import GatedAddressesDialog from "@/components/dialogs/inputs/GatedAddresses";
import GatedTournamentsDialog from "@/components/dialogs/inputs/GatedTournament";
import EntryFeeDialog from "@/components/dialogs/inputs/EntryFee";

const InputDialog = () => {
  const { inputDialog } = useUIStore();

  if (!inputDialog) return null;

  // Map dialog types to their components
  const dialogComponents: Record<string, React.FC<any>> = {
    "create-tournament-prize": CreatePrizeDialog,
    "add-prize": AddPrizeDialog,
    "gated-token": GatedTokenDialog,
    "gated-addresses": GatedAddressesDialog,
    "gated-tournaments": GatedTournamentsDialog,
    "entry-fee": EntryFeeDialog,
    // ... other dialogs
  };

  const DialogComponent = dialogComponents[inputDialog.type];
  if (!DialogComponent) return null;

  return <DialogComponent {...(inputDialog.props || {})} />;
};

export default InputDialog;
