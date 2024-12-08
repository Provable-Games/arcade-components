import PrizeDialog from "./Prize";
import { DialogWrapper } from "./DialogWrapper";
import useUIStore from "@/hooks/useUIStore";
import { Prize } from "@/lib/types";

const CreatePrizeDialog = () => {
  const { formData, setFormData, setInputDialog } = useUIStore();

  const handleSubmit = (prizes: Prize[]) => {
    setFormData({
      ...formData,
      prizes: [...formData.prizes, ...prizes],
    });
    setInputDialog(null);
  };

  return (
    <DialogWrapper title="Prize" onClose={() => setInputDialog(null)}>
      <PrizeDialog onSubmit={handleSubmit} />
    </DialogWrapper>
  );
};

export default CreatePrizeDialog;
