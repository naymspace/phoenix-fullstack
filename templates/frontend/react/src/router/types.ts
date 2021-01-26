export interface ParamTypes {
  param: string;
}

export type Route = {
  acceptParam?: boolean;
  accessLevel?: string;
  component: () => JSX.Element;
  route: string;
};
