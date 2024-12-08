import { CloseIcon } from "@/components/Icons";

interface DialogWrapperProps {
  title: string;
  onClose: () => void;
  children: React.ReactNode;
}

export const DialogWrapper = ({
  title,
  onClose,
  children,
}: DialogWrapperProps) => {
  return (
    <>
      <div className="absolute inset-0 w-full h-full bg-black/50" />
      <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-1/2 bg-terminal-black border border-terminal-green py-5">
        <div className="flex flex-col">
          <div className="flex relative text-4xl h-20 w-full font-bold uppercase items-center justify-center">
            <p className="text-center">{title}</p>
            <span
              className="absolute top-5 right-5 w-10 h-10 text-terminal-green cursor-pointer"
              onClick={onClose}
            >
              <CloseIcon />
            </span>
          </div>
        </div>
        {children}
      </div>
    </>
  );
};
