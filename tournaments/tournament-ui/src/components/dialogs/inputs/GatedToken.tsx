import { useState, ChangeEvent } from "react";
import { Button } from "@/components/buttons/Button";
import { PlusIcon } from "@/components/Icons";
import { EntryCriteria } from "@/lib/types";
import { useNavigate } from "react-router-dom";
import useUIStore from "@/hooks/useUIStore";
import { CairoCustomEnum, CairoOption, CairoOptionVariant } from "starknet";

const GatedTokenDialog = () => {
  const navigate = useNavigate();
  const { setInputDialog } = useUIStore();
  const [selectedToken, setSelectedToken] = useState<string | null>(null);
  const [selectedEntryType, setSelectedEntryType] = useState<string>("uniform");
  const [uniformEntryCount, setUniformEntryCount] = useState<number | null>(
    null
  );
  const [entryCriteria, setEntryCriteria] = useState<EntryCriteria[]>([]);
  const tokensList = ["Blobert", "Survivor"];
  const { formData, setFormData } = useUIStore();

  const handleChangeUniformEntry = (e: ChangeEvent<HTMLInputElement>) => {
    const { value } = e.target;
    setUniformEntryCount(parseInt(value));
  };

  const handleChangeEntryCriteriaToken =
    (index: number) => (e: ChangeEvent<HTMLInputElement>) => {
      const { value } = e.target;
      setEntryCriteria((prev) =>
        prev.map((criteria, i) =>
          i === index ? { ...criteria, token_id: parseInt(value) } : criteria
        )
      );
    };

  const handleChangeEntryCriteriaCount =
    (index: number) => (e: ChangeEvent<HTMLInputElement>) => {
      const { value } = e.target;
      setEntryCriteria((prev) =>
        prev.map((criteria, i) =>
          i === index ? { ...criteria, entry_count: parseInt(value) } : criteria
        )
      );
    };

  return (
    <div className="flex flex-col items-center justify-center">
      <div className="flex flex-row w-full items-center bg-terminal-green text-terminal-black h-10 px-5 justify-between">
        <div className="flex flex-row items-center gap-5">
          <p className="text-2xl uppercase">Select Token</p>
          <p>Gated Token can only be ERC721</p>
        </div>
        <div className="flex flex-row items-center gap-5">
          <p>Token not displaying?</p>
          <Button
            variant="token"
            onClick={() => {
              navigate("/register-token");
              setInputDialog(null);
            }}
            className="hover:text-terminal-black"
          >
            <p>Register Token</p>
          </Button>
        </div>
      </div>
      <div className="h-28 px-10 w-full flex flex-row items-center gap-5">
        {tokensList.map((token) => {
          return (
            <Button
              variant={selectedToken === token ? "default" : "token"}
              onClick={() => setSelectedToken(token)}
            >
              {token}
            </Button>
          );
        })}
      </div>
      <div className="flex flex-row w-full items-center bg-terminal-green text-terminal-black h-10 px-5 justify-between">
        <p className="text-2xl uppercase">Entry Type</p>
      </div>
      <div className="h-20 px-10 w-full flex flex-row items-center justify-center gap-5">
        <Button
          variant={selectedEntryType === "uniform" ? "default" : "token"}
          size="lg"
          onClick={() => setSelectedEntryType("uniform")}
        >
          Uniform
        </Button>
        <Button
          variant={selectedEntryType === "criteria" ? "default" : "token"}
          size="lg"
          onClick={() => setSelectedEntryType("criteria")}
        >
          Entry Criteria
        </Button>
      </div>
      {selectedEntryType === "criteria" ? (
        <>
          <div className="flex flex-row w-full items-center bg-terminal-green text-terminal-black h-10 px-5 justify-between">
            <p className="text-2xl uppercase">Add Entry Criteria</p>
          </div>
          <div className="flex flex-col gap-2 w-full items-center max-h-[250px] overflow-y-auto">
            {entryCriteria.map((criteria, index) => (
              <div className="flex flex-row gap-20">
                <div className="flex flex-row items-center gap-5">
                  <p className="uppercase">Token ID</p>
                  <input
                    type="number"
                    name="token-id"
                    onChange={handleChangeEntryCriteriaToken(index)}
                    className="p-1 m-2 w-20 h-8 2xl:text-2xl bg-terminal-black border border-terminal-green"
                  />
                </div>
                <div className="flex flex-row items-center gap-5">
                  <p className="uppercase">Number of Entries</p>
                  <input
                    type="number"
                    name="entry-criteria-count"
                    onChange={handleChangeEntryCriteriaCount(index)}
                    className="p-1 m-2 w-20 h-8 2xl:text-2xl bg-terminal-black border border-terminal-green"
                  />
                </div>
              </div>
            ))}
            <Button
              className="m-5 w-20"
              variant="token"
              onClick={() => {
                setEntryCriteria((prev) => [
                  ...prev!,
                  {
                    token_id: 0,
                    entry_count: 0,
                  },
                ]);
              }}
            >
              <span className="w-4 h-4">
                <PlusIcon />
              </span>
            </Button>
          </div>
        </>
      ) : (
        <>
          <div className="flex flex-row w-full items-center bg-terminal-green text-terminal-black h-10 px-5 justify-between">
            <p className="text-2xl uppercase">Add Entry Count</p>
          </div>
          <div className="h-40 px-10 py-5 w-full flex flex-col justify-center items-center">
            <div className="flex flex-row gap-20">
              <div className="flex flex-row items-center gap-5">
                <p className="uppercase">Number of Entries</p>
                <input
                  type="number"
                  name="entry-count"
                  onChange={handleChangeUniformEntry}
                  className="p-1 m-2 w-20 h-8 2xl:text-2xl bg-terminal-black border border-terminal-green"
                />
              </div>
            </div>
          </div>
        </>
      )}
      <Button
        variant="token"
        size="lg"
        disabled={
          !selectedToken ||
          !selectedEntryType ||
          (selectedEntryType === "uniform" && !uniformEntryCount) ||
          (selectedEntryType === "criteria" && entryCriteria.length === 0)
        }
        onClick={() => {
          const gatedTypeEnum = new CairoCustomEnum({
            token: {
              token: selectedToken!,
              entry_type: new CairoCustomEnum({
                criteria:
                  selectedEntryType === "criteria" ? entryCriteria : undefined,
                uniform:
                  selectedEntryType === "uniform"
                    ? uniformEntryCount!!
                    : undefined,
              }),
            },
            tournament: undefined,
            address: undefined,
          });

          const someGatedType = new CairoOption(
            CairoOptionVariant.Some,
            gatedTypeEnum
          );

          setFormData({
            ...formData,
            gatedType: someGatedType,
          });
          setInputDialog(null);
        }}
      >
        Add Gated Token
      </Button>
    </div>
  );
};

export default GatedTokenDialog;
