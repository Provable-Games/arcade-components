import { Button } from "@/components/buttons/Button";
import { ChevronIcon } from "../Icons";

interface PaginationProps {
  currentPage: number;
  setCurrentPage: (page: number) => void;
  totalPages: number;
}

const Pagination = ({
  currentPage,
  setCurrentPage,
  totalPages,
}: PaginationProps) => {
  const handleClick = (page: number) => {
    setCurrentPage(page);
  };

  return (
    <div className="flex justify-center">
      <Button
        variant={"outline"}
        onClick={() => currentPage > 1 && handleClick(currentPage - 1)}
        disabled={currentPage === 1}
      >
        <span
          className={`w-3 h-3 text-terminal-green rotate-180 ${
            currentPage === 1 ? "text-terminal-green/25" : "text-terminal-green"
          }`}
        >
          <ChevronIcon />
        </span>
      </Button>

      <Button
        variant={currentPage === 1 ? "default" : "outline"}
        key={1}
        onClick={() => handleClick(1)}
      >
        {1}
      </Button>

      <Button
        variant={currentPage === totalPages ? "default" : "outline"}
        key={totalPages}
        onClick={() => handleClick(totalPages)}
      >
        {totalPages}
      </Button>

      <Button
        variant={"outline"}
        onClick={() => currentPage < totalPages && handleClick(currentPage + 1)}
        disabled={currentPage === totalPages}
      >
        <span
          className={`w-3 h-3 text-terminal-green ${
            currentPage === totalPages
              ? "text-terminal-green/25"
              : "text-terminal-green"
          }`}
        >
          <ChevronIcon />
        </span>
      </Button>
    </div>
  );
};

export default Pagination;
