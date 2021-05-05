import React, { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';

import { StoreState } from '../../store';
import { getExampleListAsync } from '../../store/example/getExampleList';

const ExampleList = () => {
  const dispatch = useDispatch();

  useEffect(() => {
    dispatch(getExampleListAsync());
  }, [dispatch]);

  const { data, isLoading, hasError } = useSelector((s: StoreState) => s.example.exampleList);

  if (isLoading) {
    return <div>Lade...</div>;
  } else if (hasError) {
    return <div>Error loading resources!</div>;
  } else {
    return (
      <div className="example-list">
        {data.map((d) => {
          return (
            <a key={d.id} href={'example/' + d.id}>
              <p>{d.id}</p>
            </a>
          );
        })}
      </div>
    );
  }
};

export default ExampleList;
