import React, { useCallback } from 'react';
import { useHistory } from 'react-router-dom';

const PageNotFound = () => {
  const history = useHistory();

  const onClickBack = useCallback(() => {
    history.push('/');
  }, [history]);

  return (
    <>
      <div>Not found</div>
      <button onClick={onClickBack}>Back to main page</button>
    </>
  );
};

export default PageNotFound;
