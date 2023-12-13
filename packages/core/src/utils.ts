import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export { cva } from "class-variance-authority";

export { clsx };

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
