import { AnyAction, combineReducers } from 'redux';

import MenuReducer from './appState/menus';
import ExampleDetailReducer from './example/getExampleDetail';
import ExampleListReducer from './example/getExampleList';

const appReducer = combineReducers({
  appState: combineReducers({
    menu: MenuReducer,
  }),
  example: combineReducers({
    exampleDetail: ExampleDetailReducer,
    exampleList: ExampleListReducer,
  }),
});

export type StoreState = ReturnType<typeof appReducer>;

const rootReducer = (state: StoreState | undefined, action: AnyAction) => {
  if (action.type === 'LOGOUT_USER_SUCCESS') {
    // store is completely wiped on logout
    const newState: StoreState = rootReducer(undefined, { type: '' });
    state = newState;
  }
  return appReducer(state, action);
};

export default rootReducer;
