import { useState, ChangeEvent } from "react";
import { Button } from "@/components/buttons/Button";
import useUIStore from "@/hooks/useUIStore";
import { PlusIcon } from "@/components/Icons";
import { CairoCustomEnum, CairoOption, CairoOptionVariant } from "starknet";

const GatedAddresses = () => {
  const { setFormData, setInputDialog, formData } = useUIStore();

  const [addresses, setAddresses] = useState<string[] | null>([""]);

  const handleAddressChange = (
    e: ChangeEvent<HTMLInputElement>,
    index: number
  ) => {
    const { value } = e.target;
    setAddresses((prev) => {
      const newAddresses = [...prev!];
      newAddresses[index] = value;
      return newAddresses;
    });
  };

  return (
    <div className="flex flex-col gap-5 items-center justify-center">
      <div className="flex flex-row w-full items-center bg-terminal-green text-terminal-black h-10 px-5 justify-between">
        <div className="flex flex-row items-center gap-5">
          <p className="text-2xl uppercase">Add Addresses</p>
          <p>Must be a valid address</p>
        </div>
      </div>
      <div className="flex flex-col gap-2 w-full items-center max-h-[400px] overflow-y-auto">
        {addresses?.map((address, index) => (
          <div className="px-10 w-full flex flex-row items-center justify-between">
            <p className="uppercase text-xl">Address {index + 1}:</p>
            <input
              type="text"
              name={`token-${index}`}
              onChange={(e) => handleAddressChange(e, index)}
              className="p-1 m-2 w-3/4 h-8 text-lg bg-terminal-black border border-terminal-green"
            />
          </div>
        ))}
        <Button
          className="m-5 w-20"
          variant="token"
          onClick={() => setAddresses((prev) => [...prev!, ""])}
        >
          <span className="w-4 h-4">
            <PlusIcon />
          </span>
        </Button>
      </div>
      <Button
        variant="token"
        size="lg"
        disabled={!!addresses && addresses[0] === ""}
        onClick={() => {
          const gatedTypeEnum = new CairoCustomEnum({
            token: undefined,
            tournament: undefined,
            address: addresses!, // the active variant with the addresses array
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
        Add Gated Addresses
      </Button>
    </div>
  );
};

export default GatedAddresses;
