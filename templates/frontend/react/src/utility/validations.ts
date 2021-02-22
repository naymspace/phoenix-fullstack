import { validate } from 'email-validator';

export const notEmptyHint = (hint: string) => {
  return (valueToValidate: string) => {
    return isNotEmpty(valueToValidate) ? null : hint;
  };
};

export const isZipHint = (hint: string) => {
  return (valueToValidate: string) => {
    return isValidZip(valueToValidate) ? null : hint;
  };
};

export const isValidEmailHint = (hint: string) => {
  return (valueToValidate: string) => {
    return isValidEmail(valueToValidate) ? null : hint;
  };
};

export const isValidPasswordHint = (hint: string) => {
  return (val: string) => {
    return isValidPassword(val) ? null : hint;
  };
};

export const isValidPassword = (val: string) => {
  return val.length >= 8 && val.includes(' ') === false;
};

export const isNotEmpty = (valueToValidate: string) => {
  return valueToValidate.length >= 1;
};

export const isValidZip = (valueToValidate: string) => {
  return valueToValidate.match(/^\d{5}$/) !== null;
};

export const isValidEmail = (valueToValidate: string) => {
  return validate(valueToValidate);
};
