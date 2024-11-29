import { Prize } from "@/lib/types";
import PrizeBox from "@/components/create/PrizeBox";

interface PrizeBoxesProps {
  prizes: Prize[];
}

const PrizeBoxes = ({ prizes }: PrizeBoxesProps) => {
  return (
    <>
      {Object.entries(
        prizes.reduce((acc, prize) => {
          const key = prize.token;
          const isERC20 = prize.tokenDataType.activeVariant() === "erc20";
          if (isERC20) {
            if (!acc[key]) acc[key] = [];
            acc[key].push(prize);
          } else {
            acc[key] = [prize];
          }
          return acc;
        }, {} as Record<string, typeof prizes>)
      ).map(([token, prizes], index) => {
        const variant = prizes[0].tokenDataType.activeVariant() as
          | "erc20"
          | "erc721";
        const isERC20 = variant === "erc20";
        const totalAmount = isERC20
          ? prizes.reduce(
              (sum, prize) =>
                sum + Number(prize.tokenDataType.variant.erc20?.token_amount),
              0
            )
          : null; // Return null for ERC721 since we don't want to sum them
        return (
          <PrizeBox
            key={index}
            token={token}
            variant={variant}
            prizes={prizes}
            totalAmount={totalAmount}
          />
        );
      })}
    </>
  );
};

export default PrizeBoxes;
