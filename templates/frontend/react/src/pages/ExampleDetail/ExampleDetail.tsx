import React, { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useParams } from 'react-router-dom';

import { ParamTypes } from '../../router/types';
import { StoreState } from '../../store';
import { getExampleDetailAsync, resetExampleDetail } from '../../store/example/getExampleDetail';
import './ExampleDetail.sass';

const ExampleDetail = () => {
  const dispatch = useDispatch();
  const { param } = useParams<ParamTypes>();

  const data = useSelector((s: StoreState) => s.example.exampleDetail);

  useEffect(() => {
    dispatch(getExampleDetailAsync(param));
    return function cleanup() {
      dispatch(resetExampleDetail());
    };
  }, [dispatch, param]);

  if (data.isLoading) {
    return <div>Laden...</div>;
  } else if (!data.hasError && data.data) {
    return <div>{JSON.stringify(data.data)}</div>;
  } else {
    return <div className="error">Fehler!</div>;
  }
};

export default ExampleDetail;
