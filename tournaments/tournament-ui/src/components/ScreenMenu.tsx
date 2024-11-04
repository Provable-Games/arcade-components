import React, { useEffect, useState, useRef, useCallback } from "react";
import { Button } from "./buttons/Button";
import { soundSelector, useUiSounds } from "../hooks/useUiSound";
import { Menu } from "../lib/types";
import useUIStore from "../hooks/useUIStore";
import { useNavigate } from "react-router-dom";
import { useLocation } from "react-router-dom";

export interface ButtonData {
  id: number;
  label: string;
  value: string;
  path: string;
  disabled?: boolean;
}

interface HorizontalKeyboardControlProps {
  buttonsData: Menu[];
  disabled?: boolean[];
}

const HorizontalKeyboardControl: React.FC<HorizontalKeyboardControlProps> = ({
  buttonsData,
  disabled,
}) => {
  const navigate = useNavigate();
  const location = useLocation();
  const { play } = useUiSounds(soundSelector.click);
  const [selectedIndex, setSelectedIndex] = useState(0);
  const buttonRefs = useRef<(HTMLButtonElement | null)[]>([]);
  const screen = useUIStore((state) => state.screen);

  const handleKeyDown = useCallback(
    (event: KeyboardEvent) => {
      const getNextEnabledIndex = (currentIndex: number, direction: number) => {
        let newIndex = currentIndex + direction;

        while (
          newIndex >= 0 &&
          newIndex < buttonsData.length &&
          buttonsData[newIndex].disabled
        ) {
          newIndex += direction;
        }

        return newIndex;
      };
      // Adding a null check for e.target
      if (!event.target) return;
      const target = event.target as HTMLElement;
      // Check if the target is an input element
      if (target.tagName.toLowerCase() === "input") {
        // If it's an input element, allow default behavior (moving cursor within the input)
        return;
      }

      switch (event.key) {
        case "ArrowLeft":
          play();
          setSelectedIndex((prev) => {
            const newIndex = getNextEnabledIndex(prev, -1);
            return newIndex < 0 ? prev : newIndex;
          });
          break;
        case "ArrowRight":
          play();
          setSelectedIndex((prev) => {
            const newIndex = getNextEnabledIndex(prev, 1);
            return newIndex >= buttonsData.length ? prev : newIndex;
          });
          break;
      }
    },
    [selectedIndex, buttonsData, play]
  );

  useEffect(() => {
    window.addEventListener("keydown", handleKeyDown);
    return () => {
      window.removeEventListener("keydown", handleKeyDown);
    };
  }, [selectedIndex, handleKeyDown]);

  return (
    <div className="flex justify-between sm:justify-start w-full">
      {buttonsData.map((buttonData, index) => (
        <Button
          className="px-2.5 sm:px-3 h-10 w-auto"
          key={buttonData.id}
          ref={(ref) => (buttonRefs.current[index] = ref)}
          variant={
            buttonData.path === location.pathname ? "default" : "outline"
          }
          onClick={() => {
            setSelectedIndex(index);
            navigate(buttonData.path);
          }}
          disabled={disabled ? disabled[index] : false}
        >
          {buttonData.label}
        </Button>
      ))}
    </div>
  );
};

export default HorizontalKeyboardControl;
