import axios from 'axios';
import { Action } from 'redux';
import { ThunkAction } from 'redux-thunk';
import { action, ActionType } from 'typesafe-actions';

import { StoreState } from '..';
import { ExampleData } from '../../types/ExampleData';
import { API_INDEX, EXAMPLE } from '../apiRoutes';

export type GetExampleDetailState = {
  data: ExampleData | undefined;
  isLoading: boolean;
  hasError: boolean;
};

const initialState: GetExampleDetailState = { data: undefined, hasError: false, isLoading: false };

const REQUEST_EXAMPLE_DETAIL = 'REQUEST_EXAMPLE_DETAIL';
const RECEIVE_EXAMPLE_DETAIL = 'RECEIVE_EXAMPLE_DETAIL';
const RESET_EXAMPLE_DETAIL = 'RESET_EXAMPLE_DETAIL';
const RECEIVE_EXAMPLE_DETAIL_ERROR = 'RECEIVE_EXAMPLE_DETAIL_ERROR';

export const requestExampleDetail = () => {
  return action(REQUEST_EXAMPLE_DETAIL);
};
export const receiveExampleDetail = (payload: { data: ExampleData }) => {
  return action(RECEIVE_EXAMPLE_DETAIL, payload);
};
export const resetExampleDetail = () => {
  return action(RESET_EXAMPLE_DETAIL);
};
export const receiveExampleDetailError = () => action(RECEIVE_EXAMPLE_DETAIL_ERROR);

export const getExampleDetailAsync = (id: string): ThunkAction<void, StoreState, unknown, Action<string>> => (
  dispatch,
) => {
  dispatch(requestExampleDetail());

  axios
    .get(API_INDEX + EXAMPLE + '/' + id, {
      headers: {},
    })
    .then((res) => {
      dispatch(
        receiveExampleDetail({
          data: res.data.data,
        }),
      );
    })
    .catch(() => {
      dispatch(receiveExampleDetailError());
    });
};

type GetExampleDetailActions = ActionType<
  | typeof requestExampleDetail
  | typeof receiveExampleDetail
  | typeof receiveExampleDetailError
  | typeof resetExampleDetail
>;

const reducer = (
  state: GetExampleDetailState = initialState,
  action: GetExampleDetailActions,
): GetExampleDetailState => {
  switch (action.type) {
    case REQUEST_EXAMPLE_DETAIL:
      return { ...state, isLoading: true };
    case RECEIVE_EXAMPLE_DETAIL:
      return {
        ...state,
        data: action.payload.data,
        hasError: false,
        isLoading: false,
      };
    case RECEIVE_EXAMPLE_DETAIL_ERROR:
      return { ...state, hasError: true, isLoading: false };
    case RESET_EXAMPLE_DETAIL:
      return { ...state, data: initialState.data };
    default:
      return { ...state };
  }
};

export default reducer;
