import React, { useState } from "react";
import CloseButton from "../CloseButton/CloseButton";

interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  children: JSX.Element | JSX.Element[];
}

export default function Modal({ isOpen, onClose, children }: ModalProps) {
  const closeModal = () => {
    onClose();
  };

  return (
    <div
      className={`fixed inset-0 z-50 flex items-center justify-center ${
        isOpen ? "visible" : "hidden"
      }`}
    >
      <div className="fixed inset-0 bg-black opacity-50"></div>
      <div className="absolute top-2 right-2">
        <CloseButton title="Close" key={"modal-close"} onClick={closeModal} />
      </div>
      <div className="bg-gray-800 rounded-lg p-8 max-w-xl z-10">{children}</div>
    </div>
  );
}
