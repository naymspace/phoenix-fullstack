import axios from 'axios';
import { Action } from 'redux';
import { ThunkAction } from 'redux-thunk';
import { action, ActionType } from 'typesafe-actions';

import { ExampleData } from '../../types/ExampleData';
import { API_INDEX, EXAMPLE } from '../apiRoutes';
import { StoreState } from '../index';

export type GetExampleListState = {
  data: Array<ExampleData>;
  hasError: boolean;
  isLoading: boolean;
};

const initialState: GetExampleListState = { data: [], hasError: false, isLoading: false };

const REQUEST_EXAMPLE_LIST = 'REQUEST_EXAMPLE_LIST';
const RECEIVE_EXAMPLE_LIST = 'RECEIVE_EXAMPLE_LIST';
const RECEIVE_EXAMPLE_LIST_ERROR = 'RECEIVE_EXAMPLE_LIST_ERROR';

export const requestExampleList = () => {
  return action(REQUEST_EXAMPLE_LIST);
};

export const receiveExampleList = (payload: { data: Array<ExampleData> }) => {
  return action(RECEIVE_EXAMPLE_LIST, payload);
};

export const receiveExampleListError = () => action(RECEIVE_EXAMPLE_LIST_ERROR);

export const getExampleListAsync = (): ThunkAction<void, StoreState, unknown, Action<string>> => (dispatch) => {
  dispatch(requestExampleList());

  axios
    .get(API_INDEX + EXAMPLE, {
      headers: {},
    })
    .then((res) => {
      dispatch(
        receiveExampleList({
          data: res.data.data,
        }),
      );
    })
    .catch(() => {
      dispatch(receiveExampleListError());
    });
};

type GetExampleListActions = ActionType<
  typeof requestExampleList | typeof receiveExampleList | typeof receiveExampleListError
>;

const reducer = (state: GetExampleListState = initialState, action: GetExampleListActions): GetExampleListState => {
  switch (action.type) {
    case REQUEST_EXAMPLE_LIST:
      return { ...state, isLoading: true };
    case RECEIVE_EXAMPLE_LIST:
      return {
        ...state,
        data: action.payload.data,
        hasError: false,
        isLoading: false,
      };
    case RECEIVE_EXAMPLE_LIST_ERROR:
      return { ...state, hasError: true, isLoading: false };
    default:
      return { ...state };
  }
};

export default reducer;
