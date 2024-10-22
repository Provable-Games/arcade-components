import { overridableComponent } from "@dojoengine/recs";
import { ContractComponents } from "./generated/contractComponents";

export type ClientComponents = ReturnType<typeof createClientComponents>;

export function createClientComponents({
  contractComponents,
}: {
  contractComponents: ContractComponents;
}) {
  return {
    ...contractComponents,
    ClientCreator: overridableComponent(contractComponents.ClientCreatorModel),
    ClientPlayPlayer: overridableComponent(
      contractComponents.ClientPlayPlayerModel
    ),
    ClientPlayTotal: overridableComponent(
      contractComponents.ClientPlayTotalModel
    ),
    ClientRatingTotal: overridableComponent(
      contractComponents.ClientRatingTotalModel
    ),
    ClientRatingPlayer: overridableComponent(
      contractComponents.ClientRatingPlayerModel
    ),
    ClientRegistration: overridableComponent(
      contractComponents.ClientRegistrationModel
    ),
    ClientTotal: overridableComponent(contractComponents.ClientTotalModel),
    ERC721Owner: overridableComponent(contractComponents.ERC721OwnerModel),
  };
}
