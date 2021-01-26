import { action, ActionType } from 'typesafe-actions';

export type MenuState = {
  isMainMenuOpen: boolean;
  isFilterOpen: boolean;
};

const initialState: MenuState = {
  isFilterOpen: false,
  isMainMenuOpen: false,
};

const IS_MAIN_MENU_OPEN = 'IS_MAIN_MENU_OPEN';
const IS_FILTER_OPEN = 'IS_FILTER_OPEN';

export const setIsMainMenuOpen = (payload: { isOpen: boolean }) => action(IS_MAIN_MENU_OPEN, payload);

export const setIsFilterOpen = (payload: { isOpen: boolean }) => action(IS_FILTER_OPEN, payload);

type MenuActions = ActionType<typeof setIsMainMenuOpen | typeof setIsFilterOpen>;

const reducer = (state: MenuState = initialState, action: MenuActions) => {
  switch (action.type) {
    case IS_MAIN_MENU_OPEN:
      return { ...state, isFilterOpen: false, isMainMenuOpen: action.payload.isOpen };
    case IS_FILTER_OPEN:
      return { ...state, isFilterOpen: action.payload.isOpen, isMainMenuOpen: false };
    default:
      return state;
  }
};

export default reducer;
