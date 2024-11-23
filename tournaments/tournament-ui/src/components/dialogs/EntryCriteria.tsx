import { CloseIcon } from "../Icons";
import { EntryCriteria } from "@/lib/types";

interface EntryCriteriaDialogProps {
  setShowEntryCriteria: (show: boolean) => void;
  entryCriteria: EntryCriteria[];
}

const EntryCriteriaDialog = ({
  setShowEntryCriteria,
  entryCriteria,
}: EntryCriteriaDialogProps) => {
  return (
    <>
      <div className="absolute inset-0 w-full h-full bg-black/50 z-10" />
      <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-1/2 bg-terminal-black border border-terminal-green py-5 z-20">
        <div className="flex flex-col">
          <div className="flex relative text-4xl h-20 w-full font-bold uppercase items-center justify-center">
            <p className="text-center">Entry Criteria</p>
            <span
              className="absolute top-5 right-5 w-10 h-10 text-terminal-green cursor-pointer"
              onClick={() => setShowEntryCriteria(false)}
            >
              <CloseIcon />
            </span>
          </div>
          <div className="flex flex-col gap-2 w-full items-center max-h-[400px] overflow-y-auto">
            {entryCriteria.map((criteria, index) => (
              <div key={index} className="text-lg">
                {criteria.token_id}
                {criteria.entry_count}
              </div>
            ))}
          </div>
        </div>
      </div>
    </>
  );
};

export default EntryCriteriaDialog;
